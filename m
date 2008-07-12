Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n4.bullet.ukl.yahoo.com ([217.146.182.181])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KHSsX-0004v4-DO
	for linux-dvb@linuxtv.org; Sat, 12 Jul 2008 02:22:23 +0200
Date: Fri, 11 Jul 2008 20:21:40 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>, Discussion about mythtv
	<mythtv-users@mythtv.org>
Message-Id: <1215822101l.26120l.0l@manu-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-17hairn8cj7Ik9m5l9sT"
Subject: [linux-dvb] (Crude) Patch to support latest multiproto drivers (as
 of 2008-07-11
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--=-17hairn8cj7Ik9m5l9sT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

	Hi all,
subject says it all. This patch (that applies to trunk, but probably=20
also for 0.21.fixes) allows myth to tune with the latest multiproto=20
drivers.
No DVB-S2 support here, its a crude patch, but it works for DVB-S.
Bye
Manu


--=-17hairn8cj7Ik9m5l9sT
Content-Type: text/x-patch; charset=us-ascii; name=mythtv-multiproto.patch
Content-Disposition: attachment; filename=mythtv-multiproto.patch
Content-Transfer-Encoding: quoted-printable

--- ../../trunk/mythtv/libs/libmythtv/dvbchannel.cpp	2008-07-10 22:02:57.00=
0000000 -0400
+++ libs/libmythtv/dvbchannel.cpp	2008-07-11 18:33:33.000000000 -0400
@@ -211,8 +211,16 @@
     }
     VERBOSE(VB_IMPORTANT, LOC + "Getting additional DVBFE_GET_INFO informa=
tion." + ENO);
     dvbfe_info fe_info;
+    enum dvbfe_delsys delsys =3D DVBFE_DELSYS_DVBS;
     bzero(&fe_info, sizeof(fe_info));
-    fe_info.delivery =3D DVBFE_DELSYS_DVBS;
+    if (ioctl(fd_frontend, DVBFE_SET_DELSYS, &delsys)<0)
+    {
+        VERBOSE(VB_IMPORTANT, LOC_ERR + "Failed to set delivery system." +=
 ENO);
+        close(fd_frontend);
+        fd_frontend =3D -1;
+    }
+       =20
+    //fe_info.delivery =3D DVBFE_DELSYS_DVBS;
     if (ioctl(fd_frontend, DVBFE_GET_INFO, &fe_info) < 0)
     {
         VERBOSE(VB_IMPORTANT, LOC_ERR +
@@ -773,42 +781,49 @@
 	// check for multiproto API
 	if ((DVB_API_VERSION =3D=3D 3) && (DVB_API_VERSION_MINOR =3D=3D 3)) {
 		struct dvbfe_params fe_params;
-		unsigned int delsys =3D DVBFE_DELSYS_DVBS; //TODO: should come from conf=
iguration/database
+		enum dvbfe_delsys delsys =3D DVBFE_DELSYS_DVBS; //TODO: should come from=
 configuration/database
=20
 		VERBOSE(VB_CHANNEL, LOC + "Tune(): " +
                         QString("API minor version=3D%1, delivery system =
=3D %2").arg(DVB_API_VERSION_MINOR).arg(delsys));
=20
 		fe_params.frequency =3D params.frequency;
-		fe_params.inversion =3D DVBFE_INVERSION_AUTO;
+		fe_params.inversion =3D INVERSION_AUTO;
 	=09
 		switch (delsys)=20
 		{
-		case DVBFE_DELSYS_DVBS:
-			fe_params.delsys.dvbs.symbol_rate =3D params.u.qpsk.symbol_rate;
-			fe_params.delsys.dvbs.fec =3D DVBFE_FEC_AUTO;
-			fe_params.delsys.dvbs.modulation =3D DVBFE_MOD_AUTO;
-            		fe_params.delivery=3D DVBFE_DELSYS_DVBS;
-			VERBOSE(VB_CHANNEL, LOC + "Tune(): " +
-                        	QString("Frequency =3D %2, Srate =3D %3 (DVB-S)")=
..arg(fe_params.frequency).arg(fe_params.delsys.dvbs.symbol_rate));
-			break;
-		case DVBFE_DELSYS_DVBS2:
-			fe_params.delsys.dvbs2.symbol_rate =3D params.u.qpsk.symbol_rate; //TOD=
O: should use the new symbol_rate type
-			fe_params.delsys.dvbs2.fec =3D DVBFE_FEC_AUTO; //TODO: should use the n=
ew FEC options
-			fe_params.delsys.dvbs.modulation =3D DVBFE_MOD_AUTO;
-            		fe_params.delivery=3D DVBFE_DELSYS_DVBS2;
-			VERBOSE(VB_CHANNEL, LOC + "Tune(): " +
-                        	QString("Frequency =3D %2, Srate =3D %3 (DVB-S2)"=
).arg(fe_params.frequency).arg(fe_params.delsys.dvbs2.symbol_rate));
-			break;
-		default:
-			return false;
+                                            case DVBFE_DELSYS_DVBS:
+                                                fe_params.delsys.dvbs.symb=
ol_rate =3D params.u.qpsk.symbol_rate;
+                                                fe_params.delsys.dvbs.fec =
=3D DVBFE_FEC_AUTO;
+                                                fe_params.delsys.dvbs.modu=
lation =3D DVBFE_MOD_AUTO;
+                                                //fe_params.delivery=3D DV=
BFE_DELSYS_DVBS;
+                                                VERBOSE(VB_CHANNEL, LOC + =
"Tune(): " +
+                                                        QString("Frequency=
 =3D %2, Srate =3D %3 (DVB-S)")
+                                                        .arg(fe_params.fre=
quency).arg(fe_params.delsys.dvbs.symbol_rate));
+                                                break;
+                                            case DVBFE_DELSYS_DVBS2:
+                                                fe_params.delsys.dvbs2.sym=
bol_rate =3D params.u.qpsk.symbol_rate; //TODO: should use the new symbol_r=
ate type
+                                                fe_params.delsys.dvbs2.fec=
 =3D DVBFE_FEC_AUTO; //TODO: should use the new FEC options
+                                                fe_params.delsys.dvbs.modu=
lation =3D DVBFE_MOD_AUTO;
+                                                fe_params.delivery=3D DVBF=
E_DELSYS_DVBS2;
+                                                VERBOSE(VB_CHANNEL, LOC + =
"Tune(): " +
+                                                        QString("Frequency=
 =3D %2, Srate =3D %3 (DVB-S2)")
+                                                        .arg(fe_params.fre=
quency).arg(fe_params.delsys.dvbs2.symbol_rate));
+                                                break;
+                                            default:
+                                                return false;
 		}
 		VERBOSE(VB_CHANNEL, LOC + "Tune(): " +
-                        QString("Frequency =3D %1, Srate =3D %2 (SET_PARAM=
S)").arg(fe_params.frequency).arg(fe_params.delsys.dvbs.symbol_rate));
-
+                                                QString("Frequency =3D %1,=
 Srate =3D %2 (SET_PARAMS)").arg(fe_params.frequency).arg(fe_params.delsys.=
dvbs.symbol_rate));
+                                       =20
+                                        if (ioctl(fd_frontend, DVBFE_SET_D=
ELSYS, &delsys) < 0) {
+                                            VERBOSE(VB_IMPORTANT, LOC_ERR =
+
+                                                    "Tune(): " + "DVB_SET_=
DELSYS failed");
+                                            return false;
+                                        }
 		if (ioctl(fd_frontend, DVBFE_SET_PARAMS, &fe_params) =3D=3D -1) {
-			VERBOSE(VB_IMPORTANT, LOC_ERR + "Tune(): " +
-                        	"DVBFE_SET_PARAMS failed");
-			return false;
+                                            VERBOSE(VB_IMPORTANT, LOC_ERR =
+ "Tune(): " +
+                                                    "DVBFE_SET_PARAMS fail=
ed");
+                                            return false;
 		}
=20
 	}


--=-17hairn8cj7Ik9m5l9sT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-17hairn8cj7Ik9m5l9sT--
