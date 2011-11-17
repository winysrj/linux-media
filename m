Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48511 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab1KQKot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:44:49 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAHAikp2023964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:44:48 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND RFC PATCH v4 11/15] davinci: vpfe: add autofocus driver based on media framework
Date: Thu, 17 Nov 2011 16:14:37 +0530
Message-ID: <1321526681-22574-12-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
References: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add autofocus driver based on v4l2 media framework. The driver
processess the bayer data from CCDC and generates the data which
will be used for calculation of parametsrs responsible for focussing.
The driver implement the v4l2 event queing mechanism to know the
readiness data from the driver.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpfe_af.c |  240 +++++++++++++++++++++++++++++++++
 drivers/media/video/davinci/vpfe_af.h |   50 +++++++
 2 files changed, 290 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpfe_af.c
 create mode 100644 drivers/media/video/davinci/vpfe_af.h

diff --git a/drivers/media/video/davinci/vpfe_af.c b/drivers/media/video/davinci/vpfe_af.c
new file mode 100644
index 0000000..b19bc8a
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_af.c
@@ -0,0 +1,240 @@
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
+#include <linux/videodev2.h>
+#include <linux/v4l2-mediabus.h>
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
+ * af_subscribe_event - subscribe event
+ * @sd: VPFE AF V4L2 subdevice
+ * @fh: file handle
+ * @sub: event subscription structure
+ */
+static int af_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	struct vpfe_af_device *af = v4l2_get_subdevdata(sd);
+
+	if (sub->type != af->event_type)
+		return -EINVAL;
+
+	return v4l2_event_subscribe(fh, sub);
+}
+
+/*
+ * af_unsubscribe_event - unsubscribe event
+ * @sd: VPFE AF V4L2 subdevice
+ * @fh: file handle
+ * @sub: event subscription structure
+ */
+static int af_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				  struct v4l2_event_subscription *sub)
+{
+	struct vpfe_af_device *af = v4l2_get_subdevdata(sd);
+
+	if (sub->type != af->event_type)
+		return -EINVAL;
+
+	return v4l2_event_unsubscribe(fh, sub);
+}
+
+/*
+ * af_queue_event - queue event
+ * @sd: VPFE AF V4L2 subdevice
+ */
+void af_queue_event(struct v4l2_subdev *sd)
+{
+	struct vpfe_af_device *af = v4l2_get_subdevdata(sd);
+	struct video_device *vdev = &sd->devnode;
+	struct v4l2_event event;
+
+	memset(&event, 0, sizeof(event));
+	event.type = af->event_type;
+	v4l2_event_queue(vdev, &event);
+}
+
+/*
+ * af_set_stream - Enable/Disable streaming on the AF module
+ * @sd: VPFE AF V4L2 subdevice
+ * @enable: Enable/disable stream
+ */
+static int set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vpfe_af_device *af = v4l2_get_subdevdata(sd);
+
+	if (af->input == AF_INPUT_CCDC)
+		return af_set_stream(sd, enable);
+
+	return 0;
+}
+
+/*
+ * af_ioctl - AF module private ioctl's
+ * @sd: VPFE AF V4L2 subdevice
+ * @cmd: ioctl command
+ * @arg: ioctl argument
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static long ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	return af_ioctl(sd, cmd, arg);
+}
+
+/* V4L2 subdev core operations */
+static const struct v4l2_subdev_core_ops af_v4l2_core_ops = {
+	.ioctl = ioctl,
+	.subscribe_event = af_subscribe_event,
+	.unsubscribe_event = af_unsubscribe_event,
+};
+
+/* V4L2 subdev video operations */
+static const struct v4l2_subdev_video_ops af_v4l2_video_ops = {
+	.s_stream = set_stream,
+};
+
+/* V4L2 subdev operations */
+static const struct v4l2_subdev_ops af_v4l2_ops = {
+	.core = &af_v4l2_core_ops,
+	.video = &af_v4l2_video_ops,
+};
+
+/*
+ * Media entity operations
+ */
+
+/*
+ * af_link_setup - Setup AF connections
+ * @entity: AF media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int af_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vpfe_af_device *af = v4l2_get_subdevdata(sd);
+	struct vpfe_device *vpfe_dev;
+
+	vpfe_dev = to_vpfe_device(af);
+
+	if ((flags & MEDIA_LNK_FL_ENABLED)) {
+		af->input = AF_INPUT_CCDC;
+		af_open();
+	} else {
+		af->input = AF_INPUT_NONE;
+		af_release();
+	}
+	return 0;
+}
+
+static const struct media_entity_operations af_media_ops = {
+	.link_setup = af_link_setup,
+};
+
+/*
+ * vpfe_af_register_entities - AF subdev driver registration
+ * @af - pointer to af subdevice structure.
+ * @vdev: pointer to v4l2 device structure.
+ */
+int vpfe_af_register_entities(struct vpfe_af_device *af,
+				struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev */
+	ret = v4l2_device_register_subdev(vdev, &af->subdev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * vpfe_af_unregister_entities - AF subdev driver unregistration
+ * @af - pointer to af subdevice structure.
+ * @vdev: pointer to v4l2 device structure.
+ */
+void vpfe_af_unregister_entities(struct vpfe_af_device *af)
+{
+	/* cleanup entity */
+	media_entity_cleanup(&af->subdev.entity);
+	/* unregister subdev */
+	v4l2_device_unregister_subdev(&af->subdev);
+}
+
+/*
+ * vpfe_af_init - AF module initilaization.
+ * @vpfe_af - pointer to af subdevice structure.
+ * @pdev: platform device pointer.
+ */
+int vpfe_af_init(struct vpfe_af_device *vpfe_af, struct platform_device *pdev)
+{
+	struct v4l2_subdev *af = &vpfe_af->subdev;
+	struct media_pad *pads = &vpfe_af->pads[0];
+	struct media_entity *me = &af->entity;
+	int ret;
+
+	if (af_init(pdev))
+		return -EINVAL;
+
+	v4l2_subdev_init(af, &af_v4l2_ops);
+	strlcpy(af->name, "DAVINCI AF", sizeof(af->name));
+	af->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	v4l2_set_subdevdata(af, vpfe_af);
+	af->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
+	af->nevents = DAVINCI_AF_NEVENTS;
+	pads[AF_PAD_SINK].flags = MEDIA_PAD_FL_INPUT;
+	vpfe_af->input = AF_INPUT_NONE;
+	vpfe_af->event_type = DAVINCI_EVENT_AF;
+	me->ops = &af_media_ops;
+	ret = media_entity_init(me, AF_PADS_NUM, pads, 0);
+	if (ret)
+		goto out_davanci_init;
+
+	return 0;
+
+out_davanci_init:
+	af_cleanup();
+
+	return ret;
+}
+
+/*
+ * vpfe_af_cleanup - AF module cleanup.
+ */
+void vpfe_af_cleanup(void)
+{
+	af_cleanup();
+}
diff --git a/drivers/media/video/davinci/vpfe_af.h b/drivers/media/video/davinci/vpfe_af.h
new file mode 100644
index 0000000..dea1d11
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_af.h
@@ -0,0 +1,50 @@
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
+#ifndef _VPFE_AF_H
+#define _VPFE_AF_H
+
+#define AF_PAD_SINK	0
+#define AF_PADS_NUM	1
+
+#define DAVINCI_AF_NEVENTS	1
+
+#define AF_INPUT_NONE		0
+#define AF_INPUT_CCDC		1
+
+#define DAVINCI_EVENT_AF	1
+
+struct vpfe_af_device {
+	struct v4l2_subdev		subdev;
+	struct media_pad		pads[AF_PADS_NUM];
+	unsigned int			input;
+	unsigned long			event_type;
+};
+
+int af_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
+int af_set_stream(struct v4l2_subdev *sd, int enable);
+int af_init(struct platform_device *pdev);
+void af_cleanup(void);
+int af_release(void);
+int af_open(void);
+
+int vpfe_af_init(struct vpfe_af_device *vpfe_af, struct platform_device *pdev);
+void vpfe_af_unregister_entities(struct vpfe_af_device *af);
+int vpfe_af_register_entities(struct vpfe_af_device *af,
+			      struct v4l2_device *v4l2_dev);
+void af_queue_event(struct v4l2_subdev *sd);
+void vpfe_af_cleanup(void);
+#endif
-- 
1.6.2.4

