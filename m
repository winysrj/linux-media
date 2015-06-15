Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57481 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbbFOLeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/14] ak881x: simplify standard checks
Date: Mon, 15 Jun 2015 13:33:32 +0200
Message-Id: <1434368021-7467-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify confusing conditions. This also swaps the checks for NTSC and PAL:
to be consistent with other drivers check for NTSC first. So if the user
sets both NTSC and PAL bits, then NTSC wins.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ak881x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index 2984624..d3b965e 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -156,12 +156,12 @@ static int ak881x_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
 	} else if (std == V4L2_STD_PAL_60) {
 		vp1 = 7;
 		ak881x->lines = 480;
-	} else if (std && !(std & ~V4L2_STD_PAL)) {
-		vp1 = 0xf;
-		ak881x->lines = 576;
-	} else if (std && !(std & ~V4L2_STD_NTSC)) {
+	} else if (std & V4L2_STD_NTSC) {
 		vp1 = 0;
 		ak881x->lines = 480;
+	} else if (std & V4L2_STD_PAL) {
+		vp1 = 0xf;
+		ak881x->lines = 576;
 	} else {
 		/* No SECAM or PAL_N/Nc supported */
 		return -EINVAL;
-- 
2.1.4

