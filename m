Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:47985 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968610Ab0B1PCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 10:02:40 -0500
Message-ID: <4B8A8587.10306@freemail.hu>
Date: Sun, 28 Feb 2010 16:02:31 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>,
	Huang Shijie <zyziii@telegent.com>,
	Huang Shijie <shijie8@gmail.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tlg2300: make local variables and functions static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Make the local variables and functions static. Some of them are not exported by their
symbol name but used trough other means. For example a pointer of the operation
structure is passed through a function call.

This will remove the following sparse warnings (see "make C=1"):
 * pd-video.c:20:5: warning: symbol 'usb_transfer_mode' was not declared. Should it be static?
 * pd-video.c:621:5: warning: symbol 'fire_all_urb' was not declared. Should it be static?
 * pd-video.c:881:5: warning: symbol 'vidioc_s_std' was not declared. Should it be static?
 * pd-video.c:1024:5: warning: symbol 'vidioc_g_audio' was not declared. Should it be static?
 * pd-video.c:1033:5: warning: symbol 'vidioc_s_audio' was not declared. Should it be static?
 * pd-video.c:1193:5: warning: symbol 'usb_transfer_stop' was not declared. Should it be static?
 * pd-video.c:1522:14: warning: symbol 'pd_video_poll' was not declared. Should it be static?
 * pd-video.c:1528:9: warning: symbol 'pd_video_read' was not declared. Should it be static?
 * pd-radio.c:164:5: warning: symbol 'tlg_fm_vidioc_g_tuner' was not declared. Should it be static?
 * pd-radio.c:206:5: warning: symbol 'fm_get_freq' was not declared. Should it be static?
 * pd-radio.c:249:5: warning: symbol 'fm_set_freq' was not declared. Should it be static?
 * pd-radio.c:261:5: warning: symbol 'tlg_fm_vidioc_g_ctrl' was not declared. Should it be static?
 * pd-radio.c:267:5: warning: symbol 'tlg_fm_vidioc_g_exts_ctrl' was not declared. Should it be static?
 * pd-radio.c:288:5: warning: symbol 'tlg_fm_vidioc_s_exts_ctrl' was not declared. Should it be static?
 * pd-radio.c:315:5: warning: symbol 'tlg_fm_vidioc_s_ctrl' was not declared. Should it be static?
 * pd-radio.c:321:5: warning: symbol 'tlg_fm_vidioc_queryctrl' was not declared. Should it be static?
 * pd-radio.c:340:5: warning: symbol 'tlg_fm_vidioc_querymenu' was not declared. Should it be static?
 * pd-main.c:58:12: warning: symbol 'firmware_name' was not declared. Should it be static?
 * pd-main.c:59:19: warning: symbol 'poseidon_driver' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr v4l-dvb.orig/linux/drivers/media/video/tlg2300/pd-main.c v4l-dvb/linux/drivers/media/video/tlg2300/pd-main.c
--- v4l-dvb.orig/linux/drivers/media/video/tlg2300/pd-main.c	2010-02-28 14:54:31.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/tlg2300/pd-main.c	2010-02-28 15:49:10.000000000 +0100
@@ -55,8 +55,8 @@ int debug_mode;
 module_param(debug_mode, int, 0644);
 MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");

