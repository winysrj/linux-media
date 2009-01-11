Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:46276 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZAKApI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 19:45:08 -0500
Date: Sat, 10 Jan 2009 16:45:04 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Marton Balint <cus@fazekas.hu>
cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] cx88: fix unexpected video resize when setting tv norm
In-Reply-To: <571b3176dc82a7206ade.1231614963@roadrunner.athome>
Message-ID: <Pine.LNX.4.58.0901101325420.1626@shell2.speakeasy.net>
References: <571b3176dc82a7206ade.1231614963@roadrunner.athome>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 10 Jan 2009, Marton Balint wrote:
> Cx88_set_tvnorm sets the size of the video to fixed 320x240. This is ugly at
> least, but also can cause problems, if it happens during an active video
> transfer. With this patch, cx88_set_scale will save the last requested video
> size, and cx88_set_tvnorm will scale the video to this size.
>
> diff -r 985ecd81d993 -r 571b3176dc82 linux/drivers/media/video/cx88/cx88.h
> @@ -352,6 +352,9 @@
>  	u32                        input;
>  	u32                        astat;
>  	u32			   use_nicam;
> +	unsigned int		   last_width;
> +	unsigned int		   last_height;
> +	enum v4l2_field		   last_field;

Instead of adding these extra fields to the core, maybe it would be better
to just add w/h/field as arguments to set_tvnorm?  I have a patch to do
this, but there are still problems.

The allowable sizes depends on the video norm.  If you select 720x576 in
PAL and then change the norm to NTSC bad things will happen if the driver
tries to maintain more than 480 lines.  So cx88_set_scale() will happily
program bogus register values on size change.

cx88_set_tvnorm() would need to check if the current size can be maintained
in the new norm and if it's not, change it to something valid (what?).  Or
maybe the S_STD ioctl handler should adjust the size to something valid?

What does V4L2 say about what should happen if the current format will no
longer be valid after a norm change?  Should the norm change fail?  Should
the format be adjusted to one that is valid?  The norm is per device but
the format is per file handle, so would changing the norm on one file
handle modify the format of a different open file handle?  That doesn't
seem right.  But, v4l2 seems require that you aren't allowed to set an
invalid format, so getting an invalid format via a norm change seems wrong
too.

Changing norms during capture has more problems.  I'm not sure if v4l2 even
allows it.  Even if allowed, I don't think the cx88 driver should try to
support it.

The norm change code will immediately program a bunch of register values
when the norm is set.  These could easily screw up current video activity.
Suppose the cx88 is in the middle of capturing a 576 line PAL frame and the
norm is changed to NTSC.  How is that supposed to be handled?

In my patch, setting the tvnorm keeps the file handle's current size.  This
won't work during capture as the cx88's scalers are programmed on a
frame-by-frame basis and the current frame being captured might not be the
same size as the file handle which tried to change the norm.

I think there is also a race in your patch, as the call to cx88_set_scale()
when a frame is queued isn't protected against the tvnorm ioctl.  It might
be possible to fix that by grabbing the queue spinlock before changing the
norm.  Still, I don't think the code the programs the registers for a norm
change is designed to be safe to call during capture.

So I think the best thing would be to have S_STD return -EBUSY if there is
an ongoing capture.  Maybe even have v4l2-dev take care of that if
possible.

---
diff -r f01b3897d141 linux/drivers/media/video/cx88/cx88-blackbird.c
--- a/linux/drivers/media/video/cx88/cx88-blackbird.c	Fri Jan 09 00:27:32 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88-blackbird.c	Sat Jan 10 14:45:55 2009 -0800
@@ -1058,10 +1058,12 @@ static int vidioc_s_tuner (struct file *

 static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *id)
 {
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
+	struct cx8802_fh *fh = priv;
+	struct cx88_core *core = fh->dev->core;

 	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core,*id);
+	cx88_set_tvnorm(core, *id, fh->dev->width, fh->dev->height,
+			fh->mpegq.field);
 	mutex_unlock(&core->lock);
 	return 0;
 }
@@ -1370,7 +1372,7 @@ static int cx8802_blackbird_probe(struct
 #if 1
 	mutex_lock(&dev->core->lock);
 //	init_controls(core);
-	cx88_set_tvnorm(core,core->tvnorm);
+	cx88_set_tvnorm(core, core->tvnorm, 320, 240, V4L2_FIELD_INTERLACED);
 	cx88_video_mux(core,0);
 	mutex_unlock(&dev->core->lock);
 #endif
diff -r f01b3897d141 linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Fri Jan 09 00:27:32 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Sat Jan 10 14:45:55 2009 -0800
@@ -905,7 +905,9 @@ static int set_tvaudio(struct cx88_core



-int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
+int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm,
+		    unsigned int width, unsigned int height,
+		    enum v4l2_field field)
 {
 	u32 fsc8;
 	u32 adc_clock;
@@ -1014,7 +1016,7 @@ int cx88_set_tvnorm(struct cx88_core *co
 	cx_write(MO_VBI_PACKET, (10<<11) | norm_vbipack(norm));

 	// this is needed as well to set all tvnorm parameter
-	cx88_set_scale(core, 320, 240, V4L2_FIELD_INTERLACED);
+	cx88_set_scale(core, width, height, field);

 	// audio
 	set_tvaudio(core);
diff -r f01b3897d141 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Fri Jan 09 00:27:32 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sat Jan 10 14:45:55 2009 -0800
@@ -1490,10 +1490,11 @@ static int vidioc_streamoff(struct file

 static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *tvnorms)
 {
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
+	struct cx8800_fh *fh = priv;
+	struct cx88_core *core = fh->dev->core;

 	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core,*tvnorms);
+	cx88_set_tvnorm(core, *tvnorms, fh->width, fh->height, fh->vidq.field);
 	mutex_unlock(&core->lock);

 	return 0;
@@ -2221,7 +2222,7 @@ static int __devinit cx8800_initdev(stru

 	/* initial device configuration */
 	mutex_lock(&core->lock);
-	cx88_set_tvnorm(core,core->tvnorm);
+	cx88_set_tvnorm(core, core->tvnorm, 320, 240, V4L2_FIELD_INTERLACED);
 	init_controls(core);
 	cx88_video_mux(core,0);
 	mutex_unlock(&core->lock);
diff -r f01b3897d141 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Fri Jan 09 00:27:32 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88.h	Sat Jan 10 14:45:55 2009 -0800
@@ -594,7 +594,9 @@ extern void cx88_sram_channel_dump(struc

 extern int cx88_set_scale(struct cx88_core *core, unsigned int width,
 			  unsigned int height, enum v4l2_field field);
-extern int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm);
+extern int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm,
+			   unsigned int width, unsigned int height,
+			   enum v4l2_field field);

 extern struct video_device *cx88_vdev_init(struct cx88_core *core,
 					   struct pci_dev *pci,
