Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m341eRYg025979
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 21:40:27 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m341e7hX010020
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 21:40:08 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JhauS-00065O-EL
	for video4linux-list@redhat.com; Fri, 04 Apr 2008 01:40:05 +0000
Received: from c9346dce.virtua.com.br ([201.52.109.206])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 04 Apr 2008 01:40:04 +0000
Received: from fragabr by c9346dce.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 04 Apr 2008 01:40:04 +0000
To: video4linux-list@redhat.com
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Date: Thu, 3 Apr 2008 22:38:39 -0300
Message-ID: <20080403223839.10ecde54@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Yq2Q_nqmSsBO1c2W6g_xjma"
Subject: [PATCH]: Powercolor Real Angel 330 (remote control support and
 fixes for gpio references)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--MP_/Yq2Q_nqmSsBO1c2W6g_xjma
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

	The attached patch fixes gpio references for
Powercolor Real Angel 330 and adds complete remote control support.

	Thanks to Markus Rechberger, Mauro Chehab and Daniel
Gimpelevich.

-- 
Linux 2.6.24: Arr Matey! A Hairy Bilge Rat!
http://u-br.net

--MP_/Yq2Q_nqmSsBO1c2W6g_xjma
Content-Type: text/plain; name=powercolor-patch.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=powercolor-patch.txt

Signed-off-by: D=E2niel Fraga <fragabr@gmail.com>

--- a/linux/drivers/media/video/cx88/cx88-cards.c	Thu Apr  3 17:08:04 2008
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Thu Apr  3 20:58:04 2008
@@ -1542,28 +1542,26 @@
 		.input          =3D { {
 			.type   =3D CX88_VMUX_TELEVISION,
 			.vmux   =3D 0,
-			.gpio0 =3D 0x0400, /* pin 2:mute =3D 0 (off?) */
+			.gpio0 =3D 0x00ff,
 			.gpio1 =3D 0xf35d,
-			.gpio2 =3D 0x0800, /* pin 19:audio =3D 0 (tv) */
+			.gpio3 =3D 0x0000,
 		}, {
 			.type   =3D CX88_VMUX_COMPOSITE1,
 			.vmux   =3D 1,
-			.gpio0 =3D 0x0400, /* probably?  or 0x0404 to turn mute on */
-			.gpio1 =3D 0x0000,
-			.gpio2 =3D 0x0808, /* pin 19:audio =3D 1 (line) */
+			.gpio0 =3D 0x00ff,
+			.gpio1 =3D 0xf37d,
+			.gpio3 =3D 0x0000,
 		}, {
 			.type   =3D CX88_VMUX_SVIDEO,
 			.vmux   =3D 2,
 			.gpio0  =3D 0x000ff,
 			.gpio1  =3D 0x0f37d,
-			.gpio2  =3D 0x00019,
 			.gpio3  =3D 0x00000,
 		} },
 		.radio =3D {
 			.type   =3D CX88_RADIO,
 			.gpio0  =3D 0x000ff,
 			.gpio1  =3D 0x0f35d,
-			.gpio2  =3D 0x00019,
 			.gpio3  =3D 0x00000,
 		},
 	},
--- a/linux/drivers/media/video/cx88/cx88-input.c	Thu Apr  3 17:08:04 2008
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Thu Apr  3 20:58:04 2008
@@ -330,6 +330,12 @@
 		ir_type =3D IR_TYPE_RC5;
 		ir->sampling =3D 1;
 		break;
+	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
+		ir_codes =3D ir_codes_powercolor_real_angel;
+		ir->gpio_addr =3D MO_GP2_IO;
+		ir->mask_keycode =3D 0x7e;
+		ir->polling =3D 100; /* ms */
+		break;
 	}
=20
 	if (NULL =3D=3D ir_codes) {
--- a/linux/drivers/media/common/ir-keymaps.c	Thu Apr  3 17:08:04 2008
+++ b/linux/drivers/media/common/ir-keymaps.c	Thu Apr  3 20:58:31 2008
@@ -2134,3 +2134,46 @@
 	[0x50] =3D KEY_BLUE,
 };
 EXPORT_SYMBOL_GPL(ir_codes_genius_tvgo_a11mce);
+
+/*
+ * Remote control for Powercolor Real Angel 330
+ * D=E2niel Fraga <fragabr@gmail.com>
+ */
+IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE] =3D {
+	[0x38] =3D KEY_SWITCHVIDEOMODE,	/* switch inputs */
+	[0x0c] =3D KEY_MEDIA,		/* Turn ON/OFF App */
+	[0x00] =3D KEY_0,
+	[0x01] =3D KEY_1,
+	[0x02] =3D KEY_2,
+	[0x03] =3D KEY_3,
+	[0x04] =3D KEY_4,
+	[0x05] =3D KEY_5,
+	[0x06] =3D KEY_6,
+	[0x07] =3D KEY_7,
+	[0x08] =3D KEY_8,
+	[0x09] =3D KEY_9,=09
+	[0x0a] =3D KEY_DIGITS,		/* single, double, tripple digit */
+	[0x29] =3D KEY_PREVIOUS,		/* previous channel */=09
+	[0x12] =3D KEY_BRIGHTNESSUP,
+	[0x13] =3D KEY_BRIGHTNESSDOWN,
+	[0x2b] =3D KEY_MODE,		/* stereo/mono */
+	[0x2c] =3D KEY_TEXT,		/* teletext */	=09
+	[0x20] =3D KEY_UP,		/* channel up */
+	[0x21] =3D KEY_DOWN,		/* channel down */
+	[0x10] =3D KEY_RIGHT,		/* volume up */
+	[0x11] =3D KEY_LEFT,		/* volume down */
+	[0x0d] =3D KEY_MUTE,
+	[0x1f] =3D KEY_RECORD,=09
+	[0x17] =3D KEY_PLAY,
+	[0x16] =3D KEY_PAUSE,
+	[0x0b] =3D KEY_STOP,
+	[0x27] =3D KEY_FASTFORWARD,
+	[0x26] =3D KEY_REWIND,
+	[0x1e] =3D KEY_SEARCH,		/* autoscan */
+	[0x0e] =3D KEY_SHUFFLE,		/* snapshot */
+	[0x2d] =3D KEY_SETUP,
+	[0x0f] =3D KEY_SCREEN,		/* full screen */
+	[0x14] =3D KEY_RADIO,		/* FM radio */
+	[0x25] =3D KEY_POWER,		/* power */
+};
+EXPORT_SYMBOL_GPL(ir_codes_powercolor_real_angel);
--- a/linux/include/media/ir-common.h	Thu Apr  3 17:08:04 2008
+++ b/linux/include/media/ir-common.h	Thu Apr  3 20:58:22 2008
@@ -144,6 +144,7 @@
 extern IR_KEYTAB_TYPE ir_codes_behold[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE];
=20
 #endif
=20

--MP_/Yq2Q_nqmSsBO1c2W6g_xjma
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/Yq2Q_nqmSsBO1c2W6g_xjma--
