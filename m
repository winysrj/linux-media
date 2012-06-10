Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2969 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2FJK0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 02/32] v4l2-ioctl.c: move a block of code down, no other changes.
Date: Sun, 10 Jun 2012 12:25:24 +0200
Message-Id: <34fa84b0672a439ee6a4afacc33266901cfb82e9.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A block of code is moved down in the code to make later changes easier.
Do just the move without other changes to keep the diff readable for the
upcoming patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  288 +++++++++++++++++++-------------------
 1 file changed, 144 insertions(+), 144 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 91be4e8..7c6831f 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -183,150 +183,6 @@ static const char *v4l2_memory_names[] = {
 /* ------------------------------------------------------------------ */
 /* debug help functions                                               */
 
-struct v4l2_ioctl_info {
-	unsigned int ioctl;
-	u16 flags;
-	const char * const name;
-};
-
-/* This control needs a priority check */
-#define INFO_FL_PRIO	(1 << 0)
-/* This control can be valid if the filehandle passes a control handler. */
-#define INFO_FL_CTRL	(1 << 1)
-
-#define IOCTL_INFO(_ioctl, _flags) [_IOC_NR(_ioctl)] = {	\
-	.ioctl = _ioctl,					\
-	.flags = _flags,					\
-	.name = #_ioctl,					\
-}
-
-static struct v4l2_ioctl_info v4l2_ioctls[] = {
-	IOCTL_INFO(VIDIOC_QUERYCAP, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FMT, 0),
-	IOCTL_INFO(VIDIOC_G_FMT, 0),
-	IOCTL_INFO(VIDIOC_S_FMT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_REQBUFS, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYBUF, 0),
-	IOCTL_INFO(VIDIOC_G_FBUF, 0),
-	IOCTL_INFO(VIDIOC_S_FBUF, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_OVERLAY, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QBUF, 0),
-	IOCTL_INFO(VIDIOC_DQBUF, 0),
-	IOCTL_INFO(VIDIOC_STREAMON, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_STREAMOFF, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_PARM, 0),
-	IOCTL_INFO(VIDIOC_S_PARM, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_STD, 0),
-	IOCTL_INFO(VIDIOC_S_STD, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_ENUMSTD, 0),
-	IOCTL_INFO(VIDIOC_ENUMINPUT, 0),
-	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_G_TUNER, 0),
-	IOCTL_INFO(VIDIOC_S_TUNER, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_AUDIO, 0),
-	IOCTL_INFO(VIDIOC_S_AUDIO, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_G_INPUT, 0),
-	IOCTL_INFO(VIDIOC_S_INPUT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_OUTPUT, 0),
-	IOCTL_INFO(VIDIOC_S_OUTPUT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_ENUMOUTPUT, 0),
-	IOCTL_INFO(VIDIOC_G_AUDOUT, 0),
-	IOCTL_INFO(VIDIOC_S_AUDOUT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_MODULATOR, 0),
-	IOCTL_INFO(VIDIOC_S_MODULATOR, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_FREQUENCY, 0),
-	IOCTL_INFO(VIDIOC_S_FREQUENCY, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_CROPCAP, 0),
-	IOCTL_INFO(VIDIOC_G_CROP, 0),
-	IOCTL_INFO(VIDIOC_S_CROP, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_SELECTION, 0),
-	IOCTL_INFO(VIDIOC_S_SELECTION, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
-	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
-	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
-	IOCTL_INFO(VIDIOC_ENUMAUDIO, 0),
-	IOCTL_INFO(VIDIOC_ENUMAUDOUT, 0),
-	IOCTL_INFO(VIDIOC_G_PRIORITY, 0),
-	IOCTL_INFO(VIDIOC_S_PRIORITY, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, 0),
-	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
-	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, 0),
-	IOCTL_INFO(VIDIOC_G_ENC_INDEX, 0),
-	IOCTL_INFO(VIDIOC_ENCODER_CMD, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, 0),
-	IOCTL_INFO(VIDIOC_DECODER_CMD, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, 0),
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
-	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
-#endif
-	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
-	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
-	IOCTL_INFO(VIDIOC_S_DV_PRESET, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_DV_PRESET, 0),
-	IOCTL_INFO(VIDIOC_QUERY_DV_PRESET, 0),
-	IOCTL_INFO(VIDIOC_S_DV_TIMINGS, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_DV_TIMINGS, 0),
-	IOCTL_INFO(VIDIOC_DQEVENT, 0),
-	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, 0),
-	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, 0),
-	IOCTL_INFO(VIDIOC_CREATE_BUFS, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_PREPARE_BUF, 0),
-	IOCTL_INFO(VIDIOC_ENUM_DV_TIMINGS, 0),
-	IOCTL_INFO(VIDIOC_QUERY_DV_TIMINGS, 0),
-	IOCTL_INFO(VIDIOC_DV_TIMINGS_CAP, 0),
-};
-#define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
-
-bool v4l2_is_known_ioctl(unsigned int cmd)
-{
-	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
-		return false;
-	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
-}
-
-/* Common ioctl debug function. This function can be used by
-   external ioctl messages as well as internal V4L ioctl */
-void v4l_printk_ioctl(unsigned int cmd)
-{
-	char *dir, *type;
-
-	switch (_IOC_TYPE(cmd)) {
-	case 'd':
-		type = "v4l2_int";
-		break;
-	case 'V':
-		if (_IOC_NR(cmd) >= V4L2_IOCTLS) {
-			type = "v4l2";
-			break;
-		}
-		printk("%s", v4l2_ioctls[_IOC_NR(cmd)].name);
-		return;
-	default:
-		type = "unknown";
-	}
-
-	switch (_IOC_DIR(cmd)) {
-	case _IOC_NONE:              dir = "--"; break;
-	case _IOC_READ:              dir = "r-"; break;
-	case _IOC_WRITE:             dir = "-w"; break;
-	case _IOC_READ | _IOC_WRITE: dir = "rw"; break;
-	default:                     dir = "*ERR*"; break;
-	}
-	printk("%s ioctl '%c', dir=%s, #%d (0x%08x)",
-		type, _IOC_TYPE(cmd), dir, _IOC_NR(cmd), cmd);
-}
-EXPORT_SYMBOL(v4l_printk_ioctl);
-
 static void dbgbuf(unsigned int cmd, struct video_device *vfd,
 					struct v4l2_buffer *p)
 {
@@ -536,6 +392,150 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 	return -EINVAL;
 }
 
