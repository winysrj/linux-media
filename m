Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:59043 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbdIQB1N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 21:27:13 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, rjkm@metzlerbros.de, d.scheller@gmx.net,
        jasmin@anw.at
Subject: [PATCH 2/2] Added timers for dvb_ca_en50221_write_data
Date: Sun, 17 Sep 2017 03:27:22 +0200
Message-Id: <1505611642-6552-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1505611642-6552-1-git-send-email-jasmin@anw.at>
References: <1505611642-6552-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Some (older) CAMs are really slow in accepting data. The CI interface
specification doesn't define a handshake for accepted data. Thus, the
en50221 protocol driver can't control if a data byte has been correctly
written to the CAM.

The current implementation writes the length and the data quick after
each other. Thus, the slow CAMs may generate a WR error, which leads to
the known error logging
   "CAM tried to send a buffer larger than the ecount size".

To solve this issue the en50221 protocol driver needs to wait some CAM
depending time between the different bytes to be written. Because the
time is CAM dependent, an individual value per CAM needs to be set. For
that SysFS is used in favor of ioctl's to allow the control of the timer
values independent from any user space application.

This patch adds the timers and the SysFS nodes to set/get the timeout
values and the timer waiting between the different steps of the CAM write
access. A timer value of 0 (default) means "no timeout".

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 132 +++++++++++++++++++++++++++++++-
 1 file changed, 131 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 95b3723..50c4e45 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -86,6 +86,13 @@ MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 #define DVB_CA_SLOTSTATE_WAITFR         6
 #define DVB_CA_SLOTSTATE_LINKINIT       7
 
+enum dvb_ca_timers {
+	DVB_CA_TIM_WR_HIGH  /* wait after writing length high */
+,	DVB_CA_TIM_WR_LOW   /* wait after writing length low */
+,	DVB_CA_TIM_WR_DATA  /* wait between data bytes */
+,	DVB_CA_TIM_MAX
+};
+
 /* Information on a CA slot */
 struct dvb_ca_slot {
 	/* current state of the CAM */
@@ -119,6 +126,11 @@ struct dvb_ca_slot {
 	unsigned long timeout;
 };
 
+struct dvb_ca_timer {
+	unsigned long min;
+	unsigned long max;
+};
+
 /* Private CA-interface information */
 struct dvb_ca_private {
 	struct kref refcount;
@@ -161,6 +173,14 @@ struct dvb_ca_private {
 
 	/* mutex serializing ioctls */
 	struct mutex ioctl_mutex;
+
+	struct dvb_ca_timer timers[DVB_CA_TIM_MAX];
+};
+
+static const char dvb_ca_tim_names[DVB_CA_TIM_MAX][15] = {
+	"tim_wr_high"
+,	"tim_wr_low"
+,	"tim_wr_data"
 };
 
 static void dvb_ca_private_free(struct dvb_ca_private *ca)
@@ -223,6 +243,14 @@ static char *findstr(char *haystack, int hlen, char *needle, int nlen)
 	return NULL;
 }
 
+static void dvb_ca_sleep(struct dvb_ca_private *ca, enum dvb_ca_timers tim)
+{
+	unsigned long min = ca->timers[tim].min;
+
+	if (min)
+		usleep_range(min, ca->timers[tim].max);
+}
+
 /* ************************************************************************** */
 /* EN50221 physical interface functions */
 
@@ -868,10 +896,13 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 					    bytes_write >> 8);
 	if (status)
 		goto exit;
+	dvb_ca_sleep(ca, DVB_CA_TIM_WR_HIGH);
+
 	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW,
 					    bytes_write & 0xff);
 	if (status)
 		goto exit;
+	dvb_ca_sleep(ca, DVB_CA_TIM_WR_LOW);
 
 	/* send the buffer */
 	for (i = 0; i < bytes_write; i++) {
@@ -879,6 +910,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 						    buf[i]);
 		if (status)
 			goto exit;
+		dvb_ca_sleep(ca, DVB_CA_TIM_WR_DATA);
 	}
 
 	/* check for write error (WE should now be 0) */
@@ -1832,6 +1864,97 @@ static const struct dvb_device dvbdev_ca = {
 };
 
 /* ************************************************************************** */
