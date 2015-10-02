Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:36544 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbbJBWHm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:42 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 12/20] media: Change v4l-core to check for tuner availability
Date: Fri,  2 Oct 2015 16:07:24 -0600
Message-Id: <e2c7baac1e6c4b81765583425ec33914310697f1.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change s_input, s_fmt, s_tuner, s_frequency, querystd,
s_hw_freq_seek, and vb2_internal_streamon interfaces that
alter the tuner configuration to check for tuner availability
by calling v4l_enable_media_tuner(). If tuner isn't free,
return -EBUSY. v4l_disable_media_tuner() is called from
v4l2_fh_exit() to release the tuner.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-fh.c        |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c     | 29 +++++++++++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-core.c |  3 +++
 3 files changed, 33 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index c97067a..538db62 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -92,6 +92,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
+	v4l_disable_media_tuner(fh->vdev);
 	v4l2_event_unsubscribe_all(fh);
 	fh->vdev = NULL;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 4a384fc..af6dd2f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1035,6 +1035,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
+	int ret;
+
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
 }
 
@@ -1433,6 +1439,9 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	v4l_sanitize_format(p);
 
 	switch (p->type) {
@@ -1612,7 +1621,11 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_tuner *p = arg;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	return ops->vidioc_s_tuner(file, fh, p);
@@ -1650,7 +1663,11 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	if (vfd->vfl_type == VFL_TYPE_SDR) {
 		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
 			return -EINVAL;
@@ -1705,7 +1722,11 @@ static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id id = *(v4l2_std_id *)arg, norm;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	norm = id & vfd->tvnorms;
 	if (vfd->tvnorms && !norm)	/* Check if std is supported */
 		return -EINVAL;
@@ -1719,7 +1740,11 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id *p = arg;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	/*
 	 * If no signal is detected, then the driver should return
 	 * V4L2_STD_UNKNOWN. Otherwise it should return tvnorms with
@@ -1738,7 +1763,11 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_hw_freq_seek *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	/* s_hw_freq_seek is not supported for SDR for now */
 	if (vfd->vfl_type == VFL_TYPE_SDR)
 		return -EINVAL;
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b866a6b..6ea6ad3 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2275,6 +2275,9 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	 * are available.
 	 */
 	if (q->queued_count >= q->min_buffers_needed) {
+		ret = v4l_enable_media_tuner(q->owner->vdev);
+		if (ret)
+			return ret;
 		ret = vb2_start_streaming(q);
 		if (ret) {
 			__vb2_queue_cancel(q);
-- 
2.1.4

