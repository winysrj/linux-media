Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49820 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbbFEK7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 06:59:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/10] sh-vou: fix incorrect initial pixelformat.
Date: Fri,  5 Jun 2015 12:59:21 +0200
Message-Id: <1433501966-30176-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
References: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It was set to a format that wasn't supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 2adf16d..eaa432e 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1376,7 +1376,7 @@ static int sh_vou_probe(struct platform_device *pdev)
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

