Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4MLnjZM002831
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 17:49:45 -0400
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4MLnX7O004077
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 17:49:33 -0400
Date: Thu, 22 May 2008 22:37:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Message-ID: <20080522223700.2f103a14@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH] video4linux: Push down the BKL
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

For most drivers the generic ioctl handler does the work and we update it
and it becomes the unlocked_ioctl method. Older drivers use the usercopy
method so we make it do the work. Finally there are a few special cases.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 2ca3e9c..964fc31 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3349,7 +3349,7 @@ static const struct file_operations bttv_fops =
 	.owner	  = THIS_MODULE,
 	.open	  = bttv_open,
 	.release  = bttv_release,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl	  = video_ioctl2,
 	.compat_ioctl	= v4l_compat_ioctl32,
 	.llseek	  = no_llseek,
 	.read	  = bttv_read,
@@ -3630,7 +3630,7 @@ static const struct file_operations radio_fops =
 	.read     = radio_read,
 	.release  = radio_release,
 	.compat_ioctl	= v4l_compat_ioctl32,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl	  = video_ioctl2,
 	.llseek	  = no_llseek,
 	.poll     = radio_poll,
 };
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index b364ada..e953bc9 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -863,10 +863,9 @@ static int qcam_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int qcam_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long qcam_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, qcam_do_ioctl);
+	return video_usercopy(file, cmd, arg, qcam_do_ioctl);
 }
 
 static ssize_t qcam_read(struct file *file, char __user *buf,
@@ -897,7 +896,7 @@ static const struct file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
-	.ioctl          = qcam_ioctl,
+	.unlocked_ioctl = qcam_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
index fe1e67b..7541e2c 100644
--- a/drivers/media/video/c-qcam.c
+++ b/drivers/media/video/c-qcam.c
@@ -499,7 +499,7 @@ static long qc_capture(struct qcam_device *q, char __user *buf, unsigned long le
  */
 
 static int qcam_do_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, void *arg)
+						unsigned int cmd, void *arg)
 {
 	struct video_device *dev = video_devdata(file);
 	struct qcam_device *qcam=(struct qcam_device *)dev;
@@ -664,10 +664,9 @@ static int qcam_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int qcam_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long qcam_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, qcam_do_ioctl);
+	return video_usercopy(file, cmd, arg, qcam_do_ioctl);
 }
 
 static ssize_t qcam_read(struct file *file, char __user *buf,
@@ -691,7 +690,7 @@ static const struct file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
-	.ioctl          = qcam_ioctl,
+	.unlocked_ioctl = qcam_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 5195b1f..8b697e3 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -1764,7 +1764,7 @@ static const struct file_operations cafe_v4l_fops = {
 	.read = cafe_v4l_read,
 	.poll = cafe_v4l_poll,
 	.mmap = cafe_v4l_mmap,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.llseek = no_llseek,
 };
 
diff --git a/drivers/media/video/cpia.c b/drivers/media/video/cpia.c
index 2a81376..93766a1 100644
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -3725,10 +3725,9 @@ static int cpia_do_ioctl(struct inode *inode, struct file *file,
 	return retval;
 }
 
-static int cpia_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long cpia_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, cpia_do_ioctl);
+	return video_usercopy(file, cmd, arg, cpia_do_ioctl);
 }
 
 
