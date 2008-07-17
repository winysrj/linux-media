Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n23.bullet.mail.ukl.yahoo.com ([87.248.110.140])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KJS5a-0004Pc-4B
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 13:56:18 +0200
Date: Thu, 17 Jul 2008 07:54:43 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
In-Reply-To: <3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
	(from linux@bohmer.net on Thu Jul 17 06:20:36 2008)
Message-Id: <1216295683l.6831l.1l@manu-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-W3K9YS3W7ABMNMhSOv9r"
Subject: [linux-dvb] Re :  TT S2-3200 driver
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

--=-W3K9YS3W7ABMNMhSOv9r
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Le 17.07.2008 06:20:36, Remy Bohmer a =E9crit=A0:
> Hello Ales and Marc,
>=20
> > please try attached patch. With this patch I'm able to get lock on
> channels
>=20
> Okay, I want to test it too, but I have some troubles getting the
> multiproto drivers up and running.
> The S2-3200 is detected properly in my system, but I have no working
> szap2, or scan, or dvbstream tools.
>=20
> The two of you seem to have it working, so maybe you can give me some
> hints:
> What sources (what version) do I need?
> Is there a clear manual available somewhere that describes how to use
> the multiproto drivers?
> What version of szap2 (and scan) should I use? and where can I find
> it?
> Does dvbstream still work? Or can I use Mythtv directly?

If you want to use myth you can try the attached patch (against trunk).
Make sure that the includes in /usr/include/linux/dvb/ are the one from=20
your multiproto tree (check for a DVBFE_SET_DELSYS define in the=20
frontend.h source).
Bye
Manu

--=-W3K9YS3W7ABMNMhSOv9r
Content-Type: text/x-patch; charset=us-ascii;
	name=mythtv-trunk-multiproto.patch
Content-Disposition: attachment; filename=mythtv-trunk-multiproto.patch
Content-Transfer-Encoding: quoted-printable

--- trunk/mythtv/libs/libmythtv/dvbchannel.cpp	2008-07-10 22:02:57.00000000=
0 -0400
+++ trunk-work/mythtv/libs/libmythtv/dvbchannel.cpp	2008-07-11 18:33:33.000=
000000 -0400
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


--=-W3K9YS3W7ABMNMhSOv9r
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-W3K9YS3W7ABMNMhSOv9r--
