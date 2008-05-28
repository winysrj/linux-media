Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n30.bullet.mail.ukl.yahoo.com ([87.248.110.147])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K1Q6K-00020D-EA
	for linux-dvb@linuxtv.org; Wed, 28 May 2008 20:10:17 +0200
Date: Wed, 28 May 2008 14:04:18 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <1211682529l.9766l.0l@manu-laptop>
	<1211683962l.9766l.2l@manu-laptop> <1211745313l.6418l.0l@manu-laptop>
	<200805271250.55118.vpivaini@cs.helsinki.fi>
	<1211973738l.6080l.0l@manu-laptop>
In-Reply-To: <1211973738l.6080l.0l@manu-laptop> (from eallaud@yahoo.fr on
	Wed May 28 07:22:18 2008)
Message-Id: <1211997858l.5668l.0l@manu-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-s2ivdbDK/NBlRRQiMleJ"
Subject: [linux-dvb] Re :  Re : Re : Re : [PATCH]: TT-3200 remote patch
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

--=-s2ivdbDK/NBlRRQiMleJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

	Hi all,
here is the last version of the patch should ;-) :

  add support to the TT-3200 black remote

signed-off by: Emmanuel ALLAUD <eallaud@yahoo.fr>

I hope I did not mess up this one!
Bye
Manu



--=-s2ivdbDK/NBlRRQiMleJ
Content-Type: text/x-patch; charset=us-ascii; name=TT-3200-remote.patch
Content-Disposition: attachment; filename=TT-3200-remote.patch
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/media/common/ir-keymaps.c	2008-03-22 10:12:18.000000000 -=
0400
+++ ../multiproto-bis/multiproto/linux/drivers/media/common/ir-keymaps.c	20=
08-05-14 11:30:09.000000000 -0400
@@ -1507,6 +1507,53 @@
=20
 EXPORT_SYMBOL_GPL(ir_codes_hauppauge_new);
=20
+/* Hauppauge: the black remote */
+
+IR_KEYTAB_TYPE ir_codes_tt_3200[IR_KEYTAB_SIZE] =3D {
+  /* Keys 0 to 9 */
+  [ 0x03 ] =3D KEY_1,
+  [ 0x04 ] =3D KEY_2,
+  [ 0x05 ] =3D KEY_3,
+  [ 0x06 ] =3D KEY_4,
+  [ 0x07 ] =3D KEY_5,
+  [ 0x08 ] =3D KEY_6,
+  [ 0x09 ] =3D KEY_7,
+  [ 0x0a ] =3D KEY_8,
+  [ 0x0b ] =3D KEY_9,
+  [ 0x0c ] =3D KEY_0,
+
+  [ 0x19 ] =3D KEY_TEXT,            /* keypad asterisk as well */
+  [ 0x14 ] =3D KEY_RED,             /* red button */
+  [ 0x12 ] =3D KEY_MENU,            /* The "i" key */
+  [ 0x18 ] =3D KEY_MUTE,
+  [ 0x25 ] =3D KEY_VOLUMEUP,
+  [ 0x26 ] =3D KEY_VOLUMEDOWN,
+  [ 0x0d ] =3D KEY_UP,
+  [ 0x11 ] =3D KEY_DOWN,
+  [ 0x0e ] =3D KEY_LEFT,
+  [ 0x10 ] =3D KEY_RIGHT,
+
+  [ 0x22 ] =3D KEY_EPG,             /* Guide */
+  [ 0x1a ] =3D KEY_TV,
+  [ 0x1e ] =3D KEY_NEXTSONG,        /* skip >| */
+  [ 0x13 ] =3D KEY_EXIT,            /* back/exit */
+  [ 0x23 ] =3D KEY_CHANNELUP,       /* channel / program + */
+  [ 0x24 ] =3D KEY_CHANNELDOWN,     /* channel / program - */
+  [ 0x0f ] =3D KEY_ENTER,           /* OK */
+  [ 0x17 ] =3D KEY_BLUE,            /* blue button */
+  [ 0x15 ] =3D KEY_GREEN,           /* green button */
+  [ 0x3e ] =3D KEY_PAUSE,           /* pause */
+  [ 0x3d ] =3D KEY_REWIND,          /* backward << */
+  [ 0x3f ] =3D KEY_FASTFORWARD,     /* forward >> */
+  [ 0x3b ] =3D KEY_PLAY,
+  [ 0x3c ] =3D KEY_STOP,
+  [ 0x3a ] =3D KEY_RECORD,          /* recording */
+  [ 0x16 ] =3D KEY_YELLOW,          /* yellow key */
+  [ 0x01 ] =3D KEY_POWER,           /* system power */
+};
+
+EXPORT_SYMBOL_GPL(ir_codes_tt_3200);
+
 IR_KEYTAB_TYPE ir_codes_npgtech[IR_KEYTAB_SIZE] =3D {
 	[ 0x1d ] =3D KEY_SWITCHVIDEOMODE, /* switch inputs */
 	[ 0x2a ] =3D KEY_FRONT,
--- linux/drivers/media/dvb/ttpci/budget-ci.c	2008-03-22 12:31:19.000000000=
 -0400
+++ ../multiproto-bis/multiproto/linux/drivers/media/dvb/ttpci/budget-ci.c	=
2008-05-22 08:24:48.000000000 -0400
@@ -249,6 +249,17 @@
 		else
 			budget_ci->ir.rc5_device =3D rc5_device;
 		break;
+	case 0x1019:
+		/* For the TT 3200 bundled remote */
+		ir_input_init(input_dev, &budget_ci->ir.state,
+			      IR_TYPE_RC5, ir_codes_tt_3200);
+
+		if (rc5_device < 0)
+		  /* I don't know the device for now so...*/
+		  budget_ci->ir.rc5_device =3D IR_DEVICE_ANY;
+		else
+			budget_ci->ir.rc5_device =3D rc5_device;
+		break;
 	default:
 		/* unknown remote */
 		ir_input_init(input_dev, &budget_ci->ir.state,
--- linux/include/media/ir-common.h	2008-03-22 10:12:19.000000000 -0400
+++ ../multiproto-bis/multiproto/linux/include/media/ir-common.h	2008-05-14=
 11:34:18.000000000 -0400
@@ -139,6 +139,7 @@
 extern IR_KEYTAB_TYPE ir_codes_asus_pc39[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_encore_enltv[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_tt_1500[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_tt_3200[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_fusionhdtv_mce[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_behold[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];


--=-s2ivdbDK/NBlRRQiMleJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-s2ivdbDK/NBlRRQiMleJ--