@@ -3791,7 +3790,7 @@ static const struct file_operations cpia_fops = {
 	.release       	= cpia_close,
 	.read		= cpia_read,
 	.mmap		= cpia_mmap,
-	.ioctl          = cpia_ioctl,
+	.unlocked_ioctl = cpia_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 7ce2789..bf551f8 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1847,10 +1847,10 @@ static int cpia2_do_ioctl(struct inode *inode, struct file *file,
 	return retval;
 }
 
-static int cpia2_ioctl(struct inode *inode, struct file *file,
-		       unsigned int ioctl_nr, unsigned long iarg)
+static long cpia2_ioctl(struct file *file, unsigned int ioctl_nr,
+							unsigned long iarg)
 {
-	return video_usercopy(inode, file, ioctl_nr, iarg, cpia2_do_ioctl);
+	return video_usercopy(file, ioctl_nr, iarg, cpia2_do_ioctl);
 }
 
 /******************************************************************************
@@ -1925,7 +1925,7 @@ static const struct file_operations fops_template = {
 	.release	= cpia2_close,
 	.read		= cpia2_v4l_read,
 	.poll		= cpia2_v4l_poll,
-	.ioctl		= cpia2_ioctl,
+	.unlocked_ioctl	= cpia2_ioctl,
 	.llseek		= no_llseek,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index dbdcb86..faf3a31 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -837,15 +837,16 @@ static int cx18_v4l2_do_ioctl(struct inode *inode, struct file *filp,
 	return 0;
 }
 
-int cx18_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		    unsigned long arg)
+long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct cx18_open_id *id = (struct cx18_open_id *)filp->private_data;
 	struct cx18 *cx = id->cx;
 	int res;
 
+	lock_kernel();
 	mutex_lock(&cx->serialize_lock);
-	res = video_usercopy(inode, filp, cmd, arg, cx18_v4l2_do_ioctl);
+	res = video_usercopy(filp, cmd, arg, cx18_v4l2_do_ioctl);
 	mutex_unlock(&cx->serialize_lock);
+	unlock_kernel();
 	return res;
 }
diff --git a/drivers/media/video/cx18/cx18-ioctl.h b/drivers/media/video/cx18/cx18-ioctl.h
index 9f4c7eb..32bede3 100644
--- a/drivers/media/video/cx18/cx18-ioctl.h
+++ b/drivers/media/video/cx18/cx18-ioctl.h
@@ -1,4 +1,4 @@
-/*
+ /*
  *  cx18 ioctl system call
  *
  *  Derived from ivtv-ioctl.h
@@ -24,7 +24,6 @@
 u16 cx18_service2vbi(int type);
 void cx18_expand_service_set(struct v4l2_sliced_vbi_format *fmt, int is_pal);
 u16 cx18_get_service_set(struct v4l2_sliced_vbi_format *fmt);
-int cx18_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		    unsigned long arg);
+long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 int cx18_v4l2_ioctls(struct cx18 *cx, struct file *filp, unsigned cmd,
 		     void *arg);
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index afb141b..7348b82 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -39,7 +39,7 @@ static struct file_operations cx18_v4l2_enc_fops = {
       .owner = THIS_MODULE,
       .read = cx18_v4l2_read,
       .open = cx18_v4l2_open,
-      .ioctl = cx18_v4l2_ioctl,
+      .unlocked_ioctl = cx18_v4l2_ioctl,
       .release = cx18_v4l2_close,
       .poll = cx18_v4l2_enc_poll,
 };
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index acdd3b6..8530c60 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1542,10 +1542,9 @@ static int mpeg_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int mpeg_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static int mpeg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, mpeg_do_ioctl);
+	return video_usercopy(file, cmd, arg, mpeg_do_ioctl);
 }
 
 static int mpeg_open(struct inode *inode, struct file *file)
@@ -1670,7 +1669,7 @@ static struct file_operations mpeg_fops = {
 	.read	       = mpeg_read,
 	.poll          = mpeg_poll,
 	.mmap	       = mpeg_mmap,
-	.ioctl	       = mpeg_ioctl,
+	.unlocked_ioctl= mpeg_ioctl,
 	.llseek        = no_llseek,
 };
 
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 8465221..c4059fa 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1428,7 +1428,7 @@ static const struct file_operations video_fops = {
 	.read	       = video_read,
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl	       = video_ioctl2,
 	.compat_ioctl  = v4l_compat_ioctl32,
 	.llseek        = no_llseek,
 };
@@ -1479,7 +1479,7 @@ static const struct file_operations radio_fops = {
 	.owner         = THIS_MODULE,
 	.open          = video_open,
 	.release       = video_release,
-	.ioctl         = video_ioctl2,
+	.unlocked_ioctl         = video_ioctl2,
 	.compat_ioctl  = v4l_compat_ioctl32,
 	.llseek        = no_llseek,
 };
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 6c0c94c..9b5f761 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1169,7 +1169,7 @@ static const struct file_operations mpeg_fops =
 	.read	       = mpeg_read,
 	.poll          = mpeg_poll,
 	.mmap	       = mpeg_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl= video_ioctl2,
 	.llseek        = no_llseek,
 };
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index eea23f9..ee1d29b 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1677,7 +1677,7 @@ static const struct file_operations video_fops =
 	.read	       = video_read,
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.compat_ioctl  = v4l_compat_ioctl32,
 	.llseek        = no_llseek,
 };
@@ -1730,7 +1730,7 @@ static const struct file_operations radio_fops =
 	.owner         = THIS_MODULE,
 	.open          = video_open,
 	.release       = video_release,
-	.ioctl         = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.compat_ioctl  = v4l_compat_ioctl32,
 	.llseek        = no_llseek,
 };
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 8d1f8ee..ae26ade 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -636,7 +636,8 @@ static int dabusb_release (struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long dabusb_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	pdabusb_t s = (pdabusb_t) file->private_data;
 	pbulk_transfer_t pbulk;
@@ -700,7 +701,7 @@ static const struct file_operations dabusb_fops =
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.read =		dabusb_read,
-	.ioctl =	dabusb_ioctl,
+	.unlocked_ioctl = dabusb_ioctl,
 	.open =		dabusb_open,
 	.release =	dabusb_release,
 };
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 8996175..f1e08b2 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1756,7 +1756,7 @@ static const struct file_operations em28xx_v4l_fops = {
 	.read          = em28xx_v4l2_read,
 	.poll          = em28xx_v4l2_poll,
 	.mmap          = em28xx_v4l2_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl= video_ioctl2,
 	.llseek        = no_llseek,
 	.compat_ioctl  = v4l_compat_ioctl32,
 };
@@ -1765,7 +1765,7 @@ static const struct file_operations radio_fops = {
 	.owner         = THIS_MODULE,
 	.open          = em28xx_v4l2_open,
 	.release       = em28xx_v4l2_close,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl= video_ioctl2,
 	.compat_ioctl  = v4l_compat_ioctl32,
 	.llseek        = no_llseek,
 };
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index 5e749c5..9f13cca 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -2391,8 +2391,8 @@ et61x251_vidioc_s_parm(struct et61x251_device* cam, void __user * arg)
 }
 
 
-static int et61x251_ioctl_v4l2(struct inode* inode, struct file* filp,
-			       unsigned int cmd, void __user * arg)
+static int et61x251_ioctl_v4l2(struct file* filp, unsigned int cmd,
+							void __user * arg)
 {
 	struct et61x251_device* cam = video_get_drvdata(video_devdata(filp));
 
@@ -2486,8 +2486,8 @@ static int et61x251_ioctl_v4l2(struct inode* inode, struct file* filp,
 }
 
 
-static int et61x251_ioctl(struct inode* inode, struct file* filp,
-			 unsigned int cmd, unsigned long arg)
+static long et61x251_ioctl(struct file* filp, unsigned int cmd,
+							unsigned long arg)
 {
 	struct et61x251_device* cam = video_get_drvdata(video_devdata(filp));
 	int err = 0;
@@ -2510,7 +2510,9 @@ static int et61x251_ioctl(struct inode* inode, struct file* filp,
 
 	V4LDBG(3, "et61x251", cmd);
 
-	err = et61x251_ioctl_v4l2(inode, filp, cmd, (void __user *)arg);
+	lock_kernel();
+	err = et61x251_ioctl_v4l2(filp, cmd, (void __user *)arg);
+	unlock_kernel();
 
 	mutex_unlock(&cam->fileop_mutex);
 
@@ -2522,7 +2524,7 @@ static const struct file_operations et61x251_fops = {
 	.owner = THIS_MODULE,
 	.open =    et61x251_open,
 	.release = et61x251_release,
-	.ioctl =   et61x251_ioctl,
+	.unlocked_ioctl =   et61x251_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index d508b5d..a481b2d 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1726,7 +1726,7 @@ static int ivtv_v4l2_do_ioctl(struct inode *inode, struct file *filp,
 	return 0;
 }
 
-static int ivtv_serialized_ioctl(struct ivtv *itv, struct inode *inode, struct file *filp,
+static int ivtv_serialized_ioctl(struct ivtv *itv, struct file *filp,
 		unsigned int cmd, unsigned long arg)
 {
 	/* Filter dvb ioctls that cannot be handled by video_usercopy */
@@ -1761,18 +1761,19 @@ static int ivtv_serialized_ioctl(struct ivtv *itv, struct inode *inode, struct f
 	default:
 		break;
 	}
-	return video_usercopy(inode, filp, cmd, arg, ivtv_v4l2_do_ioctl);
+	return video_usercopy(filp, cmd, arg, ivtv_v4l2_do_ioctl);
 }
 
-int ivtv_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		    unsigned long arg)
+long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct ivtv_open_id *id = (struct ivtv_open_id *)filp->private_data;
 	struct ivtv *itv = id->itv;
 	int res;
 
+	lock_kernel();
 	mutex_lock(&itv->serialize_lock);
-	res = ivtv_serialized_ioctl(itv, inode, filp, cmd, arg);
+	res = ivtv_serialized_ioctl(itv, filp, cmd, arg);
 	mutex_unlock(&itv->serialize_lock);
+	unlock_kernel();
 	return res;
 }
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.h b/drivers/media/video/ivtv/ivtv-ioctl.h
index a03351b..6708ea0 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.h
+++ b/drivers/media/video/ivtv/ivtv-ioctl.h
@@ -24,8 +24,7 @@
 u16 service2vbi(int type);
 void expand_service_set(struct v4l2_sliced_vbi_format *fmt, int is_pal);
 u16 get_service_set(struct v4l2_sliced_vbi_format *fmt);
-int ivtv_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		    unsigned long arg);
+long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 int ivtv_v4l2_ioctls(struct ivtv *itv, struct file *filp, unsigned int cmd, void *arg);
 void ivtv_set_osd_alpha(struct ivtv *itv);
 int ivtv_set_speed(struct ivtv *itv, int speed);
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index 4ab8d36..3131f68 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -48,7 +48,7 @@ static const struct file_operations ivtv_v4l2_enc_fops = {
       .read = ivtv_v4l2_read,
       .write = ivtv_v4l2_write,
       .open = ivtv_v4l2_open,
-      .ioctl = ivtv_v4l2_ioctl,
+      .unlocked_ioctl = ivtv_v4l2_ioctl,
       .release = ivtv_v4l2_close,
       .poll = ivtv_v4l2_enc_poll,
 };
@@ -58,7 +58,7 @@ static const struct file_operations ivtv_v4l2_dec_fops = {
       .read = ivtv_v4l2_read,
       .write = ivtv_v4l2_write,
       .open = ivtv_v4l2_open,
-      .ioctl = ivtv_v4l2_ioctl,
+      .unlocked_ioctl = ivtv_v4l2_ioctl,
       .release = ivtv_v4l2_close,
       .poll = ivtv_v4l2_dec_poll,
 };
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index e7ccbc8..a92c0ba 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1687,7 +1687,7 @@ static const struct file_operations meye_fops = {
 	.open		= meye_open,
 	.release	= meye_release,
 	.mmap		= meye_mmap,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index eafb0c7..3e3f70b 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -4440,9 +4440,8 @@ redo:
 	return 0;
 }
 
