Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2407 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3FLPCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 11/12] cx88: set dev_parent to the correct parent PCI bus.
Date: Wed, 12 Jun 2013 17:01:01 +0200
Message-Id: <1371049262-5799-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cx88 driver has one v4l2_device, but the video nodes are owned by two
different PCI busses. So the dev_parent pointer should be set to the correct
parent bus, otherwise sysfs won't show the correct device hierarchy.

This broke starting in 3.6 after a driver change, so this patch resurrects
the correct behavior.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index c8f3dcc..ad59dc9 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -1034,7 +1034,14 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template_;
+	/*
+	 * The dev pointer of v4l2_device is NULL, instead we set the
+	 * video_device dev_parent pointer to the correct PCI bus device.
+	 * This driver is a rare example where there is one v4l2_device,
+	 * but the video nodes have different parent (PCI) devices.
+	 */
 	vfd->v4l2_dev = &core->v4l2_dev;
+	vfd->dev_parent = &pci->dev;
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 core->name, type, core->board.name);
-- 
1.7.10.4

