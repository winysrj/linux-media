Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1776 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2IULon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 07:44:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] radio drivers: in non-blocking mode return EAGAIN in hwseek
Date: Fri, 21 Sep 2012 13:44:28 +0200
Message-Id: <784ec8de69973364a5742bcf09bc81bcb2f97305.1348227670.git.hans.verkuil@cisco.com>
In-Reply-To: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
References: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <187f1fb0891d7ddeef202c6be7d86209c354a632.1348227670.git.hans.verkuil@cisco.com>
References: <187f1fb0891d7ddeef202c6be7d86209c354a632.1348227670.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

VIDIOC_S_HW_FREQ_SEEK should return EAGAIN when called in non-blocking
mode. This might change in the future if we add support for this in the
future, but right now this is not supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-mr800.c                |    3 +++
 drivers/media/radio/radio-tea5777.c              |    3 +++
 drivers/media/radio/radio-wl1273.c               |    3 +++
 drivers/media/radio/si470x/radio-si470x-common.c |    3 +++
 drivers/media/radio/wl128x/fmdrv_v4l2.c          |    3 +++
 5 files changed, 15 insertions(+)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 3182b26..ec7acfa 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -360,6 +360,9 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	if (seek->tuner != 0 || !seek->wrap_around)
 		return -EINVAL;
 
+	if (file->f_flags & O_NONBLOCK)
+		return -EWOULDBLOCK;
+
 	retval = amradio_send_cmd(radio,
 			AMRADIO_SET_SEARCH_LVL, 0, buf, 8, false);
 	if (retval)
diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
index ef82898..50935d5 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -395,6 +395,9 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
 	if (a->tuner || a->wrap_around)
 		return -EINVAL;
 
+	if (file->f_flags & O_NONBLOCK)
+		return -EWOULDBLOCK;
+
 	if (a->rangelow || a->rangehigh) {
 		for (i = 0; i < ARRAY_SIZE(bands); i++) {
 			if (i == BAND_AM && !tea->has_am)
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index a22ad1c..7ff2b3de 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1693,6 +1693,9 @@ static int wl1273_fm_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	if (seek->tuner != 0 || seek->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
 
+	if (file->f_flags & O_NONBLOCK)
+		return -EWOULDBLOCK;
+
 	if (mutex_lock_interruptible(&core->lock))
 		return -EINTR;
 
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 9bb65e1..fd74f5c 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -708,6 +708,9 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	if (seek->tuner != 0)
 		return -EINVAL;
 
+	if (file->f_flags & O_NONBLOCK)
+		return -EWOULDBLOCK;
+
 	return si470x_set_seek(radio, seek);
 }
 
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index db2248e..8d1c094 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -408,6 +408,9 @@ static int fm_v4l2_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	struct fmdev *fmdev = video_drvdata(file);
 	int ret;
 
+	if (file->f_flags & O_NONBLOCK)
+		return -EWOULDBLOCK;
+
 	if (fmdev->curr_fmmode != FM_MODE_RX) {
 		ret = fmc_set_mode(fmdev, FM_MODE_RX);
 		if (ret != 0) {
-- 
1.7.10.4