-static int
-ov51x_v4l1_ioctl(struct inode *inode, struct file *file,
-		 unsigned int cmd, unsigned long arg)
+static long
+ov51x_v4l1_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vdev = file->private_data;
 	struct usb_ov511 *ov = video_get_drvdata(vdev);
@@ -4451,7 +4450,7 @@ ov51x_v4l1_ioctl(struct inode *inode, struct file *file,
 	if (mutex_lock_interruptible(&ov->lock))
 		return -EINTR;
 
-	rc = video_usercopy(inode, file, cmd, arg, ov51x_v4l1_ioctl_internal);
+	rc = video_usercopy(file, cmd, arg, ov51x_v4l1_ioctl_internal);
 
 	mutex_unlock(&ov->lock);
 	return rc;
@@ -4653,16 +4652,16 @@ ov51x_v4l1_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static const struct file_operations ov511_fops = {
-	.owner =	THIS_MODULE,
-	.open =		ov51x_v4l1_open,
-	.release =	ov51x_v4l1_close,
-	.read =		ov51x_v4l1_read,
-	.mmap =		ov51x_v4l1_mmap,
-	.ioctl =	ov51x_v4l1_ioctl,
+	.owner =		THIS_MODULE,
+	.open =			ov51x_v4l1_open,
+	.release =		ov51x_v4l1_close,
+	.read =			ov51x_v4l1_read,
+	.mmap =			ov51x_v4l1_mmap,
+	.unlocked_ioctl =	ov51x_v4l1_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl = v4l_compat_ioctl32,
+	.compat_ioctl = 	v4l_compat_ioctl32,
 #endif
-	.llseek =	no_llseek,
+	.llseek =		no_llseek,
 };
 
 static struct video_device vdev_template = {
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 51b1461..4cfe7aa 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -861,10 +861,9 @@ static int pms_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int pms_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long pms_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, pms_do_ioctl);
+	return video_usercopy(file, cmd, arg, pms_do_ioctl);
 }
 
 static ssize_t pms_read(struct file *file, char __user *buf,
@@ -884,7 +883,7 @@ static const struct file_operations pms_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
-	.ioctl          = pms_ioctl,
+	.unlocked_ioctl = pms_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index e9b5d4e..5deb006 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -862,7 +862,7 @@ static void pvr2_v4l2_internal_check(struct pvr2_channel *chp)
 }
 
 
