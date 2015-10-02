Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:49918 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbbJBWHl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:41 -0400
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
Subject: [PATCH MC Next Gen 07/20] media: v4l-core add v4l_enable/disable_media_tuner() helper functions
Date: Fri,  2 Oct 2015 16:07:19 -0600
Message-Id: <92211f7d4ac97e27443dddf5a8d35a278ebce26a.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new interfaces to be used by v4l-core to invoke enable
source and disable_source handlers in the media_device. The
enable_source helper function invokes the enable_source handler
to find tuner entity connected to the decoder and check is it
is available or busy. If tuner is available, link is activated
and pipeline is started. The disable_source helper function
invokes the disable_source handler to deactivate and stop the
pipeline.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 27 +++++++++++++++++++++++++++
 include/media/v4l2-dev.h           |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 982255d..159e711 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -233,6 +233,33 @@ struct video_device *video_devdata(struct file *file)
 }
 EXPORT_SYMBOL(video_devdata);
 
+int v4l_enable_media_tuner(struct video_device *vdev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = vdev->entity.graph_obj.mdev;
+	int ret;
+
+	if (!mdev || !mdev->enable_source)
+			return 0;
+	ret = mdev->enable_source(&vdev->entity, &vdev->pipe);
+	if (ret)
+		return -EBUSY;
+	return 0;
+#endif /* CONFIG_MEDIA_CONTROLLER */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l_enable_media_tuner);
+
+void v4l_disable_media_tuner(struct video_device *vdev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = vdev->entity.graph_obj.mdev;
+
+	if (mdev && mdev->disable_source)
+		mdev->disable_source(&vdev->entity);
+#endif /* CONFIG_MEDIA_CONTROLLER */
+}
+EXPORT_SYMBOL_GPL(v4l_disable_media_tuner);
 
 /* Priority handling */
 
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index eeabf20..68999a3 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -87,6 +87,7 @@ struct video_device
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_entity entity;
 	struct media_intf_devnode *intf_devnode;
+	struct media_pipeline pipe;
 #endif
 	/* device ops */
 	const struct v4l2_file_operations *fops;
@@ -176,6 +177,9 @@ void video_unregister_device(struct video_device *vdev);
    latter can also be used for video_device->release(). */
 struct video_device * __must_check video_device_alloc(void);
 
+int v4l_enable_media_tuner(struct video_device *vdev);
+void v4l_disable_media_tuner(struct video_device *vdev);
+
 /* this release function frees the vdev pointer */
 void video_device_release(struct video_device *vdev);
 
-- 
2.1.4

