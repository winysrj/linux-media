Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42323 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756741AbeDFOXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 15/21] media: vpbe_display: properly handle error case
Date: Fri,  6 Apr 2018 10:23:16 -0400
Message-Id: <2b267119e0c5d0aee46d2bcede17de56a7b67094.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if v4l2_subdev_call(..., VENC_GET_FLD,...) fails, it
currently returns a random value. Instead, return 1.

That's probably better than returning 0, as this is very
likely what happens in practice with the current code, as
as the probably of an unititialized 32 bits integer to
have an specific value (0, in this case), is 1/(2^32).

An alternative would be to return an error code, and
let the caller to hint, based on the past received
frame, but that sounds weird.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 9849e4405a6a..a0b5e670d736 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -56,8 +56,7 @@ static int vpbe_set_osd_display_params(struct vpbe_display *disp_dev,
 static int venc_is_second_field(struct vpbe_display *disp_dev)
 {
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
-	int ret;
-	int val;
+	int ret, val;
 
 	ret = v4l2_subdev_call(vpbe_dev->venc,
 			       core,
@@ -67,6 +66,7 @@ static int venc_is_second_field(struct vpbe_display *disp_dev)
 	if (ret < 0) {
 		v4l2_err(&vpbe_dev->v4l2_dev,
 			 "Error in getting Field ID 0\n");
+		return 1;
 	}
 	return val;
 }
-- 
2.14.3
