Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:17994 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752089AbeEQObJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 10:31:09 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 1/2] v4l2-ioctl: create helper to fill in v4l2_standard for ENUMSTD
Date: Thu, 17 May 2018 16:30:15 +0200
Message-Id: <20180517143016.13501-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare for adding a new IOCTL VIDIOC_SUBDEV_ENUMSTD which would
enumerate the standards for a subdevice by breaking out the code which
could be shared between the video and subdevice versions of this IOCTL.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 66 ++++++++++++++++------------
 include/media/v4l2-ioctl.h           | 11 +++++
 2 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index a40dbec271f1d9fe..1b5893373358ad5e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -125,6 +125,42 @@ int v4l2_video_std_construct(struct v4l2_standard *vs,
 }
 EXPORT_SYMBOL(v4l2_video_std_construct);
 
+/* Fill in the fields of a v4l2_standard structure according to the
+ * 'id' and 'vs->index' parameters. Returns negative on error. */
+int v4l_video_std_enumstd(struct v4l2_standard *vs, v4l2_std_id id)
+{
+	v4l2_std_id curr_id = 0;
+	unsigned int index = vs->index, i, j = 0;
+	const char *descr = "";
+
+	/* Return -ENODATA if the id for the current input
+	   or output is 0, meaning that it doesn't support this API. */
+	if (id == 0)
+		return -ENODATA;
+
+	/* Return norm array in a canonical way */
+	for (i = 0; i <= index && id; i++) {
+		/* last std value in the standards array is 0, so this
+		   while always ends there since (id & 0) == 0. */
+		while ((id & standards[j].std) != standards[j].std)
+			j++;
+		curr_id = standards[j].std;
+		descr = standards[j].descr;
+		j++;
+		if (curr_id == 0)
+			break;
+		if (curr_id != V4L2_STD_PAL &&
+				curr_id != V4L2_STD_SECAM &&
+				curr_id != V4L2_STD_NTSC)
+			id &= ~curr_id;
+	}
+	if (i <= index)
+		return -EINVAL;
+
+	v4l2_video_std_construct(vs, curr_id, descr);
+	return 0;
+}
+
 /* ----------------------------------------------------------------- */
 /* some arrays for pretty-printing debug messages of enum types      */
 
@@ -1753,36 +1789,8 @@ static int v4l_enumstd(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_standard *p = arg;
-	v4l2_std_id id = vfd->tvnorms, curr_id = 0;
-	unsigned int index = p->index, i, j = 0;
-	const char *descr = "";
-
-	/* Return -ENODATA if the tvnorms for the current input
-	   or output is 0, meaning that it doesn't support this API. */
-	if (id == 0)
-		return -ENODATA;
 
-	/* Return norm array in a canonical way */
-	for (i = 0; i <= index && id; i++) {
-		/* last std value in the standards array is 0, so this
-		   while always ends there since (id & 0) == 0. */
-		while ((id & standards[j].std) != standards[j].std)
-			j++;
-		curr_id = standards[j].std;
-		descr = standards[j].descr;
-		j++;
-		if (curr_id == 0)
-			break;
-		if (curr_id != V4L2_STD_PAL &&
-				curr_id != V4L2_STD_SECAM &&
-				curr_id != V4L2_STD_NTSC)
-			id &= ~curr_id;
-	}
-	if (i <= index)
-		return -EINVAL;
-
-	v4l2_video_std_construct(p, curr_id, descr);
-	return 0;
+	return v4l_video_std_enumstd(p, vfd->tvnorms);
 }
 
 static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index a7b3f7c75d628b06..fa0463a1b19dc880 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -642,6 +642,17 @@ void v4l2_video_std_frame_period(int id, struct v4l2_fract *frameperiod);
 int v4l2_video_std_construct(struct v4l2_standard *vs,
 				    int id, const char *name);
 
+/**
+ * v4l_video_std_enumstd - Ancillary routine that fills in the fields of
+ *	a &v4l2_standard structure according to the @id and @vs->index
+ *	parameters.
+ *
+ * @vs: struct &v4l2_standard pointer to be filled.
+ * @id: analog TV sdandard ID.
+ *
+ */
+int v4l_video_std_enumstd(struct v4l2_standard *vs, v4l2_std_id id);
+
 /**
  * v4l_printk_ioctl - Ancillary routine that prints the ioctl in a
  *	human-readable format.
-- 
2.17.0