+/* EN50221 device attributes (SysFS) */
+
+static int dvb_ca_tim_idx(struct dvb_ca_private *ca, const char *name)
+{
+	int tim_idx;
+
+	for (tim_idx = 0; tim_idx < DVB_CA_TIM_MAX; tim_idx++) {
+		if (!strcmp(dvb_ca_tim_names[tim_idx], name))
+			return tim_idx;
+	}
+	return -1;
+}
+
+static ssize_t dvb_ca_tim_show(struct device *device,
+			       struct device_attribute *attr, char *buf)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(device);
+	struct dvb_ca_private *ca = dvbdev->priv;
+	int tim_idx = dvb_ca_tim_idx(ca, attr->attr.name);
+
+	if (tim_idx < 0)
+		return -ENXIO;
+
+	return sprintf(buf, "%ld\n", ca->timers[tim_idx].min);
+}
+
+static ssize_t dvb_ca_tim_store(struct device *device,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(device);
+	struct dvb_ca_private *ca = dvbdev->priv;
+	int tim_idx = dvb_ca_tim_idx(ca, attr->attr.name);
+	unsigned long min, max;
+
+	if (tim_idx < 0)
+		return -ENXIO;
+
+	if (sscanf(buf, "%lu\n", &min) != 1)
+		return -EINVAL;
+
+	/* value is in us; 100ms is a good maximum */
+	if (min > (100 * USEC_PER_MSEC))
+		return -EINVAL;
+
+	/* +10% (rounded up) */
+	max = (min * 11 + 5) / 10;
+	ca->timers[tim_idx].min = min;
+	ca->timers[tim_idx].max = max;
+
+	return count;
+}
+
+/* attribute definition with string pointer (see include/linux/sysfs.h) */
+#define DVB_CA_ATTR(_name, _mode, _show, _store) {	\
+	.attr = {.name = _name, .mode = _mode },	\
+	.show	= _show,				\
+	.store	= _store,				\
+}
+
+#define DVB_CA_ATTR_TIM(_tim_idx)					\
+	DVB_CA_ATTR(dvb_ca_tim_names[_tim_idx], 0664, dvb_ca_tim_show,	\
+		    dvb_ca_tim_store)
+
+static const struct device_attribute dvb_ca_attrs[DVB_CA_TIM_MAX] = {
+	DVB_CA_ATTR_TIM(DVB_CA_TIM_WR_HIGH)
+,	DVB_CA_ATTR_TIM(DVB_CA_TIM_WR_LOW)
+,	DVB_CA_ATTR_TIM(DVB_CA_TIM_WR_DATA)
+};
+
+static int dvb_ca_device_attrs_add(struct dvb_ca_private *ca)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dvb_ca_attrs); i++)
+		if (device_create_file(ca->dvbdev->dev, &dvb_ca_attrs[i]))
+			goto fail;
+	return 0;
+fail:
+	return -1;
+}
+
+static void ddb_device_attrs_del(struct dvb_ca_private *ca)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dvb_ca_attrs); i++)
+		device_remove_file(ca->dvbdev->dev, &dvb_ca_attrs[i]);
+}
+
+/* ************************************************************************** */
 /* Initialisation/shutdown functions */
 
 /**
@@ -1901,6 +2024,10 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		ret = -EINTR;
 		goto unregister_device;
 	}
+
+	if (dvb_ca_device_attrs_add(ca))
+		goto unregister_device;
+
 	mb();
 
 	/* create a kthread for monitoring this CA device */
@@ -1910,10 +2037,12 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		ret = PTR_ERR(ca->thread);
 		pr_err("dvb_ca_init: failed to start kernel_thread (%d)\n",
 		       ret);
-		goto unregister_device;
+		goto delete_attrs;
 	}
 	return 0;
 
+delete_attrs:
+	ddb_device_attrs_del(ca);
 unregister_device:
 	dvb_unregister_device(ca->dvbdev);
 free_slot_info:
@@ -1945,6 +2074,7 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 	for (i = 0; i < ca->slot_count; i++)
 		dvb_ca_en50221_slot_shutdown(ca, i);
 
+	ddb_device_attrs_del(ca);
 	dvb_remove_device(ca->dvbdev);
 	dvb_ca_private_put(ca);
 	pubca->private = NULL;
-- 
2.7.4