+struct v4l2_ioctl_info {
+	unsigned int ioctl;
+	u16 flags;
+	const char * const name;
+};
+
+/* This control needs a priority check */
+#define INFO_FL_PRIO	(1 << 0)
+/* This control can be valid if the filehandle passes a control handler. */
+#define INFO_FL_CTRL	(1 << 1)
+
+#define IOCTL_INFO(_ioctl, _flags) [_IOC_NR(_ioctl)] = {	\
+	.ioctl = _ioctl,					\
+	.flags = _flags,					\
+	.name = #_ioctl,					\
+}
+
+static struct v4l2_ioctl_info v4l2_ioctls[] = {
+	IOCTL_INFO(VIDIOC_QUERYCAP, 0),
+	IOCTL_INFO(VIDIOC_ENUM_FMT, 0),
+	IOCTL_INFO(VIDIOC_G_FMT, 0),
+	IOCTL_INFO(VIDIOC_S_FMT, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_REQBUFS, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_QUERYBUF, 0),
+	IOCTL_INFO(VIDIOC_G_FBUF, 0),
+	IOCTL_INFO(VIDIOC_S_FBUF, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_OVERLAY, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_QBUF, 0),
+	IOCTL_INFO(VIDIOC_DQBUF, 0),
+	IOCTL_INFO(VIDIOC_STREAMON, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_STREAMOFF, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_PARM, 0),
+	IOCTL_INFO(VIDIOC_S_PARM, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_STD, 0),
+	IOCTL_INFO(VIDIOC_S_STD, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_ENUMSTD, 0),
+	IOCTL_INFO(VIDIOC_ENUMINPUT, 0),
+	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_PRIO | INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_G_TUNER, 0),
+	IOCTL_INFO(VIDIOC_S_TUNER, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_AUDIO, 0),
+	IOCTL_INFO(VIDIOC_S_AUDIO, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_G_INPUT, 0),
+	IOCTL_INFO(VIDIOC_S_INPUT, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_OUTPUT, 0),
+	IOCTL_INFO(VIDIOC_S_OUTPUT, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_ENUMOUTPUT, 0),
+	IOCTL_INFO(VIDIOC_G_AUDOUT, 0),
+	IOCTL_INFO(VIDIOC_S_AUDOUT, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_MODULATOR, 0),
+	IOCTL_INFO(VIDIOC_S_MODULATOR, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_FREQUENCY, 0),
+	IOCTL_INFO(VIDIOC_S_FREQUENCY, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_CROPCAP, 0),
+	IOCTL_INFO(VIDIOC_G_CROP, 0),
+	IOCTL_INFO(VIDIOC_S_CROP, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_SELECTION, 0),
+	IOCTL_INFO(VIDIOC_S_SELECTION, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
+	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
+	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
+	IOCTL_INFO(VIDIOC_ENUMAUDIO, 0),
+	IOCTL_INFO(VIDIOC_ENUMAUDOUT, 0),
+	IOCTL_INFO(VIDIOC_G_PRIORITY, 0),
+	IOCTL_INFO(VIDIOC_S_PRIORITY, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, 0),
+	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
+	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, INFO_FL_PRIO | INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS, 0),
+	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, 0),
+	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, 0),
+	IOCTL_INFO(VIDIOC_G_ENC_INDEX, 0),
+	IOCTL_INFO(VIDIOC_ENCODER_CMD, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, 0),
+	IOCTL_INFO(VIDIOC_DECODER_CMD, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, 0),
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
+	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
+#endif
+	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
+	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
+	IOCTL_INFO(VIDIOC_S_DV_PRESET, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_DV_PRESET, 0),
+	IOCTL_INFO(VIDIOC_QUERY_DV_PRESET, 0),
+	IOCTL_INFO(VIDIOC_S_DV_TIMINGS, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_G_DV_TIMINGS, 0),
+	IOCTL_INFO(VIDIOC_DQEVENT, 0),
+	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, 0),
+	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, 0),
+	IOCTL_INFO(VIDIOC_CREATE_BUFS, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_PREPARE_BUF, 0),
+	IOCTL_INFO(VIDIOC_ENUM_DV_TIMINGS, 0),
+	IOCTL_INFO(VIDIOC_QUERY_DV_TIMINGS, 0),
+	IOCTL_INFO(VIDIOC_DV_TIMINGS_CAP, 0),
+};
+#define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
+
+bool v4l2_is_known_ioctl(unsigned int cmd)
+{
+	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
+		return false;
+	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
+}
+
+/* Common ioctl debug function. This function can be used by
+   external ioctl messages as well as internal V4L ioctl */
+void v4l_printk_ioctl(unsigned int cmd)
+{
+	char *dir, *type;
+
+	switch (_IOC_TYPE(cmd)) {
+	case 'd':
+		type = "v4l2_int";
+		break;
+	case 'V':
+		if (_IOC_NR(cmd) >= V4L2_IOCTLS) {
+			type = "v4l2";
+			break;
+		}
+		printk("%s", v4l2_ioctls[_IOC_NR(cmd)].name);
+		return;
+	default:
+		type = "unknown";
+	}
+
+	switch (_IOC_DIR(cmd)) {
+	case _IOC_NONE:              dir = "--"; break;
+	case _IOC_READ:              dir = "r-"; break;
+	case _IOC_WRITE:             dir = "-w"; break;
+	case _IOC_READ | _IOC_WRITE: dir = "rw"; break;
+	default:                     dir = "*ERR*"; break;
+	}
+	printk("%s ioctl '%c', dir=%s, #%d (0x%08x)",
+		type, _IOC_TYPE(cmd), dir, _IOC_NR(cmd), cmd);
+}
+EXPORT_SYMBOL(v4l_printk_ioctl);
+
 static long __video_do_ioctl(struct file *file,
 		unsigned int cmd, void *arg)
 {
-- 
1.7.10

