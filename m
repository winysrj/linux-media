Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1940 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3AaKZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/18] tlg2300: switch to v4l2_fh.
Date: Thu, 31 Jan 2013 11:25:25 +0100
Message-Id: <ba65d0385e9368b1c7d1d7bb8b8855893dc170d7.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This switch to v4l2_fh resolves the last v4l2_compliance issues with respect
to control events and priority handling.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-common.h |    1 -
 drivers/media/usb/tlg2300/pd-main.c   |    3 ++-
 drivers/media/usb/tlg2300/pd-radio.c  |   35 ++++++++++++++++++---------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
index b26082a..67ad065 100644
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -116,7 +116,6 @@ struct poseidon_audio {
 
 struct radio_data {
 	__u32		fm_freq;
-	int		users;
 	unsigned int	is_radio_streaming;
 	int		pre_emphasis;
 	struct video_device fm_dev;
diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
index c4eb57a..5be5a73 100644
--- a/drivers/media/usb/tlg2300/pd-main.c
+++ b/drivers/media/usb/tlg2300/pd-main.c
@@ -267,7 +267,8 @@ static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
 static inline int get_autopm_ref(struct poseidon *pd)
 {
 	return  pd->video_data.users + pd->vbi_data.users + pd->audio.users
-		+ atomic_read(&pd->dvb_data.users) + pd->radio_data.users;
+		+ atomic_read(&pd->dvb_data.users) +
+		!list_empty(&pd->radio_data.fm_dev.fh_list);
 }
 
 /* fixup something for poseidon */
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 45b3d7a..854ffa0 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -9,6 +9,8 @@
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-fh.h>
 #include <linux/sched.h>
 
 #include "pd-common.h"
@@ -77,13 +79,9 @@ static int pm_fm_resume(struct poseidon *p)
 
 static int poseidon_fm_open(struct file *filp)
 {
-	struct video_device *vfd = video_devdata(filp);
-	struct poseidon *p = video_get_drvdata(vfd);
+	struct poseidon *p = video_drvdata(filp);
 	int ret = 0;
 
-	if (!p)
-		return -1;
-
 	mutex_lock(&p->lock);
 	if (p->state & POSEIDON_STATE_DISCONNECT) {
 		ret = -ENODEV;
@@ -94,9 +92,14 @@ static int poseidon_fm_open(struct file *filp)
 		ret = -EBUSY;
 		goto out;
 	}
+	ret = v4l2_fh_open(filp);
+	if (ret)
+		goto out;
 
 	usb_autopm_get_interface(p->interface);
 	if (0 == p->state) {
+		struct video_device *vfd = &p->radio_data.fm_dev;
+
 		/* default pre-emphasis */
 		if (p->radio_data.pre_emphasis == 0)
 			p->radio_data.pre_emphasis = TLG_TUNE_ASTD_FM_EUR;
@@ -109,9 +112,7 @@ static int poseidon_fm_open(struct file *filp)
 		}
 		p->state |= POSEIDON_STATE_FM;
 	}
-	p->radio_data.users++;
 	kref_get(&p->kref);
-	filp->private_data = p;
 out:
 	mutex_unlock(&p->lock);
 	return ret;
@@ -119,13 +120,12 @@ out:
 
 static int poseidon_fm_close(struct file *filp)
 {
-	struct poseidon *p = filp->private_data;
+	struct poseidon *p = video_drvdata(filp);
 	struct radio_data *fm = &p->radio_data;
 	uint32_t status;
 
 	mutex_lock(&p->lock);
-	fm->users--;
-	if (0 == fm->users)
+	if (v4l2_fh_is_singular_file(filp))
 		p->state &= ~POSEIDON_STATE_FM;
 
 	if (fm->is_radio_streaming && filp == p->file_for_stream) {
@@ -136,14 +136,13 @@ static int poseidon_fm_close(struct file *filp)
 	mutex_unlock(&p->lock);
 
 	kref_put(&p->kref, poseidon_delete);
-	filp->private_data = NULL;
-	return 0;
+	return v4l2_fh_release(filp);
 }
 
 static int vidioc_querycap(struct file *file, void *priv,
 			struct v4l2_capability *v)
 {
-	struct poseidon *p = file->private_data;
+	struct poseidon *p = video_drvdata(file);
 
 	strlcpy(v->driver, "tele-radio", sizeof(v->driver));
 	strlcpy(v->card, "Telegent Poseidon", sizeof(v->card));
@@ -156,15 +155,16 @@ static const struct v4l2_file_operations poseidon_fm_fops = {
 	.owner         = THIS_MODULE,
 	.open          = poseidon_fm_open,
 	.release       = poseidon_fm_close,
+	.poll		= v4l2_ctrl_poll,
 	.unlocked_ioctl = video_ioctl2,
 };
 
 static int tlg_fm_vidioc_g_tuner(struct file *file, void *priv,
 				 struct v4l2_tuner *vt)
 {
+	struct poseidon *p = video_drvdata(file);
 	struct tuner_fm_sig_stat_s fm_stat = {};
 	int ret, status, count = 5;
-	struct poseidon *p = file->private_data;
 
 	if (vt->index != 0)
 		return -EINVAL;
@@ -206,7 +206,7 @@ static int tlg_fm_vidioc_g_tuner(struct file *file, void *priv,
 static int fm_get_freq(struct file *file, void *priv,
 		       struct v4l2_frequency *argp)
 {
-	struct poseidon *p = file->private_data;
+	struct poseidon *p = video_drvdata(file);
 
 	if (argp->tuner)
 		return -EINVAL;
@@ -249,7 +249,7 @@ error:
 static int fm_set_freq(struct file *file, void *priv,
 		       struct v4l2_frequency *argp)
 {
-	struct poseidon *p = file->private_data;
+	struct poseidon *p = video_drvdata(file);
 
 	if (argp->tuner)
 		return -EINVAL;
@@ -293,6 +293,8 @@ static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
 	.vidioc_g_tuner     = tlg_fm_vidioc_g_tuner,
 	.vidioc_g_frequency = fm_get_freq,
 	.vidioc_s_frequency = fm_set_freq,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device poseidon_fm_template = {
@@ -320,6 +322,7 @@ int poseidon_fm_init(struct poseidon *p)
 	}
 	vfd->v4l2_dev = &p->v4l2_dev;
 	vfd->ctrl_handler = hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 	video_set_drvdata(vfd, p);
 	return video_register_device(vfd, VFL_TYPE_RADIO, -1);
 }
-- 
1.7.10.4

