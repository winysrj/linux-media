Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63KWKoT006606
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:32:20 -0400
Received: from smtp100.biz.mail.re2.yahoo.com (smtp100.biz.mail.re2.yahoo.com
	[206.190.52.46])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m63KW5Mh005890
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:32:07 -0400
Message-ID: <486D3754.1090500@embeddedalley.com>
Date: Fri, 04 Jul 2008 00:32:20 +0400
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH/resend] em28xx: add Compro Video Mate support
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi guys,

resending as the original message seems to have gotten lost somewhere...

So at some point I got the idea of enabling my good old Compro VideoMate
For You USB TV box, and below what I've done to make it working, to some
extent.

The TV tuner is now recognized fine and TV apps work well with it,
including channels surfing etc., but I can't get the sound working. It's
not coming off the TV tuner. As far as I understand, the tuner has the
old 2820 chip with USB audio class but it's not detected b/c of the data
read from the I2C flash chip.

 drivers/media/video/em28xx/em28xx-cards.c |   19 +++++++++++++++++++
 drivers/media/video/em28xx/em28xx.h       |    1 +
 2 files changed, 20 insertions(+)

Index: linux-next/drivers/media/video/em28xx/em28xx-cards.c
===================================================================
- --- linux-next.orig/drivers/media/video/em28xx/em28xx-cards.c
+++ linux-next/drivers/media/video/em28xx/em28xx-cards.c
@@ -439,6 +439,23 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = 0,
 		} },
 	},
+	[EM2820_BOARD_COMPRO_VIDEO_MATE] = {
+		.name         = "Compro VideoMate ForYou/Stereo",
+		.vchannels    = 2,
+		.tuner_type   = TUNER_LG_PAL_NEW_TAPC,
+		.tda9887_conf = TDA9887_PRESENT,
+		.decoder      = EM28XX_TVP5150,
+		.input          = { {
+			.type     = EM28XX_VMUX_TELEVISION,
+			.vmux     = TVP5150_COMPOSITE0,
+			.amux     = EM28XX_AMUX_LINE_IN,
+		}, {
+			.type     = EM28XX_VMUX_SVIDEO,
+			.vmux     = TVP5150_SVIDEO,
+			.amux     = EM28XX_AMUX_LINE_IN,
+		} },
+	},
+
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);

@@ -492,6 +509,8 @@ struct usb_device_id em28xx_id_table []
 			.driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
 	{ USB_DEVICE(0x0ccd, 0x0047),
 			.driver_info = EM2880_BOARD_TERRATEC_PRODIGY_XS },
+	{ USB_DEVICE(0x185b, 0x2041),
+			.driver_info = EM2820_BOARD_COMPRO_VIDEO_MATE },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
Index: linux-next/drivers/media/video/em28xx/em28xx.h
===================================================================
- --- linux-next.orig/drivers/media/video/em28xx/em28xx.h
+++ linux-next/drivers/media/video/em28xx/em28xx.h
@@ -58,6 +58,7 @@
 #define EM2880_BOARD_PINNACLE_PCTV_HD_PRO	17
 #define EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2	18
 #define EM2860_BOARD_POINTNIX_INTRAORAL_CAMERA  19
+#define EM2820_BOARD_COMPRO_VIDEO_MATE		20

 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4

Vitaly
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkhtN1QACgkQhA9O4GSDNst68QCfRZVmQSSUe5bHLTIG8QwUhWrs
DKkAniWdpAHnKt8WTYZUmlEPkay5Bp0C
=kV5h
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
