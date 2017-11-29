Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40293 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751897AbdK2TIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:50 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 15/22] media: soc_camera: fix a kernel-doc markup
Date: Wed, 29 Nov 2017 14:08:33 -0500
Message-Id: <b7ed68fff22e3ce5a6c635099ed5662c6dd7c1a5.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove this warning:
	drivers/media/platform/soc_camera/soc_scale_crop.c:309: warning: Cannot understand  * @icd		- soc-camera device
	 on line 309 - I thought it was a doc line

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/soc_camera/soc_scale_crop.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index 0116097c0c0f..270ec613c27c 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -306,16 +306,17 @@ static int client_set_fmt(struct soc_camera_device *icd,
 }
 
 /**
- * @icd		- soc-camera device
- * @rect	- camera cropping window
- * @subrect	- part of rect, sent to the user
- * @mf		- in- / output camera output window
- * @width	- on input: max host input width
- *		  on output: user width, mapped back to input
- * @height	- on input: max host input height
- *		  on output: user height, mapped back to input
- * @host_can_scale - host can scale this pixel format
- * @shift	- shift, used for scaling
+ * soc_camera_client_scale
+ * @icd:		soc-camera device
+ * @rect:		camera cropping window
+ * @subrect:		part of rect, sent to the user
+ * @mf:			in- / output camera output window
+ * @width:		on input: max host input width;
+ *			on output: user width, mapped back to input
+ * @height:		on input: max host input height;
+ *			on output: user height, mapped back to input
+ * @host_can_scale:	host can scale this pixel format
+ * @shift:		shift, used for scaling
  */
 int soc_camera_client_scale(struct soc_camera_device *icd,
 			struct v4l2_rect *rect, struct v4l2_rect *subrect,
-- 
2.14.3
