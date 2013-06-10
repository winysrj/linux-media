Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1749 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FJMtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 08:49:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/9] cx23885-417: use v4l2_dev instead of the deprecated parent field.
Date: Mon, 10 Jun 2013 14:48:31 +0200
Message-Id: <1370868518-19831-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
References: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index f4f9ef0..e3fc2c7 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1732,7 +1732,7 @@ static struct video_device *cx23885_video_dev_alloc(
 	*vfd = *template;
 	snprintf(vfd->name, sizeof(vfd->name), "%s (%s)",
 		cx23885_boards[tsport->dev->board].name, type);
-	vfd->parent  = &pci->dev;
+	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	return vfd;
 }
-- 
1.7.10.4

