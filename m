Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:51277 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIXSIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 14:08:35 -0400
Subject: [PATCH 4/4] [media] omap3isp: Delete an unnecessary variable
 initialisation in isp_video_open()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Message-ID: <76ade6b8-0da7-8fa7-d123-434e4da2db54@users.sourceforge.net>
Date: Sun, 24 Sep 2017 20:08:30 +0200
MIME-Version: 1.0
In-Reply-To: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 19:43:06 +0200

The variable "ret" will eventually be set to an appropriate value
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap3isp/ispvideo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index d4118466fc8a..a9c0b2d3624d 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1303,7 +1303,7 @@ static int isp_video_open(struct file *file)
 	struct isp_video *video = video_drvdata(file);
 	struct isp_video_fh *handle;
 	struct vb2_queue *queue;
-	int ret = 0;
+	int ret;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle)
-- 
2.14.1
