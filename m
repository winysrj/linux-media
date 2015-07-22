Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:44387 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbbGVWm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:59 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 16/19] media: Change v4l-core to check for tuner availability
Date: Wed, 22 Jul 2015 16:42:17 -0600
Message-Id: <690e2d0882325f1f4b67688a42bb8056f46dec7e.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change s_input, s_fmt, s_tuner, s_frequency, querystd,
s_hw_freq_seek, and vb2_streamon interfaces that alter
the tuner configuration to check for tuner availability
by calling v4l_enable_media_tuner(). If tuner isn't free,
return -EBUSY.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c     | 29 +++++++++++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-core.c |  5 +++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 85de455..deffc1b 100644
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
index d835814..f2711e4 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2300,10 +2300,15 @@ EXPORT_SYMBOL_GPL(vb2_queue_error);
  */
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
+	int ret;
+
 	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "file io in progress\n");
 		return -EBUSY;
 	}
+	ret = v4l_enable_media_tuner(q->owner->vdev);
+	if (ret)
+		return ret;
 	return vb2_internal_streamon(q, type);
 }
 EXPORT_SYMBOL_GPL(vb2_streamon);
-- 
2.1.4