-static int pvr2_v4l2_ioctl(struct inode *inode, struct file *file,
+static long pvr2_v4l2_ioctl(struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
 
@@ -870,7 +870,7 @@ static int pvr2_v4l2_ioctl(struct inode *inode, struct file *file,
 #define IVTV_IOC_G_CODEC        0xFFEE7703
 #define IVTV_IOC_S_CODEC        0xFFEE7704
 	if (cmd == IVTV_IOC_G_CODEC || cmd == IVTV_IOC_S_CODEC) return 0;
-	return video_usercopy(inode, file, cmd, arg, pvr2_v4l2_do_ioctl);
+	return video_usercopy(file, cmd, arg, pvr2_v4l2_do_ioctl);
 }
 
 
@@ -1154,7 +1154,7 @@ static const struct file_operations vdev_fops = {
 	.open       = pvr2_v4l2_open,
 	.release    = pvr2_v4l2_release,
 	.read       = pvr2_v4l2_read,
-	.ioctl      = pvr2_v4l2_ioctl,
+	.unlocked_ioctl = pvr2_v4l2_ioctl,
 	.llseek     = no_llseek,
 	.poll       = pvr2_v4l2_poll,
 };
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 423fa7c..d907966 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -147,8 +147,8 @@ static int pwc_video_close(struct inode *inode, struct file *file);
 static ssize_t pwc_video_read(struct file *file, char __user *buf,
 			  size_t count, loff_t *ppos);
 static unsigned int pwc_video_poll(struct file *file, poll_table *wait);
-static int  pwc_video_ioctl(struct inode *inode, struct file *file,
-			    unsigned int ioctlnr, unsigned long arg);
+static long pwc_video_ioctl(struct file *file, unsigned int ioctlnr,
+							unsigned long arg);
 static int  pwc_video_mmap(struct file *file, struct vm_area_struct *vma);
 
 static const struct file_operations pwc_fops = {
@@ -158,7 +158,7 @@ static const struct file_operations pwc_fops = {
 	.read =		pwc_video_read,
 	.poll =		pwc_video_poll,
 	.mmap =		pwc_video_mmap,
-	.ioctl =        pwc_video_ioctl,
+	.unlocked_ioctl = pwc_video_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
@@ -1400,8 +1400,8 @@ static unsigned int pwc_video_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static int pwc_video_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long pwc_video_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	struct video_device *vdev = file->private_data;
 	struct pwc_device *pdev;
@@ -1413,7 +1413,7 @@ static int pwc_video_ioctl(struct inode *inode, struct file *file,
 
 	mutex_lock(&pdev->modlock);
 	if (!pdev->unplugged)
-		r = video_usercopy(inode, file, cmd, arg, pwc_video_do_ioctl);
+		r = video_usercopy(file, cmd, arg, pwc_video_do_ioctl);
 	mutex_unlock(&pdev->modlock);
 out:
 	return r;
diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index 996b494..9691ac1 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -715,8 +715,8 @@ static inline unsigned int vtx_fix_command(unsigned int cmd)
 /*
  *	Handle the locking
  */
-static int saa5246a_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static int saa5246a_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct video_device *vd = video_devdata(file);
 	struct saa5246a_device *t = vd->priv;
@@ -724,7 +724,7 @@ static int saa5246a_ioctl(struct inode *inode, struct file *file,
 
 	cmd = vtx_fix_command(cmd);
 	mutex_lock(&t->lock);
-	err = video_usercopy(inode, file, cmd, arg, do_saa5246a_ioctl);
+	err = video_usercopy(file, cmd, arg, do_saa5246a_ioctl);
 	mutex_unlock(&t->lock);
 	return err;
 }
@@ -822,7 +822,7 @@ static const struct file_operations saa_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = saa5246a_open,
 	.release = saa5246a_release,
-	.ioctl	 = saa5246a_ioctl,
+	.unlocked_ioctl = saa5246a_ioctl,
 	.llseek	 = no_llseek,
 };
 
diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index ec8c65d..159f7f0 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -611,8 +611,8 @@ static inline unsigned int vtx_fix_command(unsigned int cmd)
  *	Handle the locking
  */
 
-static int saa5249_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long saa5249_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	struct video_device *vd = video_devdata(file);
 	struct saa5249_device *t=vd->priv;
@@ -620,7 +620,7 @@ static int saa5249_ioctl(struct inode *inode, struct file *file,
 
 	cmd = vtx_fix_command(cmd);
 	mutex_lock(&t->lock);
-	err = video_usercopy(inode,file,cmd,arg,do_saa5249_ioctl);
+	err = video_usercopy(file,cmd,arg,do_saa5249_ioctl);
 	mutex_unlock(&t->lock);
 	return err;
 }
@@ -700,7 +700,7 @@ static const struct file_operations saa_fops = {
 	.owner		= THIS_MODULE,
 	.open		= saa5249_open,
 	.release       	= saa5249_release,
-	.ioctl          = saa5249_ioctl,
+	.unlocked_ioctl = saa5249_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 1314522..a768f70 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -339,7 +339,7 @@ static const struct file_operations ts_fops =
 	.read	  = ts_read,
 	.poll	  = ts_poll,
 	.mmap	  = ts_mmap,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl	  = video_ioctl2,
 	.llseek   = no_llseek,
 };
 
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 48e1a01..abdd5c3 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -2322,7 +2322,7 @@ static const struct file_operations video_fops =
 	.read	  = video_read,
 	.poll     = video_poll,
 	.mmap	  = video_mmap,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.compat_ioctl	= v4l_compat_ioctl32,
 	.llseek   = no_llseek,
 };
@@ -2332,7 +2332,7 @@ static const struct file_operations radio_fops =
 	.owner	  = THIS_MODULE,
 	.open	  = video_open,
 	.release  = video_release,
-	.ioctl	  = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.compat_ioctl	= v4l_compat_ioctl32,
 	.llseek   = no_llseek,
 };
diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index 1cd6293..f02fdc0 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -1133,10 +1133,10 @@ static int se401_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int se401_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg)
+static long se401_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, se401_do_ioctl);
+	return video_usercopy(file, cmd, arg, se401_do_ioctl);
 }
 
 static ssize_t se401_read(struct file *file, char __user *buf,
@@ -1223,7 +1223,7 @@ static const struct file_operations se401_fops = {
 	.release =      se401_close,
 	.read =         se401_read,
 	.mmap =         se401_mmap,
-	.ioctl =        se401_ioctl,
+	.unlocked_ioctl = se401_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 5748b1e..fa6eaef 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -3082,8 +3082,8 @@ sn9c102_vidioc_s_audio(struct sn9c102_device* cam, void __user * arg)
 }
 
 
-static int sn9c102_ioctl_v4l2(struct inode* inode, struct file* filp,
-			      unsigned int cmd, void __user * arg)
+static long sn9c102_ioctl_v4l2(struct file* filp, unsigned int cmd,
+							void __user * arg)
 {
 	struct sn9c102_device* cam = video_get_drvdata(video_devdata(filp));
 
@@ -3186,8 +3186,8 @@ static int sn9c102_ioctl_v4l2(struct inode* inode, struct file* filp,
 }
 
 
-static int sn9c102_ioctl(struct inode* inode, struct file* filp,
-			 unsigned int cmd, unsigned long arg)
+static long sn9c102_ioctl(struct file* filp, unsigned int cmd,
+							unsigned long arg)
 {
 	struct sn9c102_device* cam = video_get_drvdata(video_devdata(filp));
 	int err = 0;
@@ -3210,8 +3210,9 @@ static int sn9c102_ioctl(struct inode* inode, struct file* filp,
 
 	V4LDBG(3, "sn9c102", cmd);
 
-	err = sn9c102_ioctl_v4l2(inode, filp, cmd, (void __user *)arg);
-
+	lock_kernel();
+	err = sn9c102_ioctl_v4l2(filp, cmd, (void __user *)arg);
+	unlock_kernel();
 	mutex_unlock(&cam->fileop_mutex);
 
 	return err;
@@ -3223,7 +3224,7 @@ static const struct file_operations sn9c102_fops = {
 	.owner = THIS_MODULE,
 	.open = sn9c102_open,
 	.release = sn9c102_release,
-	.ioctl = sn9c102_ioctl,
+	.unlocked_ioctl = sn9c102_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a1b9244..2f6ede2 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -334,7 +334,7 @@ static struct file_operations soc_camera_fops = {
 	.owner		= THIS_MODULE,
 	.open		= soc_camera_open,
 	.release	= soc_camera_close,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read		= soc_camera_read,
 	.mmap		= soc_camera_mmap,
 	.poll		= soc_camera_poll,
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 9276ed9..bd32c58 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1313,7 +1313,7 @@ static struct file_operations v4l_stk_fops = {
 	.read = v4l_stk_read,
 	.poll = v4l_stk_poll,
 	.mmap = v4l_stk_mmap,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/stradis.c b/drivers/media/video/stradis.c
index c109511..3ad0f39 100644
--- a/drivers/media/video/stradis.c
+++ b/drivers/media/video/stradis.c
@@ -1274,11 +1274,11 @@ static void make_clip_tab(struct saa7146 *saa, struct video_clip *cr, int ncr)
 		clip_draw_rectangle(clipmap, 0, 0, 1024, -saa->win.y);
 }
 
-static int saa_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long argl)
+static long saa_ioctl(struct file *file, unsigned int cmd, unsigned long argl)
 {
 	struct saa7146 *saa = file->private_data;
 	void __user *arg = (void __user *)argl;
+	long ret;
 
 	switch (cmd) {
 	case VIDIOCGCAP:
@@ -1301,6 +1301,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 	case VIDIOCGPICT:
 		{
 			struct video_picture p = saa->picture;
+			lock_kernel();
 			if (saa->win.depth == 8)
 				p.palette = VIDEO_PALETTE_HI240;
 			if (saa->win.depth == 15)
@@ -1311,6 +1312,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 				p.palette = VIDEO_PALETTE_RGB24;
 			if (saa->win.depth == 32)
 				p.palette = VIDEO_PALETTE_RGB32;
+			unlock_kernel();
 			if (copy_to_user(arg, &p, sizeof(p)))
 				return -EFAULT;
 			return 0;
@@ -1321,6 +1323,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 			u32 format;
 			if (copy_from_user(&p, arg, sizeof(p)))
 				return -EFAULT;
+			lock_kernel();
 			if (p.palette < ARRAY_SIZE(palette2fmt)) {
 				format = palette2fmt[p.palette];
 				saa->win.color_fmt = format;
@@ -1336,6 +1339,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 				SAA7146_MC2_UPLD_HPS_V) << 16) |
 				SAA7146_MC2_UPLD_HPS_H |
 				SAA7146_MC2_UPLD_HPS_V, SAA7146_MC2);
+			unlock_kernel();
 			return 0;
 		}
 	case VIDIOCSWIN:
@@ -1359,6 +1363,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 				i = vw.x - i;
 				vw.width -= i;
 			}
+			lock_kernel();
 			saa->win.x = vw.x;
 			saa->win.y = vw.y;
 			saa->win.width = vw.width;
@@ -1376,6 +1381,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 			/* stop capture */
 			saawrite((SAA7146_MC1_TR_E_1 << 16), SAA7146_MC1);
 			saa7146_set_winsize(saa);
+			unlock_kernel();
 
 			/*
 			 *    Do any clips.
@@ -1400,6 +1406,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 			} else	/* nothing clipped */
 				memset(saa->dmavid2, 0, VIDEO_CLIPMAP_SIZE);
 
+			lock_kernel();
 			make_clip_tab(saa, vcp, vw.clipcount);
 			if (vw.clipcount > 0)
 				vfree(vcp);
@@ -1409,15 +1416,18 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 				saawrite(((SAA7146_MC1_TR_E_1 |
 					SAA7146_MC1_TR_E_2) << 16) | 0xffff,
 					SAA7146_MC1);
+			unlock_kernel();
 			return 0;
 		}
 	case VIDIOCGWIN:
 		{
 			struct video_window vw;
+			lock_kernel();
 			vw.x = saa->win.x;
 			vw.y = saa->win.y;
 			vw.width = saa->win.width;
 			vw.height = saa->win.height;
+			unlock_kernel();
 			vw.chromakey = 0;
 			vw.flags = 0;
 			if (copy_to_user(arg, &vw, sizeof(vw)))
@@ -1430,27 +1440,35 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 			if (copy_from_user(&v, arg, sizeof(v)))
 				return -EFAULT;
 			if (v == 0) {
+				lock_kernel();
 				saa->cap &= ~1;
 				saawrite((SAA7146_MC1_TR_E_1 << 16),
 					SAA7146_MC1);
+				unlock_kernel();
 			} else {
+				lock_kernel();
 				if (saa->win.vidadr == 0 || saa->win.width == 0
-						|| saa->win.height == 0)
+						|| saa->win.height == 0) {
+					unlock_kernel();
 					return -EINVAL;
+				}
 				saa->cap |= 1;
 				saawrite((SAA7146_MC1_TR_E_1 << 16) | 0xffff,
 					SAA7146_MC1);
+				unlock_kernel();
 			}
 			return 0;
 		}
 	case VIDIOCGFBUF:
 		{
 			struct video_buffer v;
+			lock_kernel();
 			v.base = (void *)saa->win.vidadr;
 			v.height = saa->win.sheight;
 			v.width = saa->win.swidth;
 			v.depth = saa->win.depth;
 			v.bytesperline = saa->win.bpl;
+			unlock_kernel();
 			if (copy_to_user(arg, &v, sizeof(v)))
 				return -EFAULT;
 			return 0;
@@ -1467,6 +1485,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 			    v.depth != 24 && v.depth != 32 && v.width > 16 &&
 			    v.height > 16 && v.bytesperline > 16)
 				return -EINVAL;
+			lock_kernel();
 			if (v.base)
 				saa->win.vidadr = (unsigned long)v.base;
 			saa->win.sheight = v.height;
@@ -1479,6 +1498,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 					"bpl %d\n", v.base, v.width, v.height,
 					saa->win.bpp, saa->win.bpl));
 			saa7146_set_winsize(saa);
