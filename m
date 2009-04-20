Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbZDTUXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 16:23:14 -0400
Date: Mon, 20 Apr 2009 13:21:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: vaka@newmail.ru
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: Include in a kernel a patch for tuner support AverMedia Studio
 505
Message-Id: <20090420132112.d5f5b30e.akpm@linux-foundation.org>
In-Reply-To: <op.usg239qgd7v8y6@vaka>
References: <op.usg239qgd7v8y6@vaka>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009 13:25:11 +0400
vaka@newmail.ru wrote:

> I have written a patch for the tuner AverMedia Studio 505 that it was  
> correctly defined.
> I hope that you include this patch in a kernel
> This patch for a kernel 2.6.29.1

Thanks.

Please cc the appropriate mailing list (linux-media@vger.kernel.org)
and if possible maintainer(s) on kernel patches.

I changed the card's number frmo 155 to 158 while integrating the patch
onto the linux-next tree.

Please send us a Signed-off-by: for this patch, as per
Documetation/SubmittingPatches.



From: Vasiliy Temnikov <vaka@newmail.ru>

Add tuner support AverMedia AverTV Studio 505.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hermann Pitton <hermann-pitton@arcor.de>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/video4linux/CARDLIST.saa7134  |    1 
 drivers/media/video/saa7134/saa7134-cards.c |   43 ++++++++++++++++++
 drivers/media/video/saa7134/saa7134-input.c |    1 
 drivers/media/video/saa7134/saa7134-video.c |    2 
 drivers/media/video/saa7134/saa7134.h       |    1 
 5 files changed, 47 insertions(+), 1 deletion(-)

diff -puN Documentation/video4linux/CARDLIST.saa7134~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 Documentation/video4linux/CARDLIST.saa7134
--- a/Documentation/video4linux/CARDLIST.saa7134~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
+++ a/Documentation/video4linux/CARDLIST.saa7134
@@ -156,3 +156,4 @@
 155 -> Hauppauge WinTV-HVR1120 ATSC/QAM-Hybrid  [0070:6706,0070:6708]
 156 -> Hauppauge WinTV-HVR1110r3                [0070:6707,0070:6709,0070:670a]
 157 -> Avermedia AVerTV Studio 507UA            [1461:a11b]
+158 -> AverMedia AverTV Studio 505              [1461:a115]
diff -puN drivers/media/video/saa7134/saa7134-cards.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
+++ a/drivers/media/video/saa7134/saa7134-cards.c
@@ -1364,6 +1364,42 @@ struct saa7134_board saa7134_boards[] = 
 			.amux = LINE1,
 		},
 	},
+	[SAA7134_BOARD_AVERMEDIA_STUDIO_505] = {
+		/* Vasiliy Temnikov <vaka@newmail.ru> */
+		.name           = "AverMedia AverTV Studio 505",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = LINE2,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		},{
+			.name = name_comp2,
+			.vmux = 3,
+			.amux = LINE2,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+	},
 	[SAA7134_BOARD_UPMOST_PURPLE_TV] = {
 		.name           = "UPMOST PURPLE TV",
 		.audio_clock    = 0x00187de7,
@@ -5049,6 +5085,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xa115,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_STUDIO_505,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0x2108,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_305,
 	},{
@@ -6144,6 +6186,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_KWORLD_VSTREAM_XPERT:
 	case SAA7134_BOARD_KWORLD_XPERT:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
 	case SAA7134_BOARD_AVERMEDIA_305:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
 	case SAA7134_BOARD_AVERMEDIA_307:
diff -puN drivers/media/video/saa7134/saa7134-input.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134-input.c
--- a/drivers/media/video/saa7134/saa7134-input.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
+++ a/drivers/media/video/saa7134/saa7134-input.c
@@ -445,6 +445,7 @@ int saa7134_input_init1(struct saa7134_d
 	case SAA7134_BOARD_AVERMEDIA_305:
 	case SAA7134_BOARD_AVERMEDIA_307:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_507UA:
diff -puN drivers/media/video/saa7134/saa7134-video.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
+++ a/drivers/media/video/saa7134/saa7134-video.c
@@ -39,7 +39,7 @@ static unsigned int gbuffers      = 8;
 static unsigned int noninterlaced; /* 0 */
 static unsigned int gbufsize      = 720*576*4;
 static unsigned int gbufsize_max  = 720*576*4;
-static char secam[] = "--";
+static char secam[] = "dk";
 module_param(video_debug, int, 0644);
 MODULE_PARM_DESC(video_debug,"enable debug messages [video]");
 module_param(gbuffers, int, 0444);
diff -puN drivers/media/video/saa7134/saa7134.h~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -159,6 +159,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_DVD_EZMAKER 33
 #define SAA7134_BOARD_NOVAC_PRIMETV7133 34
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_305 35
+#define SAA7134_BOARD_AVERMEDIA_STUDIO_505 158
 #define SAA7134_BOARD_UPMOST_PURPLE_TV 36
 #define SAA7134_BOARD_ITEMS_MTV005     37
 #define SAA7134_BOARD_CINERGY200       38
_

