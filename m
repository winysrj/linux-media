Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NNeEqK014459
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 19:40:14 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NNe12n005546
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 19:40:01 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2172794wfc.6
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 16:40:00 -0700 (PDT)
Date: Mon, 23 Jun 2008 16:39:52 -0700
From: Brandon Philips <brandon@ifup.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@infradead.org
Message-ID: <20080623233952.GA4569@plankton>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200806221334.45894.hverkuil@xs4all.nl>
	<20080623150734.GF18397@plankton.ifup.org>
	<200806231800.44274.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806231800.44274.hverkuil@xs4all.nl>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
	attribute for?persistent video4linux device nodes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 18:00 Mon 23 Jun 2008, Hans Verkuil wrote:
> On Monday 23 June 2008 17:07:34 Brandon Philips wrote:
> There is also no need to use class_for_each_device(): you can also 
> iterate over the video_device[] array.
> 
> So get_index would look something like this:

Your code compiles, looks correct and is simpler.  It tested OK on my
single node device but I don't have any multiple node devices like a
ivtv.  Testers welcome ;)

Mauro had already committed my patch to his branch so I just made the
change on top of that.

Mauro you can pull this patch from here: http://ifup.org/hg/v4l-dvb

Cheers,

	Brandon

changeset:   8111:e39be24dd6a0
tag:         tip
user:        Brandon Philips <brandon@ifup.org>
date:        Mon Jun 23 16:33:06 2008 -0700
files:       linux/drivers/media/video/videodev.c
description:
videodev: simplify get_index()

Use Hans Verkuil's suggested method of implementing get_index which doesn't
depend on class_for_each_device and instead uses the video_device array.  This
simplifies the code and reduces its memory footprint.

Signed-off-by: Brandon Philips <bphilips@suse.de>

diff --git a/linux/drivers/media/video/videodev.c b/linux/drivers/media/video/videodev.c
--- a/linux/drivers/media/video/videodev.c
+++ b/linux/drivers/media/video/videodev.c
@@ -1989,26 +1989,8 @@ out:
 }
 EXPORT_SYMBOL(video_ioctl2);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)
-struct index_info {
-	struct device *dev;
-	unsigned int used[VIDEO_NUM_DEVICES];
-};
-
-static int __fill_index_info(struct device *cd, void *data)
-{
-	struct index_info *info = data;
-	struct video_device *vfd = container_of(cd, struct video_device,
-						class_dev);
-
-	if (info->dev == vfd->dev)
-		info->used[vfd->index] = 1;
-
-	return 0;
-}
-
 /**
- * assign_index - assign stream number based on parent device
+ * get_index - assign stream number based on parent device
  * @vdev: video_device to assign index number to, vdev->dev should be assigned
  * @num: -1 if auto assign, requested number otherwise
  *
@@ -2018,46 +2000,35 @@ static int __fill_index_info(struct devi
  */
 static int get_index(struct video_device *vdev, int num)
 {
-	struct index_info *info;
+	u32 used = 0;
 	int i;
-	int ret = 0;
 
-	if (num >= VIDEO_NUM_DEVICES)
+	if (num >= 32) {
+		printk(KERN_ERR "videodev: %s num is too large\n", __func__);
 		return -EINVAL;
-
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	info->dev = vdev->dev;
-
-	ret = class_for_each_device(&video_class, info,
-					__fill_index_info);
-
-	if (ret < 0)
-		goto out;
-
-	if (num >= 0) {
-		if (!info->used[num])
-			ret = num;
-		else
-			ret = -ENFILE;
-
-		goto out;
 	}
 
 	for (i = 0; i < VIDEO_NUM_DEVICES; i++) {
-		if (info->used[i])
-			continue;
-		ret = i;
-		goto out;
+		if (video_device[i] != NULL &&
+		    video_device[i] != vdev &&
+		    video_device[i]->dev == vdev->dev) {
+			used |= 1 << video_device[i]->index;
+		}
 	}
 
-out:
-	kfree(info);
-	return ret;
+	if (num >= 0) {
+		if (used & (1 << num))
+			return -ENFILE;
+		return num;
+	}
+
+	for (i = 0; i < 32; i++) {
+		if (used & (1 << i))
+			continue;
+		return i;
+	}
+	return -ENFILE;
 }
-#endif
 
 static const struct file_operations video_fops;
 
@@ -2151,11 +2122,7 @@ int video_register_device_index(struct v
 	video_device[i]=vfd;
 	vfd->minor=i;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)
 	ret = get_index(vfd, index);
-#else
-	ret = 0;
-#endif
 	if (ret < 0) {
 		printk(KERN_ERR "%s: get_index failed\n",
 		       __func__);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