+			unlock_kernel();
 			return 0;
 		}
 	case VIDIOCKEY:
@@ -1490,7 +1510,9 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 	case VIDIOCGAUDIO:
 		{
 			struct video_audio v;
+			lock_kernel();
 			v = saa->audio_dev;
+			unlock_kernel();
 			v.flags &= ~(VIDEO_AUDIO_MUTE | VIDEO_AUDIO_MUTABLE);
 			v.flags |= VIDEO_AUDIO_MUTABLE | VIDEO_AUDIO_VOLUME;
 			strcpy(v.name, "MPEG");
@@ -1505,6 +1527,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 			int i;
 			if (copy_from_user(&v, arg, sizeof(v)))
 				return -EFAULT;
+			lock_kernel();
 			i = (~(v.volume >> 8)) & 0xff;
 			if (!HaveCS4341) {
 				if (v.flags & VIDEO_AUDIO_MUTE)
@@ -1526,13 +1549,16 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 					cs4341_setlevel(saa, i, i);
 			}
 			saa->audio_dev = v;
+			unlock_kernel();
 			return 0;
 		}
 
 	case VIDIOCGUNIT:
 		{
 			struct video_unit vu;
+			lock_kernel();
 			vu.video = saa->video_dev.minor;
+			unlock_kernel();
 			vu.vbi = VIDEO_NO_UNIT;
 			vu.radio = VIDEO_NO_UNIT;
 			vu.audio = VIDEO_NO_UNIT;
@@ -1552,15 +1578,20 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 				if (pmode.p1 != VIDEO_MODE_NTSC &&
 						pmode.p1 != VIDEO_MODE_PAL)
 					return -EINVAL;
+				lock_kernel();
 				set_out_format(saa, pmode.p1);
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_GENLOCK:
+				lock_kernel();
 				debiwrite(saa, debNormal, XILINX_CTL0,
 					pmode.p1 ? 0x8000 : 0x8080, 2);
 				if (NewCard)
 					set_genlock_offset(saa, pmode.p2);
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_NORMAL:
+				lock_kernel();
 				debiwrite(saa, debNormal,
 					IBM_MP2_CHIP_CONTROL, ChipControl, 2);
 				ibm_send_command(saa, IBM_MP2_PLAY, 0, 0);
@@ -1570,6 +1601,7 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 				/* IBM removed the PAUSE command */
 				/* they say use SINGLE_FRAME now */
 			case VID_PLAY_SINGLE_FRAME:
+				lock_kernel();
 				ibm_send_command(saa, IBM_MP2_SINGLE_FRAME,0,0);
 				if (saa->playmode == pmode.mode) {
 					debiwrite(saa, debNormal,
@@ -1577,25 +1609,33 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 						ChipControl, 2);
 				}
 				saa->playmode = pmode.mode;
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_FAST_FORWARD:
+				lock_kernel();
 				ibm_send_command(saa, IBM_MP2_FAST_FORWARD,0,0);
 				saa->playmode = pmode.mode;
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_SLOW_MOTION:
+				lock_kernel();
 				ibm_send_command(saa, IBM_MP2_SLOW_MOTION,
 					pmode.p1, 0);
 				saa->playmode = pmode.mode;
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_IMMEDIATE_NORMAL:
+				lock_kernel();
 				/* ensure transfers resume */
 				debiwrite(saa, debNormal,
 					IBM_MP2_CHIP_CONTROL, ChipControl, 2);
 				ibm_send_command(saa, IBM_MP2_IMED_NORM_PLAY,
 					0, 0);
 				saa->playmode = VID_PLAY_NORMAL;
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_SWITCH_CHANNELS:
+				lock_kernel();
 				saa->audhead = saa->audtail = 0;
 				saa->vidhead = saa->vidtail = 0;
 				ibm_send_command(saa, IBM_MP2_FREEZE_FRAME,0,1);
@@ -1609,29 +1649,39 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 					ChipControl, 2);
 				ibm_send_command(saa, IBM_MP2_PLAY, 0, 0);
 				saa->playmode = VID_PLAY_NORMAL;
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_FREEZE_FRAME:
+				lock_kernel();
 				ibm_send_command(saa, IBM_MP2_FREEZE_FRAME,0,0);
 				saa->playmode = pmode.mode;
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_STILL_MODE:
+				lock_kernel();
 				ibm_send_command(saa, IBM_MP2_SET_STILL_MODE,
 					0, 0);
 				saa->playmode = pmode.mode;
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_MASTER_MODE:
+				lock_kernel();
 				if (pmode.p1 == VID_PLAY_MASTER_NONE)
 					saa->boardcfg[1] = 0x13;
 				else if (pmode.p1 == VID_PLAY_MASTER_VIDEO)
 					saa->boardcfg[1] = 0x23;
 				else if (pmode.p1 == VID_PLAY_MASTER_AUDIO)
 					saa->boardcfg[1] = 0x43;
-				else
+				else {
+					unlock_kernel();
 					return -EINVAL;
+				}
 				debiwrite(saa, debNormal,
 					  IBM_MP2_CHIP_CONTROL, ChipControl, 2);
+				unlock_kernel();
 				return 0;
 			case VID_PLAY_ACTIVE_SCANLINES:
+				lock_kernel();
 				if (CurrentMode == VIDEO_MODE_PAL) {
 					if (pmode.p1 < 1 || pmode.p2 > 625)
 						return -EINVAL;
@@ -1646,23 +1696,35 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 						(pmode.p2 / 2) - 4) & 0xff;
 				}
 				set_out_format(saa, CurrentMode);
+					unlock_kernel();
 			case VID_PLAY_RESET:
-				return do_ibm_reset(saa);
+				lock_kernel();
+				ret = do_ibm_reset(saa);
+				unlock_kernel();
+				return ret;
+				
 			case VID_PLAY_END_MARK:
+				lock_kernel();
+				ret = 0;
 				if (saa->endmarktail < saa->endmarkhead) {
 					if (saa->endmarkhead -
 							saa->endmarktail < 2)
-						return -ENOSPC;
+						ret = -ENOSPC;
 				} else if (saa->endmarkhead <=saa->endmarktail){
 					if (saa->endmarktail - saa->endmarkhead
 							> (MAX_MARKS - 2))
-						return -ENOSPC;
+						ret = -ENOSPC;
 				} else
