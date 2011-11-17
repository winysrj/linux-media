Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53153 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab1KQKou (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:44:50 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAHAilH9008796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:44:49 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND RFC PATCH v4 13/15] davinci: vpfe: add aew driver based on v4l2 media framework
Date: Thu, 17 Nov 2011 16:14:39 +0530
Message-ID: <1321526681-22574-14-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
References: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add auto exposure and white balance driver based on v4l2 media
framework. The driver processess the bayer data from CCDC and
generates the data which will be used for calculation of
parameters responsible for auto exposure and white balancing.
The driver implement the v4l2 event queing mechanism to know the
readiness data from the driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpfe_aew.c |  238 ++++++++++++++++++++++++++++++++
 drivers/media/video/davinci/vpfe_aew.h |   51 +++++++
 2 files changed, 289 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpfe_aew.c
 create mode 100644 drivers/media/video/davinci/vpfe_aew.h

diff --git a/drivers/media/video/davinci/vpfe_aew.c b/drivers/media/video/davinci/vpfe_aew.c
new file mode 100644
index 0000000..4c2f075
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_aew.c
@@ -0,0 +1,238 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
+ */
+#include <linux/platform_device.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-device.h>
+#include <media/media-entity.h>
+#include "vpss.h"
+#include "vpfe_capture.h"
+
+/*
+ * V4L2 subdev operations
+ */
+
+/*
+ * aew_subscribe_event - subscribe event
+ * @sd: VPFE AEW V4L2 subdevice
+ * @fh: file handle
+ * @sub: event subscription structure
+ */
+static int aew_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	struct vpfe_aew_device *aew = v4l2_get_subdevdata(sd);
+
+	if (sub->type != aew->event_type)
+		return -EINVAL;
+	return v4l2_event_subscribe(fh, sub);
+}
+
+/*
+ * aew_unsubscribe_event - unsubscribe event
+ * @sd: VPFE AEW V4L2 subdevice
+ * @fh: file handle
+ * @sub: event subscription structure
+ */
+static int aew_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				  struct v4l2_event_subscription *sub)
+{
+	struct vpfe_aew_device *aew = v4l2_get_subdevdata(sd);
+
+	if (sub->type != aew->event_type)
+		return -EINVAL;
+	return v4l2_event_unsubscribe(fh, sub);
+}
+
+/*
+ * aew_queue_event - queue event
+ * @sd: VPFE AEW V4L2 subdevice
+ */
+void aew_queue_event(struct v4l2_subdev *sd)
+{
+	struct vpfe_aew_device *aew = v4l2_get_subdevdata(sd);
+	struct video_device *vdev = &sd->devnode;
+	struct v4l2_event event;
+
+	memset(&event, 0, sizeof(event));
+	event.type = aew->event_type;
+	v4l2_event_queue(vdev, &event);
+}
+
+/*
+ * aew_set_stream - Enable/Disable streaming on the AEW module
+ * @sd: VPFE AEW V4L2 subdevice
+ * @enable: Enable/disable stream
+ */
+static int set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vpfe_aew_device *aew = v4l2_get_subdevdata(sd);
+
+	if (aew->input == AEW_INPUT_CCDC)
+		return aew_set_stream(sd, enable);
+
+	return 0;
+}
+
+/*
+ * aew_ioctl - AEW module private ioctl's
+ * @sd: VPFE AEW V4L2 subdevice
+ * @cmd: ioctl command
+ * @arg: ioctl argument
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static long ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	return aew_ioctl(sd, cmd, arg);
+}
+
+/* V4L2 subdev core operations */
+static const struct v4l2_subdev_core_ops aew_v4l2_core_ops = {
+	.ioctl = ioctl,
+	.subscribe_event = aew_subscribe_event,
+	.unsubscribe_event = aew_unsubscribe_event,
+};
+
+/* V4L2 subdev video operations */
+static const struct v4l2_subdev_video_ops aew_v4l2_video_ops = {
+	.s_stream = set_stream,
+};
+
+/* V4L2 subdev operations */
+static const struct v4l2_subdev_ops aew_v4l2_ops = {
+	.core = &aew_v4l2_core_ops,
+	.video = &aew_v4l2_video_ops,
+};
+
+/*
+ * Media entity operations
+ */
+
+/*
+ * aew_link_setup - Setup AEW connections
+ * @entity: AEW media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int aew_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vpfe_aew_device *aew = v4l2_get_subdevdata(sd);
+	struct vpfe_device *vpfe_dev;
+
+	vpfe_dev = to_vpfe_device(aew);
+	if ((flags & MEDIA_LNK_FL_ENABLED)) {
+		aew->input = AEW_INPUT_CCDC;
+		aew_open();
+		return 0;
+	}
+	aew->input = AEW_INPUT_NONE;
+	aew_release();
+	return 0;
+}
+
+static const struct media_entity_operations aew_media_ops = {
+	.link_setup = aew_link_setup,
+};
+
+/*
+ * vpfe_aew_register_entities - AEW subdev driver registration
+ * @aew - pointer to aew subdevice structure.
+ * @vdev: pointer to v4l2 device structure.
+ */
+int vpfe_aew_register_entities(struct vpfe_aew_device *aew,
+				struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev */
+	ret = v4l2_device_register_subdev(vdev, &aew->subdev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * vpfe_aew_unregister_entities - AEW subdev driver unregistration
+ * @aew - pointer to aew subdevice structure.
+ * @vdev: pointer to v4l2 device structure.
+ */
+void vpfe_aew_unregister_entities(struct vpfe_aew_device *aew)
+{
+	/* cleanup entity */
+	media_entity_cleanup(&aew->subdev.entity);
+	/* unregister subdev */
+	v4l2_device_unregister_subdev(&aew->subdev);
+}
+
+/*
+ * vpfe_aew_init - AEW module initilaization.
+ * @vpfe_aew - pointer to aew subdevice structure.
+ * @pdev: platform device pointer.
+ */
+int vpfe_aew_init(struct vpfe_aew_device *vpfe_aew,
+		  struct platform_device *pdev)
+{
+	struct v4l2_subdev *aew = &vpfe_aew->subdev;
+	struct media_pad *pads = &vpfe_aew->pads[0];
+	struct media_entity *me = &aew->entity;
+	int ret;
+
+	if (aew_init(pdev))
+		return -EINVAL;
+
+	v4l2_subdev_init(aew, &aew_v4l2_ops);
+	strlcpy(aew->name, "DAVINCI AEW", sizeof(aew->name));
+	aew->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	v4l2_set_subdevdata(aew, vpfe_aew);
+	aew->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
+	aew->nevents = DAVINCI_AEW_NEVENTS;
+	pads[AEW_PAD_SINK].flags = MEDIA_PAD_FL_INPUT;
+	vpfe_aew->input = AEW_INPUT_NONE;
+	vpfe_aew->event_type = DAVINCI_EVENT_AEWB;
+	me->ops = &aew_media_ops;
+	ret = media_entity_init(me, AEW_PADS_NUM, pads, 0);
+	if (ret)
+		goto out_davanci_init;
+
+	return 0;
+
+out_davanci_init:
+	aew_cleanup();
+
+	return ret;
+}
+
+/*
+ * vpfe_aew_cleanup - AEW module cleanup.
+ */
+void vpfe_aew_cleanup(void)
+{
+	aew_cleanup();
+}
diff --git a/drivers/media/video/davinci/vpfe_aew.h b/drivers/media/video/davinci/vpfe_aew.h
new file mode 100644
index 0000000..d4ad908
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_aew.h
@@ -0,0 +1,51 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+#ifndef _VPFE_AEW_H
+#define _VPFE_AEW_H
+
+#define AEW_PAD_SINK	0
+#define AEW_PADS_NUM	1
+
+#define DAVINCI_AEW_NEVENTS	1
+
+#define AEW_INPUT_NONE		0
+#define AEW_INPUT_CCDC		1
+
+#define DAVINCI_EVENT_AEWB	1
+
+struct vpfe_aew_device {
+	struct v4l2_subdev	subdev;
+	struct media_pad	pads[AEW_PADS_NUM];
+	unsigned int		input;
+	unsigned long		event_type;
+};
+
+int aew_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
+int aew_set_stream(struct v4l2_subdev *sd, int enable);
+int aew_init(struct platform_device *pdev);
+void aew_cleanup(void);
+int aew_release(void);
+int aew_open(void);
+
+void vpfe_aew_unregister_entities(struct vpfe_aew_device *aew);
+int vpfe_aew_register_entities(struct vpfe_aew_device *aew,
+			       struct v4l2_device *v4l2_dev);
+int vpfe_aew_init(struct vpfe_aew_device *vpfe_aew,
+		  struct platform_device *pdev);
+void aew_queue_event(struct v4l2_subdev *sd);
+void vpfe_aew_cleanup(void);
+#endif
-- 
1.6.2.4

