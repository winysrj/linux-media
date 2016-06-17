Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57388 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbcFQUsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 16:48:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	y2038@lists.linaro.org
Subject: [PATCH v3] [media] omap3isp: support 64-bit version of  omap3isp_stat_data
Date: Fri, 17 Jun 2016 22:50:36 +0200
Message-ID: <5373379.m23LACOa5F@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

C libraries with 64-bit time_t use an incompatible format for
struct omap3isp_stat_data. This changes the kernel code to
support either version, by moving over the normal handling
to the 64-bit variant, and adding compatiblity code to handle
the old binary format with the existing ioctl command code.

Fortunately, the command code includes the size of the structure,
so the difference gets handled automatically.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This patch was originally part of a longer series, along with other patches
that we still have to rewrite for the generic ioctl interface, but the
OMAP specific ioctl commands are completely independent of that, so I think
we can just merge this version for 4.8.

Compared to the previous version, I am no longer using 'struct v4l2_timeval'
now, but just define the kernel-internal type as part of omap3isp_stat_data.

diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index ccaf92f39236..2d567725608f 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -250,6 +250,8 @@ static long h3a_aewb_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 		return omap3isp_stat_config(stat, arg);
 	case VIDIOC_OMAP3ISP_STAT_REQ:
 		return omap3isp_stat_request_statistics(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
+		return omap3isp_stat_request_statistics_time32(stat, arg);
 	case VIDIOC_OMAP3ISP_STAT_EN: {
 		unsigned long *en = arg;
 		return omap3isp_stat_enable(stat, !!*en);
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index 92937f7eecef..2ac02371318b 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -314,6 +314,8 @@ static long h3a_af_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 		return omap3isp_stat_config(stat, arg);
 	case VIDIOC_OMAP3ISP_STAT_REQ:
 		return omap3isp_stat_request_statistics(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
+		return omap3isp_stat_request_statistics_time32(stat, arg);
 	case VIDIOC_OMAP3ISP_STAT_EN: {
 		int *en = arg;
 		return omap3isp_stat_enable(stat, !!*en);
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 7138b043a4aa..669b97b079ee 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -436,6 +436,8 @@ static long hist_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 		return omap3isp_stat_config(stat, arg);
 	case VIDIOC_OMAP3ISP_STAT_REQ:
 		return omap3isp_stat_request_statistics(stat, arg);
+	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
+		return omap3isp_stat_request_statistics_time32(stat, arg);
 	case VIDIOC_OMAP3ISP_STAT_EN: {
 		int *en = arg;
 		return omap3isp_stat_enable(stat, !!*en);
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 1b9217d3b1b6..3025a9170e0c 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -508,6 +508,21 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
 	return 0;
 }
 
+int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
+					struct omap3isp_stat_data_time32 *data)
+{
+	struct omap3isp_stat_data data64;
+	int ret;
+
+	ret = omap3isp_stat_request_statistics(stat, &data64);
+
+	data->ts.tv_sec = data64.ts.tv_sec;
+	data->ts.tv_usec = data64.ts.tv_usec;
+	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
+
+	return ret;
+}
+
 /*
  * omap3isp_stat_config - Receives new statistic engine configuration.
  * @new_conf: Pointer to config structure.
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 6d9b0244f320..0afa89de09de 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -130,6 +130,8 @@ struct ispstat_generic_config {
 int omap3isp_stat_config(struct ispstat *stat, void *new_conf);
 int omap3isp_stat_request_statistics(struct ispstat *stat,
 				     struct omap3isp_stat_data *data);
+int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
+				     struct omap3isp_stat_data_time32 *data);
 int omap3isp_stat_init(struct ispstat *stat, const char *name,
 		       const struct v4l2_subdev_ops *sd_ops);
 void omap3isp_stat_cleanup(struct ispstat *stat);
diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
index c090cf9249bb..076d3f3a79d9 100644
--- a/include/uapi/linux/omap3isp.h
+++ b/include/uapi/linux/omap3isp.h
@@ -54,6 +54,8 @@
 	_IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct omap3isp_h3a_af_config)
 #define VIDIOC_OMAP3ISP_STAT_REQ \
 	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct omap3isp_stat_data)
+#define VIDIOC_OMAP3ISP_STAT_REQ_TIME32 \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct omap3isp_stat_data_time32)
 #define VIDIOC_OMAP3ISP_STAT_EN \
 	_IOWR('V', BASE_VIDIOC_PRIVATE + 7, unsigned long)
 
@@ -164,7 +166,14 @@ struct omap3isp_h3a_aewb_config {
  * @config_counter: Number of the configuration associated with the data.
  */
 struct omap3isp_stat_data {
+#ifdef __KERNEL__
+	struct {
+		__s64	tv_sec;
+		__s64	tv_usec;
+	};
+#else
 	struct timeval ts;
+#endif
 	void __user *buf;
 	__u32 buf_size;
 	__u16 frame_number;
@@ -172,6 +181,19 @@ struct omap3isp_stat_data {
 	__u16 config_counter;
 };
 
+#ifdef __KERNEL__
+struct omap3isp_stat_data_time32 {
+	struct {
+		__s32	tv_sec;
+		__s32	tv_usec;
+	} ts;
+	__u32 buf;
+	__u32 buf_size;
+	__u16 frame_number;
+	__u16 cur_frame;
+	__u16 config_counter;
+};
+#endif
 
 /* Histogram related structs */
 

