Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:35062 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbZD1Wsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 18:48:39 -0400
Subject: [PATCH] saa7134: disable not yet existing IR and DVB support on
	the Compro T750
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: John Newbigin <jn@it.swin.edu.au>
Content-Type: multipart/mixed; boundary="=-BBS9A/kkA3dqMpLZRBP2"
Date: Wed, 29 Apr 2009 00:44:05 +0200
Message-Id: <1240958645.3731.115.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-BBS9A/kkA3dqMpLZRBP2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The Compro VideoMate T750 has no support for IR and DVB-T yet.
Disable both to avoid fall through and confusing printouts.

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Apr 29 00:15:48 2009 +0200
@@ -4537,7 +4537,6 @@
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
 			.vmux   = 3,
@@ -6297,7 +6296,6 @@
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
-	case SAA7134_BOARD_VIDEOMATE_T750:
 	case SAA7134_BOARD_MANLI_MTV001:
 	case SAA7134_BOARD_MANLI_MTV002:
 	case SAA7134_BOARD_BEHOLD_409FM:

--=-BBS9A/kkA3dqMpLZRBP2
Content-Disposition: inline; filename=saa7134_disable-IR-and-DVB-on-Compro-T750.patch
Content-Type: text/x-patch; name=saa7134_disable-IR-and-DVB-on-Compro-T750.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Apr 29 00:15:48 2009 +0200
@@ -4537,7 +4537,6 @@
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
 			.vmux   = 3,
@@ -6297,7 +6296,6 @@
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
-	case SAA7134_BOARD_VIDEOMATE_T750:
 	case SAA7134_BOARD_MANLI_MTV001:
 	case SAA7134_BOARD_MANLI_MTV002:
 	case SAA7134_BOARD_BEHOLD_409FM:

--=-BBS9A/kkA3dqMpLZRBP2--