-const char *firmware_name = "tlg2300_firmware.bin";
-struct usb_driver poseidon_driver;
+static const char *firmware_name = "tlg2300_firmware.bin";
+static struct usb_driver poseidon_driver;
 static LIST_HEAD(pd_device_list);

 /*
@@ -501,7 +501,7 @@ static void poseidon_disconnect(struct u
 	kref_put(&pd->kref, poseidon_delete);
 }

-struct usb_driver poseidon_driver = {
+static struct usb_driver poseidon_driver = {
 	.name		= "poseidon",
 	.probe		= poseidon_probe,
 	.disconnect	= poseidon_disconnect,
diff -upr v4l-dvb.orig/linux/drivers/media/video/tlg2300/pd-radio.c v4l-dvb/linux/drivers/media/video/tlg2300/pd-radio.c
--- v4l-dvb.orig/linux/drivers/media/video/tlg2300/pd-radio.c	2010-02-28 14:54:31.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/tlg2300/pd-radio.c	2010-02-28 15:48:07.000000000 +0100
@@ -161,7 +161,7 @@ static const struct v4l2_file_operations
 	.ioctl	       = video_ioctl2,
 };

-int tlg_fm_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
+static int tlg_fm_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
 {
 	struct tuner_fm_sig_stat_s fm_stat = {};
 	int ret, status, count = 5;
@@ -203,7 +203,7 @@ int tlg_fm_vidioc_g_tuner(struct file *f
 	return 0;
 }

-int fm_get_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
+static int fm_get_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
 {
 	struct poseidon *p = file->private_data;

@@ -246,7 +246,7 @@ error:
 	return ret;
 }

-int fm_set_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
+static int fm_set_freq(struct file *file, void *priv, struct v4l2_frequency *argp)
 {
 	struct poseidon *p = file->private_data;

@@ -258,13 +258,13 @@ int fm_set_freq(struct file *file, void
 	return set_frequency(p, argp->frequency);
 }

-int tlg_fm_vidioc_g_ctrl(struct file *file, void *priv,
+static int tlg_fm_vidioc_g_ctrl(struct file *file, void *priv,
 		struct v4l2_control *arg)
 {
 	return 0;
 }

-int tlg_fm_vidioc_g_exts_ctrl(struct file *file, void *fh,
+static int tlg_fm_vidioc_g_exts_ctrl(struct file *file, void *fh,
 				struct v4l2_ext_controls *ctrls)
 {
 	struct poseidon *p = file->private_data;
@@ -285,7 +285,7 @@ int tlg_fm_vidioc_g_exts_ctrl(struct fil
 	return 0;
 }

-int tlg_fm_vidioc_s_exts_ctrl(struct file *file, void *fh,
+static int tlg_fm_vidioc_s_exts_ctrl(struct file *file, void *fh,
 			struct v4l2_ext_controls *ctrls)
 {
 	int i;
@@ -312,13 +312,13 @@ int tlg_fm_vidioc_s_exts_ctrl(struct fil
 	return 0;
 }

-int tlg_fm_vidioc_s_ctrl(struct file *file, void *priv,
+static int tlg_fm_vidioc_s_ctrl(struct file *file, void *priv,
 		struct v4l2_control *ctrl)
 {
 	return 0;
 }

-int tlg_fm_vidioc_queryctrl(struct file *file, void *priv,
+static int tlg_fm_vidioc_queryctrl(struct file *file, void *priv,
 		struct v4l2_queryctrl *ctrl)
 {
 	if (!(ctrl->id & V4L2_CTRL_FLAG_NEXT_CTRL))
@@ -337,7 +337,7 @@ int tlg_fm_vidioc_queryctrl(struct file
 	return -EINVAL;
 }

-int tlg_fm_vidioc_querymenu(struct file *file, void *fh,
+static int tlg_fm_vidioc_querymenu(struct file *file, void *fh,
 				struct v4l2_querymenu *qmenu)
 {
 	return v4l2_ctrl_query_menu(qmenu, NULL, NULL);
diff -upr v4l-dvb.orig/linux/drivers/media/video/tlg2300/pd-video.c v4l-dvb/linux/drivers/media/video/tlg2300/pd-video.c
--- v4l-dvb.orig/linux/drivers/media/video/tlg2300/pd-video.c	2010-02-28 15:00:55.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/tlg2300/pd-video.c	2010-02-28 15:44:59.000000000 +0100
@@ -17,7 +17,7 @@ static int pm_video_resume(struct poseid
 #endif
 static void iso_bubble_handler(struct work_struct *w);

-int usb_transfer_mode;
+static int usb_transfer_mode;
 module_param(usb_transfer_mode, int, 0644);
 MODULE_PARM_DESC(usb_transfer_mode, "0 = Bulk, 1 = Isochronous");

@@ -618,7 +618,7 @@ static int pd_buf_prepare(struct videobu
 	return 0;
 }

-int fire_all_urb(struct video_data *video)
+static int fire_all_urb(struct video_data *video)
 {
 	int i, ret;

@@ -878,7 +878,7 @@ out:
 	return ret;
 }

-int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *norm)
+static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *norm)
 {
 	struct front_face *front = fh;
 	logs(front);
@@ -1021,7 +1021,7 @@ static int vidioc_enumaudio(struct file
 	return 0;
 }

-int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
+static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 {
 	a->index = 0;
 	a->capability = V4L2_AUDCAP_STEREO;
@@ -1030,7 +1030,7 @@ int vidioc_g_audio(struct file *file, vo
 	return 0;
 }

-int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
 {
 	return (0 == a->index) ? 0 : -EINVAL;
 }
@@ -1190,7 +1190,7 @@ static int vidioc_dqbuf(struct file *fil
 }

 /* Just stop the URBs, do not free the URBs */
-int usb_transfer_stop(struct video_data *video)
+static int usb_transfer_stop(struct video_data *video)
 {
 	if (video->is_streaming) {
 		int i;
@@ -1519,13 +1519,13 @@ static int pd_video_mmap(struct file *fi
 	return  videobuf_mmap_mapper(&front->q, vma);
 }

-unsigned int pd_video_poll(struct file *file, poll_table *table)
+static unsigned int pd_video_poll(struct file *file, poll_table *table)
 {
 	struct front_face *front = file->private_data;
 	return videobuf_poll_stream(file, &front->q, table);
 }

-ssize_t pd_video_read(struct file *file, char __user *buffer,
+static ssize_t pd_video_read(struct file *file, char __user *buffer,
 			size_t count, loff_t *ppos)
 {
 	struct front_face *front = file->private_data;
