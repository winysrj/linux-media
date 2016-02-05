Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55275 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbcBETKW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:22 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/8] [media] v4l2-async: call registered_async after subdev registration
Date: Fri,  5 Feb 2016 16:09:52 -0300
Message-Id: <1454699398-8581-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 sub-devices might need to do initialization that depends on being
registered with a V4L2 device. As an example, sub-devices with Media
Controller support may need to register entities and create pad links.

Execute the registered_async callback after the sub-device has been
registered with the V4L2 device so the driver can do any needed init.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/v4l2-core/v4l2-async.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada202b2d3..716bfd47daab 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -119,6 +119,13 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 		return ret;
 	}
 
+	ret = v4l2_subdev_call(sd, core, registered_async);
+	if (ret < 0) {
+		if (notifier->unbind)
+			notifier->unbind(notifier, sd, asd);
+		return ret;
+	}
+
 	if (list_empty(&notifier->waiting) && notifier->complete)
 		return notifier->complete(notifier);
 
-- 
2.5.0

