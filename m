Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4.vodamail.co.za ([196.11.146.166]:34179 "EHLO
	vodamail.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783Ab0AQM55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 07:57:57 -0500
Subject: [PATCH] Compro S350 GPIO change
From: JD Louw <jd.louw@mweb.co.za>
To: liplianin@me.by
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jan 2010 14:57:46 +0200
Message-ID: <1263733066.2031.15.camel@Core2Duo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch enables LNB power on newer revision d1 Compro S350 and S300
DVB-S cards. While I don't have these cards to test with I'm confident
that this works. See
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/7471 and http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/14296
and new windows driver as reference.

Signed-off-by: JD Louw <jd.louw@mweb.co.za>

diff -r 59e746a1c5d1 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Dec 30
09:10:33 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jan 17
14:51:07 2010 +0200
@@ -7037,8 +7037,8 @@ int saa7134_board_init1(struct saa7134_d
 		break;
 	case SAA7134_BOARD_VIDEOMATE_S350:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
-		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
-		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000C000, 0x0000C000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000C000, 0x0000C000);
 		break;
 	}
 	return 0;


