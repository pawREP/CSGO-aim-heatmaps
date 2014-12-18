#include <sourcemod>
#include <sdktools>
#include <vector>

public Plugin:myinfo =
{
	name = "AimHeatmapData",
	author = "PascalTheAnalyst",
	description = "This script calculates and saves data which can be used to plot a heatmap of the players aiming accuracy",
	version = "2.02",
	url = "reddit.com/u/PascalTheAnalyst"
};

public OnPluginStart()
{
	HookEvent("bullet_impact", bi);
}

public bi(Handle:event,const String:name[],bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid"));
	
	decl Float:attackerEyePos[3];
	GetClientEyePosition(userid, attackerEyePos);
	
	decl Float:impactLoc[3];
	impactLoc[0] = GetEventFloat(event,"x");
	impactLoc[1] = GetEventFloat(event,"y");
	impactLoc[2] = GetEventFloat(event,"z");
	
	new Float:dRef=99999.0;
	new Float:d;
	
	new targetClient=0;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && (GetClientTeam(i)!=GetClientTeam(userid)) && IsPlayerAlive(i))
		{
			decl Float:x0[3];//target eye pos
			GetClientEyePosition(i, x0);	
			decl Float:x1[3];//attackers eye pos
			x1=attackerEyePos;	
			decl Float:x2[3];//impact pos
			x2=impactLoc		
			decl Float:x01[3];
			decl Float:x02[3];
			decl Float:x21[3];
			SubtractVectors(x0, x1, x01);
			SubtractVectors(x0, x2, x02);
			SubtractVectors(x2, x1, x21);
			GetVectorCrossProduct(x01, x02, x01);
			d = NormalizeVector(x01, x01)/NormalizeVector(x21, x21);
			if(d<dRef)
			{
				dRef=d;
				targetClient=i;
			}
			
		}
	}  
	
	if(targetClient!=0){
		new Float:targetEyePos[3];//targets eye pos
		GetClientEyePosition(targetClient, targetEyePos);	
		
		new Float:a1[3]; //targt-attacker vector
		SubtractVectors(targetEyePos,attackerEyePos,a1);
		NormalizeVector(a1,a1);
		new Float:a2[3]; //first ortogonalvector to a1
		a2[0] = -a1[1];
		a2[1] = a1[0];
		a2[2] = 0.0; 
		NormalizeVector(a2,a2);
		new Float:a3[3]; //second ortogonalvector to a1 (and a2)
		GetVectorCrossProduct(a2,a1,a3); 
		NormalizeVector(a3,a3);
		
		new Float:l[3];
		SubtractVectors(impactLoc,attackerEyePos,l);
		new Float:n[3];
		SubtractVectors(targetEyePos,attackerEyePos,n);
		new Float:d;
		d=-GetVectorDotProduct(n,n)/GetVectorDotProduct(l,n);
		NegateVector(n);
		ScaleVector(l,d);
		new Float:i[3];
		AddVectors(n,l,i);
		new Float:res[2];
		res[0]=GetVectorDotProduct(i,a2);
		res[1]=GetVectorDotProduct(i,a3);
		
		if(SquareRoot(res[0]*res[0]+res[1]*res[1])<250){
			
			decl String:path[PLATFORM_MAX_PATH];
			BuildPath(Path_SM,path,PLATFORM_MAX_PATH,"AimHeatmapData.txt");
			new Handle:fileHandle=OpenFile(path,"a");
			WriteFileLine(fileHandle,"%f,%f, %f",userid,res[0],res[1]);
			CloseHandle(fileHandle);
		}
		
	}
}

