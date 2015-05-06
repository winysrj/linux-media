Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54419 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbbEFG5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 7/8] dvb: add MEDIA_IOC_DEVICE_INFO
Date: Wed,  6 May 2015 08:57:22 +0200
Message-Id: <1430895443-41839-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the MEDIA_IOC_DEVICE_INFO ioctl for DVB entities.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-core/dmxdev.c         | 24 +++++++++++++++++++++++-
 drivers/media/dvb-core/dvb_ca_en50221.c | 11 +++++++++++
 drivers/media/dvb-core/dvb_net.c        | 11 +++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index d0e3f9d..ab096eb 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -967,6 +967,17 @@ static int dvb_demux_do_ioctl(struct file *file,
 		return -ERESTARTSYS;
 
 	switch (cmd) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	case MEDIA_IOC_DEVICE_INFO: {
+		struct media_device_info *info = parg;
+
+		if (dmxdev->dvbdev->entity->parent == NULL)
+			return -ENOTTY;
+		media_device_fill_info(dmxdev->dvbdev->entity->parent, info);
+		info->entity_id = dmxdev->dvbdev->entity->id;
+		break;
+	}
+#endif
 	case DMX_START:
 		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
 			mutex_unlock(&dmxdev->mutex);
@@ -1152,12 +1163,23 @@ static int dvb_dvr_do_ioctl(struct file *file,
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 	unsigned long arg = (unsigned long)parg;
-	int ret;
+	int ret = 0;
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
 
 	switch (cmd) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	case MEDIA_IOC_DEVICE_INFO: {
+		struct media_device_info *info = parg;
+
+		if (dvbdev->entity->parent == NULL)
+			return -ENOTTY;
+		media_device_fill_info(dvbdev->entity->parent, info);
+		info->entity_id = dvbdev->entity->id;
+		break;
+	}
+#endif
 	case DMX_SET_BUFFER_SIZE:
 		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 7293775..eca19f5 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1198,6 +1198,17 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 		return -ERESTARTSYS;
 
 	switch (cmd) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	case MEDIA_IOC_DEVICE_INFO: {
+		struct media_device_info *info = parg;
+
+		if (dvbdev->entity->parent == NULL)
+			return -ENOTTY;
+		media_device_fill_info(dvbdev->entity->parent, info);
+		info->entity_id = dvbdev->entity->id;
+		break;
+	}
+#endif
 	case CA_RESET:
 		for (slot = 0; slot < ca->slot_count; slot++) {
 			mutex_lock(&ca->slot_info[slot].slot_lock);
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index a694fb1..1c0c889 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1322,6 +1322,17 @@ static int dvb_net_do_ioctl(struct file *file,
 		return -ERESTARTSYS;
 
 	switch (cmd) {
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	case MEDIA_IOC_DEVICE_INFO: {
+		struct media_device_info *info = parg;
+
+		if (dvbdev->entity->parent == NULL)
+			return -ENOTTY;
+		media_device_fill_info(dvbdev->entity->parent, info);
+		info->entity_id = dvbdev->entity->id;
+		break;
+	}
+#endif
 	case NET_ADD_IF:
 	{
 		struct dvb_net_if *dvbnetif = parg;
-- 
2.1.4

