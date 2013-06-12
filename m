Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2986 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3FLPCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 01/12] v4l2-device: check if already unregistered.
Date: Wed, 12 Jun 2013 17:00:51 +0200
Message-Id: <1371049262-5799-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It was possible to unregister an already unregistered v4l2_device struct.
Add a check whether that already happened and just return if that was
the case.

Also refure to register a v4l2_device if both the dev and name fields are
empty. A warning was already produced in that case, but since the name field
is now used to detect whether or not the v4l2_device was already unregistered
this particular combination should be rejected.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-device.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 8ed5da2..7f3f822 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -44,7 +44,8 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 	v4l2_dev->dev = dev;
 	if (dev == NULL) {
 		/* If dev == NULL, then name must be filled in by the caller */
-		WARN_ON(!v4l2_dev->name[0]);
+		if (WARN_ON(!v4l2_dev->name[0]))
+			return -EINVAL;
 		return 0;
 	}
 
@@ -105,7 +106,9 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 {
 	struct v4l2_subdev *sd, *next;
 
-	if (v4l2_dev == NULL)
+	/* Just return if v4l2_dev is NULL or if it was already
+	 * unregistered before. */
+	if (v4l2_dev == NULL || !v4l2_dev->name[0])
 		return;
 	v4l2_device_disconnect(v4l2_dev);
 
@@ -135,6 +138,8 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 		}
 #endif
 	}
+	/* Mark as unregistered, thus preventing duplicate unregistrations */
+	v4l2_dev->name[0] = '\0';
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);
 
-- 
1.7.10.4

