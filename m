Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4932 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FJMtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 08:49:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/9] zoran: use v4l2_dev instead of the deprecated parent field.
Date: Mon, 10 Jun 2013 14:48:32 +0200
Message-Id: <1370868518-19831-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
References: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index bb53d24..923d59a 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1050,7 +1050,7 @@ static int zr36057_init (struct zoran *zr)
 	 *   Now add the template and register the device unit.
 	 */
 	memcpy(zr->video_dev, &zoran_template, sizeof(zoran_template));
-	zr->video_dev->parent = &zr->pci_dev->dev;
+	zr->video_dev->v4l2_dev = &zr->v4l2_dev;
 	strcpy(zr->video_dev->name, ZR_DEVNAME(zr));
 	/* It's not a mem2mem device, but you can both capture and output from
 	   one and the same device. This should really be split up into two
-- 
1.7.10.4

