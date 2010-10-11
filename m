Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0JKPnZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:43:25 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFhPl5020722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:43:25 -0400
Received: from pedra (vpn-225-124.phx2.redhat.com [10.3.225.124])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9BFdDOZ032640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 11:43:24 -0400
Date: Mon, 11 Oct 2010 12:37:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] V4L/DVB: tm6000: fix resource locking
Message-ID: <20101011123719.2c72dc58@pedra>
In-Reply-To: <cover.1286807828.git.mchehab@redhat.com>
References: <cover.1286807828.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 23c85fd..f184585 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -788,25 +788,49 @@ static struct videobuf_queue_ops tm6000_video_qops = {
 	IOCTL handling
    ------------------------------------------------------------------*/
 
-static int res_get(struct tm6000_core *dev, struct tm6000_fh *fh)
+static bool is_res_read(struct tm6000_core *dev, struct tm6000_fh *fh)
 {
+	/* Is the current fh handling it? if so, that's OK */
+	if (dev->resources == fh && dev->is_res_read)
+		return true;
+
+	return false;
+}
+
+static bool is_res_streaming(struct tm6000_core *dev, struct tm6000_fh *fh)
+{
+	/* Is the current fh handling it? if so, that's OK */
+	if (dev->resources == fh)
+		return true;
+
+	return false;
+}
+
+static bool res_get(struct tm6000_core *dev, struct tm6000_fh *fh,
+		   bool is_res_read)
+{
+	/* Is the current fh handling it? if so, that's OK */
+	if (dev->resources == fh && dev->is_res_read == is_res_read)
+		return true;
+
 	/* is it free? */
 	if (dev->resources)
-		return 0;
-	/* it's free, grab it */
-	dev->resources =1;
+		return false;
+
+	/* grab it */
+	dev->resources = fh;
+	dev->is_res_read = is_res_read;
 	dprintk(dev, V4L2_DEBUG_RES_LOCK, "res: get\n");
-	return 1;
-}
-
-static int res_locked(struct tm6000_core *dev)
-{
-	return (dev->resources);
+	return true;
 }
 
 static void res_free(struct tm6000_core *dev, struct tm6000_fh *fh)
 {
-	dev->resources = 0;
+	/* Is the current fh handling it? if so, that's OK */
+	if (dev->resources != fh)
+		return;
+
+	dev->resources = NULL;
 	dprintk(dev, V4L2_DEBUG_RES_LOCK, "res: put\n");
 }
 
@@ -981,7 +1005,7 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	if (i != fh->type)
 		return -EINVAL;
 
-	if (!res_get(dev,fh))
+	if (!res_get(dev, fh, false))
 		return -EBUSY;
 	return (videobuf_streamon(&fh->vb_vidq));
 }
@@ -1310,7 +1334,7 @@ tm6000_read(struct file *file, char __user *data, size_t count, loff_t *pos)
 	struct tm6000_fh        *fh = file->private_data;
 
 	if (fh->type==V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (res_locked(fh->dev))
+		if (!res_get(fh->dev, fh, true))
 			return -EBUSY;
 
 		return videobuf_read_stream(&fh->vb_vidq, data, count, pos, 0,
@@ -1328,7 +1352,10 @@ tm6000_poll(struct file *file, struct poll_table_struct *wait)
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
 
-	if (res_get(fh->dev,fh)) {
+	if (!!is_res_streaming(fh->dev, fh))
+		return POLLERR;
+
+	if (!is_res_read(fh->dev, fh)) {
 		/* streaming capture */
 		if (list_empty(&fh->vb_vidq.stream))
 			return POLLERR;
@@ -1356,6 +1383,7 @@ static int tm6000_release(struct file *file)
 
 	dev->users--;
 
+	res_free(dev, fh);
 	if (!dev->users) {
 		tm6000_uninit_isoc(dev);
 		videobuf_mmap_free(&fh->vb_vidq);
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 5d9dcab..a1c6ca2 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -189,7 +189,9 @@ struct tm6000_core {
 	int				users;
 
 	/* various device info */
-	unsigned int			resources;
+	struct tm6000_fh		*resources;	/* Points to fh that is streaming */
+	bool				is_res_read;
+
 	struct video_device		*vfd;
 	struct tm6000_dmaqueue		vidq;
 	struct v4l2_device		v4l2_dev;
-- 
1.7.1

