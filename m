Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:57501 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbbGVWm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:57 -0400
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
Subject: [PATCH v2 15/19] media: v4l-core add v4l_enable_media_tuner() to check for tuner availability
Date: Wed, 22 Jul 2015 16:42:16 -0600
Message-Id: <1647341b774540fd9afbc7bb58e1a76510893ad4.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new interface to be used by v4l-core to invoke enable_source
handler in the media_device to find tuner entity connected to the
decoder and check is it is available. enable_source handler will
activate the link if tuner is available.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 17 +++++++++++++++++
 include/media/v4l2-dev.h           |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 71a1b93..00fc71d 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -230,6 +230,23 @@ struct video_device *video_devdata(struct file *file)
 }
 EXPORT_SYMBOL(video_devdata);
 
+int v4l_enable_media_tuner(struct video_device *vdev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = vdev->decoder->parent;
+	int ret;
+
+	/* decoder */
+	if (!mdev || !mdev->enable_source)
+			return 0;
+	ret = mdev->enable_source(vdev->decoder);
+	if (ret)
+		return -EBUSY;
+	return 0;
+#endif /* CONFIG_MEDIA_CONTROLLER */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l_enable_media_tuner);
 
 /* Priority handling */
 
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index acbcd2f..eff3852 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -86,6 +86,7 @@ struct video_device
 {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_entity entity;
+	struct media_entity *decoder;
 #endif
 	/* device ops */
 	const struct v4l2_file_operations *fops;
@@ -178,6 +179,8 @@ struct video_device * __must_check video_device_alloc(void);
 /* this release function frees the vdev pointer */
 void video_device_release(struct video_device *vdev);
 
+int v4l_enable_media_tuner(struct video_device *vdev);
+
 /* this release function does nothing, use when the video_device is a
    static global struct. Note that having a static video_device is
    a dubious construction at best. */
-- 
2.1.4

