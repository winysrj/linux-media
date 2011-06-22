Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31204 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab1FVSBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 14:01:45 -0400
Date: Wed, 22 Jun 2011 20:01:22 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 16/18] s5p-fimc: Add v4l2_device notification support for
 single frame capture
In-reply-to: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1308765684-10677-17-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   47 +++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    1 +
 include/media/s5p_fimc.h                    |    9 +++++
 4 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 7e45e85..06c85ae 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1026,6 +1026,53 @@ static const struct media_entity_operations fimc_media_ops = {
 	.link_setup = fimc_link_setup,
 };
 
+/**
+ * fimc_sensor_notify - v4l2_device notification from a sensor subdev
+ * @sd: pointer to a subdev generating the notification
+ * @notification: the notification type, must be S5P_FIMC_TX_END_NOTIFY
+ * @arg: pointer to an u32 type integer that stores the frame payload value
+ *
+ * The End Of Frame notification sent by sensor subdev in its still capture
+ * mode. If there is only a single VSYNC generated by the sensor at the
+ * beginning of a frame transmission, FIMC does not issue the LastIrq
+ * (end of frame) interrupt. And this notification is used to complete the
+ * frame capture and returning a buffer to user-space. Subdev drivers should
+ * call this notification from their last 'End of frame capture' interrupt.
+ */
+void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
+			void *arg)
+{
+	struct fimc_sensor_info	*sensor;
+	struct fimc_vid_buffer *buf;
+	struct fimc_md *fmd;
+	struct fimc_dev *fimc;
+	unsigned long flags;
+
+	if (sd == NULL)
+		return;
+
+	sensor = v4l2_get_subdev_hostdata(sd);
+	fmd = entity_to_fimc_mdev(&sd->entity);
+
+	spin_lock_irqsave(&fmd->slock, flags);
+	fimc = sensor ? sensor->host : NULL;
+
+	if (fimc && arg && notification == S5P_FIMC_TX_END_NOTIFY &&
+	    test_bit(ST_CAPT_PEND, &fimc->state)) {
+		unsigned long irq_flags;
+		spin_lock_irqsave(&fimc->slock, irq_flags);
+		if (!list_empty(&fimc->vid_cap.active_buf_q)) {
+			buf = list_entry(fimc->vid_cap.active_buf_q.next,
+					 struct fimc_vid_buffer, list);
+			vb2_set_plane_payload(&buf->vb, 0, *((u32 *)arg));
+		}
+		fimc_capture_irq_handler(fimc, true);
+		fimc_deactivate_capture(fimc);
+		spin_unlock_irqrestore(&fimc->slock, irq_flags);
+	}
+	spin_unlock_irqrestore(&fmd->slock, flags);
+}
+
 static int fimc_subdev_enum_mbus_code(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_fh *fh,
 				      struct v4l2_subdev_mbus_code_enum *code)
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 6a0f613..781fb10 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -722,6 +722,8 @@ void fimc_unregister_capture_device(struct fimc_dev *fimc);
 int fimc_capture_ctrls_create(struct fimc_dev *fimc);
 int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 			     struct fimc_vid_buffer *fimc_vb);
+void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
+			void *arg);
 int fimc_capture_suspend(struct fimc_dev *fimc);
 int fimc_capture_resume(struct fimc_dev *fimc);
 int fimc_capture_config_update(struct fimc_ctx *ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index a932ee1..aea1790 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -728,6 +728,7 @@ static int __devinit fimc_md_probe(struct platform_device *pdev)
 
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
+	v4l2_dev->notify = fimc_sensor_notify;
 	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
 		 dev_name(&pdev->dev));
 
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 086a7aa..2b58904 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -60,4 +60,13 @@ struct s5p_platform_fimc {
 	struct s5p_fimc_isp_info *isp_info;
 	int num_clients;
 };
+
+/*
+ * v4l2_device notification id. This is only for internal use in the kernel.
+ * Sensor subdevs should issue S5P_FIMC_TX_END_NOTIFY notification in single
+ * frame capture mode when there is only one VSYNC pulse issued by the sensor
+ * at begining of the frame transmission.
+ */
+#define S5P_FIMC_TX_END_NOTIFY _IO('e', 0)
+
 #endif /* S5P_FIMC_H_ */
-- 
1.7.5.4