-					return -ENOSPC;
-				saa->endmark[saa->endmarktail] = saa->audtail;
-				saa->endmarktail++;
-				if (saa->endmarktail >= MAX_MARKS)
-					saa->endmarktail = 0;
+					ret = -ENOSPC;
+				if (ret == 0) {
+					saa->endmark[saa->endmarktail] =
+								saa->audtail;
+					saa->endmarktail++;
+					if (saa->endmarktail >= MAX_MARKS)
+						saa->endmarktail = 0;
+				}
+				unlock_kernel();
+				return ret;
 			}
 			return -EINVAL;
 		}
@@ -1676,7 +1738,9 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 					mode == VID_WRITE_CC ||
 					mode == VID_WRITE_TTX ||
 					mode == VID_WRITE_OSD) {
+				lock_kernel();
 				saa->writemode = mode;
+				unlock_kernel();
 				return 0;
 			}
 			return -EINVAL;
@@ -1686,6 +1750,8 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 			struct video_code ucode;
 			__u8 *udata;
 			int i;
+			if (!capable(CAP_SYS_RAWIO))
+				return -EPERM;
 			if (copy_from_user(&ucode, arg, sizeof(ucode)))
 				return -EFAULT;
 			if (ucode.datasize > 65536 || ucode.datasize < 1024 ||
@@ -1698,11 +1764,13 @@ static int saa_ioctl(struct inode *inode, struct file *file,
 				return -EFAULT;
 			}
 			ucode.data = udata;
+			lock_kernel();
 			if (!strncmp(ucode.loadwhat, "decoder.aud", 11) ||
 				!strncmp(ucode.loadwhat, "decoder.vid", 11))
 				i = initialize_ibmmpeg2(&ucode);
 			else
 				i = initialize_fpga(&ucode);
+			unlock_kernel();
 			vfree(udata);
 			if (i)
 				return -EINVAL;
@@ -1905,7 +1973,7 @@ static const struct file_operations saa_fops = {
 	.owner = THIS_MODULE,
 	.open = saa_open,
 	.release = saa_release,
-	.ioctl = saa_ioctl,
+	.unlocked_ioctl = saa_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/stv680.c b/drivers/media/video/stv680.c
index d7f130b..2d38d76 100644
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -1295,10 +1295,10 @@ static int stv680_do_ioctl (struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int stv680_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long stv680_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, stv680_do_ioctl);
+	return video_usercopy(file, cmd, arg, stv680_do_ioctl);
 }
 
 static int stv680_mmap (struct file *file, struct vm_area_struct *vma)
@@ -1393,7 +1393,7 @@ static const struct file_operations stv680_fops = {
 	.release =     	stv_close,
 	.read =		stv680_read,
 	.mmap =		stv680_mmap,
-	.ioctl =        stv680_ioctl,
+	.unlocked_ioctl =        stv680_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index 4128ee2..b48a8fb 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -41,8 +41,8 @@ module_param(video_nr, int, 0);
 static void usbvideo_Disconnect(struct usb_interface *intf);
 static void usbvideo_CameraRelease(struct uvd *uvd);
 
-static int usbvideo_v4l_ioctl(struct inode *inode, struct file *file,
-			      unsigned int cmd, unsigned long arg);
+static long usbvideo_v4l_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg);
 static int usbvideo_v4l_mmap(struct file *file, struct vm_area_struct *vma);
 static int usbvideo_v4l_open(struct inode *inode, struct file *file);
 static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
@@ -945,7 +945,7 @@ static const struct file_operations usbvideo_fops = {
 	.release =usbvideo_v4l_close,
 	.read =   usbvideo_v4l_read,
 	.mmap =   usbvideo_v4l_mmap,
-	.ioctl =  usbvideo_v4l_ioctl,
+	.unlocked_ioctl =  usbvideo_v4l_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
@@ -1477,10 +1477,10 @@ static int usbvideo_v4l_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int usbvideo_v4l_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg)
+static long usbvideo_v4l_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, usbvideo_v4l_do_ioctl);
+	return video_usercopy(file, cmd, arg, usbvideo_v4l_do_ioctl);
 }
 
 /*
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 17f542d..e7cd160 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -504,8 +504,8 @@ set_camera_power(struct vicam_camera *cam, int state)
 	return 0;
 }
 
-static int
-vicam_ioctl(struct inode *inode, struct file *file, unsigned int ioctlnr, unsigned long arg)
+static long
+vicam_ioctl(struct file *file, unsigned int ioctlnr, unsigned long arg)
 {
 	void __user *user_arg = (void __user *)arg;
 	struct vicam_camera *cam = file->private_data;
@@ -600,10 +600,11 @@ vicam_ioctl(struct inode *inode, struct file *file, unsigned int ioctlnr, unsign
 				break;
 			}
 
+			lock_kernel();
 			DBG("VIDIOCSPICT depth = %d, pal = %d\n", vp.depth,
 			    vp.palette);
-
 			cam->gain = vp.brightness >> 8;
+			unlock_kernel();
 
 			if (vp.depth != 24
 			    || vp.palette != VIDEO_PALETTE_RGB24)
@@ -648,7 +649,7 @@ vicam_ioctl(struct inode *inode, struct file *file, unsigned int ioctlnr, unsign
 			DBG("VIDIOCSWIN %d x %d\n", vw.width, vw.height);
 
 			if ( vw.width != 320 || vw.height != 240 )
-				retval = -EFAULT;
+				retval = -EINVAL;
 
 			break;
 		}
@@ -706,11 +707,12 @@ vicam_ioctl(struct inode *inode, struct file *file, unsigned int ioctlnr, unsign
 				break;
 			}
 			DBG("VIDIOCSYNC: %d\n", frame);
-
+			lock_kernel();
 			read_frame(cam, frame);
 			vicam_decode_color(cam->raw_image,
 					   cam->framebuf +
 					   frame * VICAM_MAX_FRAME_SIZE );
+			unlock_kernel();
 
 			break;
 		}
@@ -737,7 +739,7 @@ vicam_ioctl(struct inode *inode, struct file *file, unsigned int ioctlnr, unsign
 		retval = -EINVAL;
 		break;
 	default:
-		retval = -ENOIOCTLCMD;
+		retval = -ENOTTY;
 		break;
 	}
 
@@ -1059,7 +1061,7 @@ static const struct file_operations vicam_fops = {
 	.release	= vicam_close,
 	.read		= vicam_read,
 	.mmap		= vicam_mmap,
-	.ioctl		= vicam_ioctl,
+	.unlocked_ioctl	= vicam_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index d97261a..3a7453f 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1376,10 +1376,10 @@ static int usbvision_do_vbi_ioctl(struct inode *inode, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static int usbvision_vbi_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg)
+static long usbvision_vbi_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, usbvision_do_vbi_ioctl);
+	return video_usercopy(file, cmd, arg, usbvision_do_vbi_ioctl);
 }
 
 
@@ -1394,7 +1394,7 @@ static const struct file_operations usbvision_fops = {
 	.release	= usbvision_v4l2_close,
 	.read		= usbvision_v4l2_read,
 	.mmap		= usbvision_v4l2_mmap,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.llseek		= no_llseek,
 /* 	.poll          = video_poll, */
 	.compat_ioctl  = v4l_compat_ioctl32,
@@ -1447,7 +1447,7 @@ static const struct file_operations usbvision_radio_fops = {
 	.owner             = THIS_MODULE,
 	.open		= usbvision_radio_open,
 	.release	= usbvision_radio_close,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.llseek		= no_llseek,
 	.compat_ioctl  = v4l_compat_ioctl32,
 };
@@ -1483,7 +1483,7 @@ static const struct file_operations usbvision_vbi_fops = {
 	.owner             = THIS_MODULE,
 	.open		= usbvision_vbi_open,
 	.release	= usbvision_vbi_close,
-	.ioctl		= usbvision_vbi_ioctl,
+	.unlocked_ioctl	= usbvision_vbi_ioctl,
 	.llseek		= no_llseek,
 	.compat_ioctl  = v4l_compat_ioctl32,
 };
diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index 31e8af0..520aafc 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -36,7 +36,8 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #define __OLD_VIDIOC_ /* To allow fixing old calls*/
@@ -556,8 +557,7 @@ video_fix_command(unsigned int cmd)
 /*
  * Obsolete usercopy function - Should be removed soon
  */
-int
-video_usercopy(struct inode *inode, struct file *file,
+long video_usercopy(struct file *file,
 	       unsigned int cmd, unsigned long arg,
 	       int (*func)(struct inode *inode, struct file *file,
 			   unsigned int cmd, void *arg))
@@ -565,10 +565,11 @@ video_usercopy(struct inode *inode, struct file *file,
 	char	sbuf[128];
 	void    *mbuf = NULL;
 	void	*parg = NULL;
-	int	err  = -EINVAL;
+	long	err  = -EINVAL;
 	int     is_ext_ctrl;
 	size_t  ctrls_size = 0;
 	void __user *user_ptr = NULL;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
 #ifdef __OLD_VIDIOC_
 	cmd = video_fix_command(cmd);
@@ -621,8 +622,10 @@ video_usercopy(struct inode *inode, struct file *file,
 		}
 	}
 
-	/* call driver */
+	/* call driver old style method */
+	lock_kernel();
 	err = func(inode, file, cmd, parg);
+	unlock_kernel();
 	if (err == -ENOIOCTLCMD)
 		err = -EINVAL;
 	if (is_ext_ctrl) {
@@ -1881,8 +1884,7 @@ static int __video_do_ioctl(struct inode *inode, struct file *file,
 	return ret;
 }
 
-int video_ioctl2 (struct inode *inode, struct file *file,
-	       unsigned int cmd, unsigned long arg)
+long video_ioctl2 (struct file *file, unsigned int cmd, unsigned long arg)
 {
 	char	sbuf[128];
 	void    *mbuf = NULL;
@@ -1891,6 +1893,7 @@ int video_ioctl2 (struct inode *inode, struct file *file,
 	int     is_ext_ctrl;
 	size_t  ctrls_size = 0;
 	void __user *user_ptr = NULL;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
 #ifdef __OLD_VIDIOC_
 	cmd = video_fix_command(cmd);
@@ -1945,7 +1948,9 @@ int video_ioctl2 (struct inode *inode, struct file *file,
 	}
 
 	/* Handles IOCTL */
+	lock_kernel();
 	err = __video_do_ioctl(inode, file, cmd, parg);
+	unlock_kernel();
 	if (err == -ENOIOCTLCMD)
 		err = -EINVAL;
 	if (is_ext_ctrl) {
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 845be18..1a7cd3a 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1051,7 +1051,7 @@ static const struct file_operations vivi_fops = {
 	.release        = vivi_close,
 	.read           = vivi_read,
 	.poll		= vivi_poll,
-	.ioctl          = video_ioctl2, /* V4L2 ioctl handler */
+	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
 	.compat_ioctl   = v4l_compat_ioctl32,
 	.mmap           = vivi_mmap,
 	.llseek         = no_llseek,
diff --git a/drivers/media/video/w9966.c b/drivers/media/video/w9966.c
index 33f7026..7ea1b64 100644
--- a/drivers/media/video/w9966.c
+++ b/drivers/media/video/w9966.c
@@ -178,8 +178,8 @@ static int w9966_i2c_wbyte(struct w9966_dev* cam, int data);
 static int w9966_i2c_rbyte(struct w9966_dev* cam);
 #endif
 
-static int w9966_v4l_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg);
+static long w9966_v4l_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg);
 static ssize_t w9966_v4l_read(struct file *file, char __user *buf,
 			      size_t count, loff_t *ppos);
 
@@ -187,7 +187,7 @@ static const struct file_operations w9966_fops = {
 	.owner		= THIS_MODULE,
 	.open           = video_exclusive_open,
 	.release        = video_exclusive_release,
-	.ioctl          = w9966_v4l_ioctl,
+	.unlocked_ioctl = w9966_v4l_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
@@ -863,10 +863,10 @@ static int w9966_v4l_do_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static int w9966_v4l_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long w9966_v4l_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, w9966_v4l_do_ioctl);
+	return video_usercopy(file, cmd, arg, w9966_v4l_do_ioctl);
 }
 
 // Capture data
diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
index 8405224..1a711a3 100644
--- a/drivers/media/video/w9968cf.c
+++ b/drivers/media/video/w9968cf.c
@@ -402,10 +402,9 @@ static const struct file_operations w9968cf_fops;
 static int w9968cf_open(struct inode*, struct file*);
 static int w9968cf_release(struct inode*, struct file*);
 static int w9968cf_mmap(struct file*, struct vm_area_struct*);
-static int w9968cf_ioctl(struct inode*, struct file*, unsigned, unsigned long);
+static long w9968cf_ioctl(struct file*, unsigned, unsigned long);
 static ssize_t w9968cf_read(struct file*, char __user *, size_t, loff_t*);
-static int w9968cf_v4l_ioctl(struct inode*, struct file*, unsigned int,
-			     void __user *);
+static long w9968cf_v4l_ioctl(struct file*, unsigned int, void __user *);
 
 /* USB-specific */
 static int w9968cf_start_transfer(struct w9968cf_device*);
@@ -2884,9 +2883,8 @@ static int w9968cf_mmap(struct file* filp, struct vm_area_struct *vma)
 }
 
 
-static int
-w9968cf_ioctl(struct inode* inode, struct file* filp,
-	      unsigned int cmd, unsigned long arg)
+static long w9968cf_ioctl(struct file * filp, unsigned int cmd,
+						unsigned long arg)
 {
 	struct w9968cf_device* cam;
 	int err;
@@ -2907,16 +2905,16 @@ w9968cf_ioctl(struct inode* inode, struct file* filp,
 		mutex_unlock(&cam->fileop_mutex);
 		return -EIO;
 	}
-
-	err = w9968cf_v4l_ioctl(inode, filp, cmd, (void __user *)arg);
-
+	lock_kernel();
+	err = w9968cf_v4l_ioctl(filp, cmd, (void __user *)arg);
+	unlock_kernel();
 	mutex_unlock(&cam->fileop_mutex);
 	return err;
 }
 
 
-static int w9968cf_v4l_ioctl(struct inode* inode, struct file* filp,
-			     unsigned int cmd, void __user * arg)
+static long  w9968cf_v4l_ioctl(struct file* filp, unsigned int cmd,
+							void __user * arg)
 {
 	struct w9968cf_device* cam;
 	const char* v4l1_ioctls[] = {
@@ -3460,7 +3458,7 @@ static const struct file_operations w9968cf_fops = {
 	.open =    w9968cf_open,
 	.release = w9968cf_release,
 	.read =    w9968cf_read,
-	.ioctl =   w9968cf_ioctl,
+	.unlocked_ioctl =   w9968cf_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/zc0301/zc0301_core.c b/drivers/media/video/zc0301/zc0301_core.c
index 363dd2b..759db81 100644
--- a/drivers/media/video/zc0301/zc0301_core.c
+++ b/drivers/media/video/zc0301/zc0301_core.c
@@ -1793,8 +1793,8 @@ zc0301_vidioc_s_parm(struct zc0301_device* cam, void __user * arg)
 }
 
 
-static int zc0301_ioctl_v4l2(struct inode* inode, struct file* filp,
-			     unsigned int cmd, void __user * arg)
+static long zc0301_ioctl_v4l2(struct file* filp, unsigned int cmd,
+							void __user * arg)
 {
 	struct zc0301_device* cam = video_get_drvdata(video_devdata(filp));
 
@@ -1888,8 +1888,8 @@ static int zc0301_ioctl_v4l2(struct inode* inode, struct file* filp,
 }
 
 
-static int zc0301_ioctl(struct inode* inode, struct file* filp,
-			unsigned int cmd, unsigned long arg)
+static long zc0301_ioctl(struct file* filp, unsigned int cmd,
+						unsigned long arg)
 {
 	struct zc0301_device* cam = video_get_drvdata(video_devdata(filp));
 	int err = 0;
@@ -1912,7 +1912,9 @@ static int zc0301_ioctl(struct inode* inode, struct file* filp,
 
 	V4LDBG(3, "zc0301", cmd);
 
-	err = zc0301_ioctl_v4l2(inode, filp, cmd, (void __user *)arg);
+	lock_kernel();
+	err = zc0301_ioctl_v4l2(filp, cmd, (void __user *)arg);
+	unlock_kernel();
 
 	mutex_unlock(&cam->fileop_mutex);
 
@@ -1924,7 +1926,7 @@ static const struct file_operations zc0301_fops = {
 	.owner =   THIS_MODULE,
 	.open =    zc0301_open,
 	.release = zc0301_release,
-	.ioctl =   zc0301_ioctl,
+	.unlocked_ioctl = zc0301_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index 0134bec..28fe8e3 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -4198,13 +4198,12 @@ zoran_do_ioctl (struct inode *inode,
 }
 
 
-static int
-zoran_ioctl (struct inode *inode,
-	     struct file  *file,
+static long
+zoran_ioctl (struct file  *file,
 	     unsigned int  cmd,
 	     unsigned long arg)
 {
-	return video_usercopy(inode, file, cmd, arg, zoran_do_ioctl);
+	return video_usercopy(file, cmd, arg, zoran_do_ioctl);
 }
 
 static unsigned int
@@ -4631,7 +4630,7 @@ static const struct file_operations zoran_fops = {
 	.owner = THIS_MODULE,
 	.open = zoran_open,
 	.release = zoran_close,
-	.ioctl = zoran_ioctl,
+	.unlocked_ioctl = zoran_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index a0e49dc..15780fa 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -757,7 +757,7 @@ static const struct file_operations zr364xx_fops = {
 	.release = zr364xx_release,
 	.read = zr364xx_read,
 	.mmap = zr364xx_mmap,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.llseek = no_llseek,
 };
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0ce07a3..0a6e4f0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -596,8 +596,8 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 	return err;
 }
 
-static int tun_chr_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long tun_chr_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct tun_struct *tun = file->private_data;
 	void __user* argp = (void __user*)arg;
@@ -633,36 +633,42 @@ static int tun_chr_ioctl(struct inode *inode, struct file *file,
 	switch (cmd) {
 	case TUNSETNOCSUM:
 		/* Disable/Enable checksum */
+		lock_kernel();
 		if (arg)
 			tun->flags |= TUN_NOCHECKSUM;
 		else
 			tun->flags &= ~TUN_NOCHECKSUM;
-
+		unlock_kernel();
 		DBG(KERN_INFO "%s: checksum %s\n",
 		    tun->dev->name, arg ? "disabled" : "enabled");
 		break;
 
 	case TUNSETPERSIST:
 		/* Disable/Enable persist mode */
+		lock_kernel();
 		if (arg)
 			tun->flags |= TUN_PERSIST;
 		else
 			tun->flags &= ~TUN_PERSIST;
-
+		unlock_kernel();
 		DBG(KERN_INFO "%s: persist %s\n",
 		    tun->dev->name, arg ? "enabled" : "disabled");
 		break;
 
 	case TUNSETOWNER:
 		/* Set owner of the device */
+		lock_kernel();
 		tun->owner = (uid_t) arg;
+		unlock_kernel();
 
 		DBG(KERN_INFO "%s: owner set to %d\n", tun->dev->name, tun->owner);
 		break;
 
 	case TUNSETGROUP:
 		/* Set group of the device */
+		lock_kernel();
 		tun->group= (gid_t) arg;
+		unlock_kernel();
 
 		DBG(KERN_INFO "%s: group set to %d\n", tun->dev->name, tun->group);
 		break;
@@ -688,12 +694,16 @@ static int tun_chr_ioctl(struct inode *inode, struct file *file,
 
 #ifdef TUN_DEBUG
 	case TUNSETDEBUG:
+		lock_kernel();
 		tun->debug = arg;
+		unlock_kernel();
 		break;
 #endif
 
 	case SIOCGIFFLAGS:
+		lock_kernel();
 		ifr.ifr_flags = tun->if_flags;
+		unlock_kernel();
 		if (copy_to_user( argp, &ifr, sizeof ifr))
 			return -EFAULT;
 		return 0;
@@ -701,15 +711,19 @@ static int tun_chr_ioctl(struct inode *inode, struct file *file,
 	case SIOCSIFFLAGS:
 		/** Set the character device's interface flags. Currently only
 		 * IFF_PROMISC and IFF_ALLMULTI are used. */
+		lock_kernel();
 		tun->if_flags = ifr.ifr_flags;
 		DBG(KERN_INFO "%s: interface flags 0x%lx\n",
 				tun->dev->name, tun->if_flags);
+		unlock_kernel();
 		return 0;
 
 	case SIOCGIFHWADDR:
 		/* Note: the actual net device's address may be different */
+		lock_kernel();
 		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev_addr,
 				min(sizeof ifr.ifr_hwaddr.sa_data, sizeof tun->dev_addr));
+		unlock_kernel();
 		if (copy_to_user( argp, &ifr, sizeof ifr))
 			return -EFAULT;
 		return 0;
@@ -719,6 +733,7 @@ static int tun_chr_ioctl(struct inode *inode, struct file *file,
 		/* try to set the actual net device's hw address */
 		int ret;
 
+		lock_kernel();
 		rtnl_lock();
 		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
 		rtnl_unlock();
@@ -734,6 +749,7 @@ static int tun_chr_ioctl(struct inode *inode, struct file *file,
 					tun->dev_addr[0], tun->dev_addr[1], tun->dev_addr[2],
 					tun->dev_addr[3], tun->dev_addr[4], tun->dev_addr[5]);
 		}
+		unlock_kernel();
 
 		return  ret;
 	}
@@ -765,7 +781,7 @@ static int tun_chr_ioctl(struct inode *inode, struct file *file,
 		return 0;
 
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	};
 
 	return 0;
@@ -841,7 +857,7 @@ static const struct file_operations tun_fops = {
 	.write = do_sync_write,
 	.aio_write = tun_chr_aio_write,
 	.poll	= tun_chr_poll,
-	.ioctl	= tun_chr_ioctl,
+	.unlocked_ioctl	= tun_chr_ioctl,
 	.open	= tun_chr_open,
 	.release = tun_chr_close,
 	.fasync = tun_chr_fasync
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index a807d2f..a08773b 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -344,8 +344,8 @@ void *priv;
 /* Version 2 functions */
 extern int video_register_device(struct video_device *vfd, int type, int nr);
 void video_unregister_device(struct video_device *);
-extern int video_ioctl2(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg);
+extern long video_ioctl2(struct file *file, unsigned int cmd,
+							unsigned long arg);
 
 /* helper functions to alloc / release struct video_device, the
    later can be used for video_device->release() */
@@ -353,8 +353,8 @@ struct video_device *video_device_alloc(void);
 void video_device_release(struct video_device *vfd);
 
 /* Include support for obsoleted stuff */
-extern int video_usercopy(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg,
+extern long video_usercopy(struct file *file, unsigned int cmd,
+			  unsigned long arg,
 			  int (*func)(struct inode *inode, struct file *file,
 				      unsigned int cmd, void *arg));
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
