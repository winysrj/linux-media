Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:48938 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab2JVR2E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 13:28:04 -0400
Date: Mon, 22 Oct 2012 21:29:01 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] vivi: Teach it to tune FPS
Message-ID: <20121022172901.GA24720@tugrik.mns.mnsspb.ru>
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
 <1350914084-31618-2-git-send-email-kirr@mns.spb.ru>
 <201210221616.14299.hverkuil@xs4all.nl>
 <20121022170139.GA23735@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022170139.GA23735@tugrik.mns.mnsspb.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 22, 2012 at 09:01:39PM +0400, Kirill Smelkov wrote:
> On Mon, Oct 22, 2012 at 04:16:14PM +0200, Hans Verkuil wrote:
> > On Mon October 22 2012 15:54:44 Kirill Smelkov wrote:
> > > I was testing my video-over-ethernet subsystem today, and vivi seemed to
> > > be perfect video source for testing when one don't have lots of capture
> > > boards and cameras. Only its framerate was hardcoded to NTSC's 30fps,
> > > while in my country we usually use PAL (25 fps). That's why the patch.
> > > Thanks.
> > 
> > Rather than introducing a module option, it's much nicer if you can
> > implement enum_frameintervals and g/s_parm. This can be made quite flexible
> > allowing you to also support 50/59.94/60 fps.
> 
> Thanks for feedback. I've reworked the patch for FPS to be set via
> ->{g,s}_parm(), and yes now it is more flexble, because one can set

By the way, here is what I've found while working on the abovementioned
patch:

---- 8< ----
From: Kirill Smelkov <kirr@mns.spb.ru>
Date: Mon, 22 Oct 2012 21:14:01 +0400
Subject: [PATCH] v4l2: Fix typo in struct v4l2_captureparm description

Judging from what drivers do and from my experience temeperframe
fraction is set in seconds - look e.g. here

    static int bttv_g_parm(struct file *file, void *f,
                                    struct v4l2_streamparm *parm)
    {
            struct bttv_fh *fh = f;
            struct bttv *btv = fh->btv;

            v4l2_video_std_frame_period(bttv_tvnorms[btv->tvnorm].v4l2_id,
                                        &parm->parm.capture.timeperframe);

    ...

    void v4l2_video_std_frame_period(int id, struct v4l2_fract *frameperiod)
    {
            if (id & V4L2_STD_525_60) {
                    frameperiod->numerator = 1001;
                    frameperiod->denominator = 30000;
            } else {
                    frameperiod->numerator = 1;
                    frameperiod->denominator = 25;
            }

and also v4l2-ctl in userspace decodes this as seconds:

    if (doioctl(fd, VIDIOC_G_PARM, &parm, "VIDIOC_G_PARM") == 0) {
            const struct v4l2_fract &tf = parm.parm.capture.timeperframe;

            ...

            printf("\tFrames per second: %.3f (%d/%d)\n",
                            (1.0 * tf.denominator) / tf.numerator,
                            tf.denominator, tf.numerator);

The typo was there from day 1 - added in 2002 in e028b61b ([PATCH]
add v4l2 api)(*)

(*) found in history tree
    git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 include/uapi/linux/videodev2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 57bfa59..2fff7ff 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -726,29 +726,29 @@ struct v4l2_window {
 	__u32			field;	 /* enum v4l2_field */
 	__u32			chromakey;
 	struct v4l2_clip	__user *clips;
 	__u32			clipcount;
 	void			__user *bitmap;
 	__u8                    global_alpha;
 };
 
 /*
  *	C A P T U R E   P A R A M E T E R S
  */
 struct v4l2_captureparm {
 	__u32		   capability;	  /*  Supported modes */
 	__u32		   capturemode;	  /*  Current mode */
-	struct v4l2_fract  timeperframe;  /*  Time per frame in .1us units */
+	struct v4l2_fract  timeperframe;  /*  Time per frame in seconds */
 	__u32		   extendedmode;  /*  Driver-specific extensions */
 	__u32              readbuffers;   /*  # of buffers for read */
 	__u32		   reserved[4];
 };
 
 /*  Flags for 'capability' and 'capturemode' fields */
 #define V4L2_MODE_HIGHQUALITY	0x0001	/*  High quality imaging mode */
 #define V4L2_CAP_TIMEPERFRAME	0x1000	/*  timeperframe field is supported */
 
 struct v4l2_outputparm {
 	__u32		   capability;	 /*  Supported modes */
 	__u32		   outputmode;	 /*  Current mode */
 	struct v4l2_fract  timeperframe; /*  Time per frame in seconds */
 	__u32		   extendedmode; /*  Driver-specific extensions */
-- 
1.8.0.rc3.331.g5b9a629

