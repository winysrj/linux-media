Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757055AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 21/57] [media] tw68: don't break long lines
Date: Fri, 14 Oct 2016 17:20:09 -0300
Message-Id: <6f28934c9970793589ad705fc445fa2914fc3b25.1476475771.git.mchehab@s-opensource.com>
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
 drivers/media/pci/tw68/tw68-video.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index a45e02367321..165d54925506 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -279,8 +279,7 @@ static int tw68_set_scale(struct tw68_dev *dev, unsigned int width,
 		height /= 2;		/* we must set for 1-frame */
 
 	pr_debug("%s: width=%d, height=%d, both=%d\n"
-		 "  tvnorm h_delay=%d, h_start=%d, h_stop=%d, "
-		 "v_delay=%d, v_start=%d, v_stop=%d\n" , __func__,
+		 "  tvnorm h_delay=%d, h_start=%d, h_stop=%d, v_delay=%d, v_start=%d, v_stop=%d\n" , __func__,
 		width, height, V4L2_FIELD_HAS_BOTH(field),
 		norm->h_delay, norm->h_start, norm->h_stop,
 		norm->v_delay, norm->video_v_start,
@@ -309,16 +308,14 @@ static int tw68_set_scale(struct tw68_dev *dev, unsigned int width,
 		V4L2_FIELD_HAS_TOP(field)    ? "T" : "",
 		V4L2_FIELD_HAS_BOTTOM(field) ? "B" : "",
 		v4l2_norm_to_name(dev->tvnorm->id));
-	pr_debug("%s: hactive=%d, hdelay=%d, hscale=%d; "
-		"vactive=%d, vdelay=%d, vscale=%d\n", __func__,
+	pr_debug("%s: hactive=%d, hdelay=%d, hscale=%d; vactive=%d, vdelay=%d, vscale=%d\n", __func__,
 		hactive, hdelay, hscale, vactive, vdelay, vscale);
 
 	comb =	((vdelay & 0x300)  >> 2) |
 		((vactive & 0x300) >> 4) |
 		((hdelay & 0x300)  >> 6) |
 		((hactive & 0x300) >> 8);
-	pr_debug("%s: setting CROP_HI=%02x, VDELAY_LO=%02x, "
-		"VACTIVE_LO=%02x, HDELAY_LO=%02x, HACTIVE_LO=%02x\n",
+	pr_debug("%s: setting CROP_HI=%02x, VDELAY_LO=%02x, VACTIVE_LO=%02x, HDELAY_LO=%02x, HACTIVE_LO=%02x\n",
 		__func__, comb, vdelay, vactive, hdelay, hactive);
 	tw_writeb(TW68_CROP_HI, comb);
 	tw_writeb(TW68_VDELAY_LO, vdelay & 0xff);
@@ -327,8 +324,7 @@ static int tw68_set_scale(struct tw68_dev *dev, unsigned int width,
 	tw_writeb(TW68_HACTIVE_LO, hactive & 0xff);
 
 	comb = ((vscale & 0xf00) >> 4) | ((hscale & 0xf00) >> 8);
-	pr_debug("%s: setting SCALE_HI=%02x, VSCALE_LO=%02x, "
-		"HSCALE_LO=%02x\n", __func__, comb, vscale, hscale);
+	pr_debug("%s: setting SCALE_HI=%02x, VSCALE_LO=%02x, HSCALE_LO=%02x\n", __func__, comb, vscale, hscale);
 	tw_writeb(TW68_SCALE_HI, comb);
 	tw_writeb(TW68_VSCALE_LO, vscale);
 	tw_writeb(TW68_HSCALE_LO, hscale);
-- 
2.7.4


