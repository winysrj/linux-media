Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59081 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756636AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 31/57] [media] si4713: don't break long lines
Date: Fri, 14 Oct 2016 17:20:19 -0300
Message-Id: <394ca8501be9469c319f87a170ca2b5fbf5b5c30.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/si4713/si4713.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 0b04b56571da..797d35e4d0d2 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -716,8 +716,7 @@ static int si4713_tx_tune_status(struct si4713_device *sdev, u8 intack,
 		*power = val[5];
 		*antcap = val[6];
 		*noise = val[7];
-		v4l2_dbg(1, debug, &sdev->sd, "%s: response: %d x 10 kHz "
-				"(power %d, antcap %d, rnl %d)\n", __func__,
+		v4l2_dbg(1, debug, &sdev->sd, "%s: response: %d x 10 kHz (power %d, antcap %d, rnl %d)\n", __func__,
 				*frequency, *power, *antcap, *noise);
 	}
 
@@ -758,9 +757,7 @@ static int si4713_tx_rds_buff(struct si4713_device *sdev, u8 mode, u16 rdsb,
 		v4l2_dbg(1, debug, &sdev->sd,
 			"%s: status=0x%02x\n", __func__, val[0]);
 		*cbleft = (s8)val[2] - val[3];
-		v4l2_dbg(1, debug, &sdev->sd, "%s: response: interrupts"
-				" 0x%02x cb avail: %d cb used %d fifo avail"
-				" %d fifo used %d\n", __func__, val[1],
+		v4l2_dbg(1, debug, &sdev->sd, "%s: response: interrupts 0x%02x cb avail: %d cb used %d fifo avail %d fifo used %d\n", __func__, val[1],
 				val[2], val[3], val[4], val[5]);
 	}
 
-- 
2.7.4


