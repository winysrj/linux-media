Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1BMR3K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 12:29:10 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1DHTA8X022923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:29:10 -0500
Received: from pedra (vpn-239-52.phx2.redhat.com [10.3.239.52])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1DHT5kL015438
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:29:09 -0500
Date: Sun, 13 Feb 2011 15:28:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/5] [media] cx231xx: Add support for PV Xcapture USB
Message-ID: <20110213152857.404da31f@pedra>
In-Reply-To: <cover.1297617986.git.mchehab@redhat.com>
References: <cover.1297617986.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Adds support for Pixelviex Xcapture USB grabber device.
This device has one composite and one s-video entry
only, plus a button.

For now, the button is not supported.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index e04c955..6540b8d 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -440,6 +440,35 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = 0,
 		} },
 	},
+	[CX231XX_BOARD_PV_XCAPTURE_USB] = {
+		.name = "Pixelview Xcapture USB",
+		.tuner_type = TUNER_ABSENT,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.demod_xfer_mode = 0,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x0c,
+		.gpio_pin_status_mask = 0x4001000,
+		.norm = V4L2_STD_NTSC,
+		.no_alt_vanc = 1,
+		.external_av = 1,
+		.dont_use_port_3 = 1,
+
+		.input = {{
+				.type = CX231XX_VMUX_COMPOSITE1,
+				.vmux = CX231XX_VIN_2_1,
+				.amux = CX231XX_AMUX_LINE_IN,
+				.gpio = NULL,
+			}, {
+				.type = CX231XX_VMUX_SVIDEO,
+				.vmux = CX231XX_VIN_1_1 |
+					(CX231XX_VIN_1_2 << 8) |
+					CX25840_SVIDEO_ON,
+				.amux = CX231XX_AMUX_LINE_IN,
+				.gpio = NULL,
+			}
+		},
+	},
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
@@ -469,6 +498,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USBLIVE2},
 	{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
 	 .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},
+	{USB_DEVICE(USB_VID_PIXELVIEW, 0x5014),
+	 .driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},
 	{},
 };
 
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index e1c222b..2d5ab0c 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -64,6 +64,7 @@
 #define CX231XX_BOARD_HAUPPAUGE_EXETER  8
 #define CX231XX_BOARD_HAUPPAUGE_USBLIVE2 9
 #define CX231XX_BOARD_PV_PLAYTV_USB_HYBRID 10
+#define CX231XX_BOARD_PV_XCAPTURE_USB 11
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
1.7.1

