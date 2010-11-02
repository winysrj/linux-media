Return-path: <mchehab@gaivota>
Received: from d1.icnet.pl ([212.160.220.21]:35736 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab0KBQPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 12:15:07 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] SoC Camera: ov6650: minor cleanups
Date: Tue, 2 Nov 2010 17:14:36 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011021714.37544.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a followup patch that addresses two minor issues left in the recently 
added ov6650 sensor driver, as I've promised to the subsystem maintainer:
- remove a pair of extra brackets,
- drop useless case for not possible v4l2_mbus_pixelcode enum value of 0.

Created against linux-2.6.37-rc1.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---

 drivers/media/video/ov6650.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.37-rc1/drivers/media/video/ov6650.c.orig	2010-11-01 22:41:59.000000000 +0100
+++ linux-2.6.37-rc1/drivers/media/video/ov6650.c	2010-11-02 16:56:49.000000000 +0100
@@ -754,7 +754,7 @@ static int ov6650_g_fmt(struct v4l2_subd
 
 static bool is_unscaled_ok(int width, int height, struct v4l2_rect *rect)
 {
-	return (width > rect->width >> 1 || height > rect->height >> 1);
+	return width > rect->width >> 1 || height > rect->height >> 1;
 }
 
 static u8 to_clkrc(struct v4l2_fract *timeperframe,
@@ -840,8 +840,6 @@ static int ov6650_s_fmt(struct v4l2_subd
 		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
 		coma_set |= COMA_RAW_RGB | COMA_RGB;
 		break;
-	case 0:
-		break;
 	default:
 		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
 		return -EINVAL;
