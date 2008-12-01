Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB19g2Cl031996
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 04:42:02 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB19fnRg020623
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 04:41:50 -0500
Date: Mon, 1 Dec 2008 10:41:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <873ah8n8d3.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0812011039550.3915@axis700.grange>
References: <20081107130136.fkdeaklvs40ocsws@webmail.hebergement.com>
	<Pine.LNX.4.64.0811290229070.7032@axis700.grange>
	<873ah8n8d3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: [PATCH 1/2] soc-camera: add camera sense data
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Add a struct soc_camera_sense, that can be used by camera host drivers to
request additional information from a camera driver, for example, when
changing data format. This struct can be extended in the future, its first use
is to request the camera driver whether the pixel-clock frequency has changed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/soc_camera.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index da57ffd..7832d97 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -36,6 +36,7 @@ struct soc_camera_device {
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
 	unsigned char buswidth;		/* See comment in .c */
+	struct soc_camera_sense *sense;	/* See comment in struct definition */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
 	const struct soc_camera_data_format *current_fmt;
@@ -164,6 +165,32 @@ struct soc_camera_ops {
 	int num_controls;
 };
 
+#define SOCAM_SENSE_PCLK_CHANGED	(1 << 0)
+
+/**
+ * This struct can be attached to struct soc_camera_device by the host driver
+ * to request sense from the camera, for example, when calling .set_fmt(). The
+ * host then can check which flags are set and verify respective values if any.
+ * For example, if SOCAM_SENSE_PCLK_CHANGED is set, it means, pixclock has
+ * changed during this operation. After completion the host should detach sense.
+ *
+ * @flags		ored SOCAM_SENSE_* flags
+ * @master_clock	if the host wants to be informed about pixel-clock
+ *			change, it better set master_clock.
+ * @pixel_clock_max	maximum pixel clock frequency supported by the host,
+ *			camera is not allowed to exceed this.
+ * @pixel_clock		if the camera driver changed pixel clock during this
+ *			operation, it sets SOCAM_SENSE_PCLK_CHANGED, uses
+ *			master_clock to calculate the new pixel-clock and
+ *			sets it.
+ */
+struct soc_camera_sense {
+	unsigned long flags;
+	unsigned long master_clock;
+	unsigned long pixel_clock_max;
+	unsigned long pixel_clock;
+};
+
 static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 	struct soc_camera_ops *ops, int id)
 {
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
