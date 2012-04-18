Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54611 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2DRMWU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 08:22:20 -0400
Received: by yenl12 with SMTP id l12so3588476yen.19
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2012 05:22:19 -0700 (PDT)
Message-ID: <4F8EB1F1.1030801@gmail.com>
Date: Wed, 18 Apr 2012 09:22:09 -0300
From: Gonzalo de la Vega <gadelavega@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] TDA9887 PAL-Nc fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tunner IF for PAL-Nc norm, which AFAIK is used only in Argentina, was being defined as equal to PAL-M but it is not. It actually uses the same video IF as PAL-BG (and unlike PAL-M) but the audio is at 4.5MHz (same as PAL-M). A separate structure member was added for PAL-Nc.

Signed-off-by: Gonzalo A. de la Vega <gadelavega@gmail.com>


diff --git a/drivers/media/common/tuners/tda9887.c b/drivers/media/common/tuners/tda9887.c
index cdb645d..b560b5d 100644
--- a/drivers/media/common/tuners/tda9887.c
+++ b/drivers/media/common/tuners/tda9887.c
@@ -168,8 +168,8 @@ static struct tvnorm tvnorms[] = {
 			   cAudioIF_6_5   |
 			   cVideoIF_38_90 ),
 	},{
-		.std   = V4L2_STD_PAL_M | V4L2_STD_PAL_Nc,
-		.name  = "PAL-M/Nc",
+		.std   = V4L2_STD_PAL_M,
+		.name  = "PAL-M",
 		.b     = ( cNegativeFmTV  |
 			   cQSS           ),
 		.c     = ( cDeemphasisON  |
@@ -179,6 +179,17 @@ static struct tvnorm tvnorms[] = {
 			   cAudioIF_4_5   |
 			   cVideoIF_45_75 ),
 	},{
+		.std   = V4L2_STD_PAL_Nc,
+		.name  = "PAL-Nc",
+		.b     = ( cNegativeFmTV  |
+			   cQSS           ),
+		.c     = ( cDeemphasisON  |
+			   cDeemphasis75  |
+			   cTopDefault),
+		.e     = ( cGating_36     |
+			   cAudioIF_4_5   |
+			   cVideoIF_38_90 ),
+	},{
 		.std   = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H,
 		.name  = "SECAM-BGH",
 		.b     = ( cNegativeFmTV  |
