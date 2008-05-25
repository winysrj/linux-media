Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n21.bullet.mail.ukl.yahoo.com ([87.248.110.138])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K061m-0006ZS-6S
	for linux-dvb@linuxtv.org; Sun, 25 May 2008 04:32:11 +0200
Date: Sat, 24 May 2008 22:28:49 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Message-Id: <1211682529l.9766l.0l@manu-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Yg7FLAMnEh5NoKJ3aWMU"
Subject: [linux-dvb] [PATCH]: TT-3200 remote patch
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

--=-Yg7FLAMnEh5NoKJ3aWMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

	Hi all,
here is a patch to enable TT-3200 remote. It works for me but:
- I dont know the RC device so I set it to RC_DEVICE_ANY;
- I get keys when I push buttons on the remote, but for some reason one=20
puts my computer on sleep. I already checked the ir keymap and I dont=20
see the problem, if someone could give it a shot...
- I dont know how to test which remote is used, I based the detection=20
on the product id (0x1019), but all other cases are handled the same=20
way so...
Anyway, any comments are more than welcome.

Signed-off-by: Emmanuel ALLAUD <eallaud@yahoo.fr>
=20
Bye
Manu

--=-Yg7FLAMnEh5NoKJ3aWMU
Content-Type: text/x-patch; charset=us-ascii; name=TT-3200-remote.patch
Content-Disposition: attachment; filename=TT-3200-remote.patch
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/media/common/ir-keymaps.c	2008-03-22 10:12:18.000000000 -=
0400
+++ ../multiproto-bis/multiproto/linux/drivers/media/common/ir-keymaps.c	20=
08-05-14 11:30:09.000000000 -0400
@@ -1507,6 +1507,57 @@
=20
 EXPORT_SYMBOL_GPL(ir_codes_hauppauge_new);
=20
+/* Hauppauge: the newer, gray remotes (seems there are multiple
+ * slightly different versions), shipped with cx88+ivtv cards.
+ * almost rc5 coding, but some non-standard keys */
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
+  [ 0x22 ] =3D KEY_CHANNEL,         /* source (old black remote) */
+  [ 0x0f ] =3D KEY_ENTER,           /* OK */
+  [ 0x26 ] =3D KEY_SLEEP,           /* minimize (old black remote) */
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


--=-Yg7FLAMnEh5NoKJ3aWMU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-Yg7FLAMnEh5NoKJ3aWMU--
