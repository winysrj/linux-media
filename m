Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48518 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797AbbFGI6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 06/11] sh-vou: fix incorrect initial pixelformat.
Date: Sun,  7 Jun 2015 10:58:00 +0200
Message-Id: <1433667485-35711-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It was set to a format that wasn't supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index d9a4502..262c244 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1368,7 +1368,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	rect->height		= 480;
 	pix->width		= VOU_MAX_IMAGE_WIDTH;
 	pix->height		= 480;
-	pix->pixelformat	= V4L2_PIX_FMT_YVYU;
+	pix->pixelformat	= V4L2_PIX_FMT_NV16;
 	pix->field		= V4L2_FIELD_NONE;
 	pix->bytesperline	= VOU_MAX_IMAGE_WIDTH * 2;
 	pix->sizeimage		= VOU_MAX_IMAGE_WIDTH * 2 * 480;
-- 
2.1.4

