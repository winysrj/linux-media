Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp4-g19.free.fr ([212.27.42.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stef.dev@free.fr>) id 1KYR5s-0008IG-9U
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 21:54:18 +0200
Received: from smtp4-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 65A793EA122
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 21:54:12 +0200 (CEST)
Received: from sidero.numenor.net (lac49-1-82-245-43-74.fbx.proxad.net
	[82.245.43.74])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 2305D3EA11F
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 21:54:12 +0200 (CEST)
From: stef <stef.dev@free.fr>
To: linux-dvb@linuxtv.org
Date: Wed, 27 Aug 2008 21:51:36 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808272151.36167.stef.dev@free.fr>
Subject: [linux-dvb] [PATCH] Pinnacle pctv310c DVB support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

	Hello,

	I finally managed to get DVB working on my Pinnacle PCTV Hybrid Pro card. =
I have it currently working, watching TV with kaffeine. =

The only drawback is that enabling DVB breaks analog TV, which is certainly=
 an issue in tunex-xc2028.c which doesn't reload a proper =

firmware when changing from DVB to analog.

Regards,
	Stef

Signed-off-by: St=E9phane Voltz <stef.dev@free.fr>


diff -baur v4l-dvb/linux/drivers/media/video/cx88/cx88-cards.c v4l-dvb-stef=
/linux/drivers/media/video/cx88/cx88-cards.c
--- v4l-dvb/linux/drivers/media/video/cx88/cx88-cards.c	2008-08-17 19:09:04=
.000000000 +0200
+++ v4l-dvb-stef/linux/drivers/media/video/cx88/cx88-cards.c	2008-08-27 21:=
06:57.000000000 +0200
@@ -1479,15 +1479,26 @@
 		.name           =3D "Pinnacle Hybrid PCTV",
 		.tuner_type     =3D TUNER_XC2028,
 		.tuner_addr     =3D 0x61,
+		.radio_type     =3D TUNER_XC2028,
+		.radio_addr     =3D 0x61,
 		.input          =3D { {
 			.type   =3D CX88_VMUX_TELEVISION,
 			.vmux   =3D 0,
+			.gpio0  =3D 0x004ff,
+			.gpio1  =3D 0x010ff,
+			.gpio2  =3D 0x00001,
 		}, {
 			.type   =3D CX88_VMUX_COMPOSITE1,
 			.vmux   =3D 1,
+			.gpio0  =3D 0x004fb,
+			.gpio1  =3D 0x010ef,
+			.audioroute =3D 1,
 		}, {
 			.type   =3D CX88_VMUX_SVIDEO,
 			.vmux   =3D 2,
+			.gpio0  =3D 0x004fb,
+			.gpio1  =3D 0x010ef,
+			.audioroute =3D 1,
 		} },
 		.radio =3D {
 			.type   =3D CX88_RADIO,
@@ -1495,10 +1506,7 @@
 			.gpio1  =3D 0x010ff,
 			.gpio2  =3D 0x0ff,
 		},
-#if 0
-		/* needs some more GPIO work */
 		.mpeg           =3D CX88_MPEG_DVB,
-#endif
 	},
 	[CX88_BOARD_WINFAST_TV2000_XP_GLOBAL] =3D {
 		.name           =3D "Winfast TV2000 XP Global",
@@ -2483,6 +2491,10 @@
 		 * This board uses non-MTS firmware
 		 */
 		break;
+	case CX88_BOARD_PINNACLE_HYBRID_PCTV:
+		ctl->demod =3D XC3028_FE_ZARLINK456;
+		ctl->mts =3D 1;
+		break;
 	default:
 		ctl->demod =3D XC3028_FE_OREN538;
 		ctl->mts =3D 1;
diff -baur v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c v4l-dvb-stef/l=
inux/drivers/media/video/cx88/cx88-dvb.c
--- v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c	2008-08-17 19:09:04.0=
00000000 +0200
+++ v4l-dvb-stef/linux/drivers/media/video/cx88/cx88-dvb.c	2008-08-27 21:03=
:52.000000000 +0200
@@ -460,6 +460,12 @@
 	.tuner_callback	=3D cx88_tuner_callback,
 };
 =

+static struct zl10353_config cx88_pinnacle_hybrid_pctv =3D {
+	.demod_address =3D (0x1e >> 1),
+	.no_tuner      =3D 1,
+	.if2           =3D 45600,
+};
+
 static struct zl10353_config cx88_geniatech_x8000_mt =3D {
        .demod_address =3D (0x1e >> 1),
        .no_tuner =3D 1,
@@ -855,10 +861,13 @@
 		break;
 	 case CX88_BOARD_PINNACLE_HYBRID_PCTV:
 		dev->dvb.frontend =3D dvb_attach(zl10353_attach,
-					       &cx88_geniatech_x8000_mt,
+					       &cx88_pinnacle_hybrid_pctv,
 					       &core->i2c_adap);
+		if (dev->dvb.frontend) {
+			dev->dvb.frontend->ops.i2c_gate_ctrl =3D NULL;
 		if (attach_xc3028(0x61, dev) < 0)
 			goto frontend_detach;
+		}
 		break;
 	 case CX88_BOARD_GENIATECH_X8000_MT:
 		dev->ts_gen_cntrl =3D 0x00;

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
