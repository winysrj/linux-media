Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4594 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbZC0Quq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 12:50:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [question] about open/release and vidioc_g_input/vidioc_s_input functions
Date: Fri, 27 Mar 2009 17:50:18 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
References: <1237850047.31041.162.camel@tux.localhost> <200903240806.39540.hverkuil@xs4all.nl> <1238172245.4200.10.camel@tux.localhost>
In-Reply-To: <1238172245.4200.10.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271750.19032.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 March 2009 17:44:05 Alexey Klimov wrote:
> Hello, Hans
>
> On Tue, 2009-03-24 at 08:06 +0100, Hans Verkuil wrote:
> > On Tuesday 24 March 2009 00:14:07 Alexey Klimov wrote:
> > > Hello, all
> > >
> > > ...
> > >  static int terratec_open(struct file *file)
> > > {
> > >         return 0;
> > > }
> > >
> > > static int terratec_release(struct file *file)
> > > {
> > >         return 0;
> > > }
> > > ...
> > >
> > > ...
> > >
> > > Such code used in many radio-drivers as i understand.
> > >
> > > Is it good to place this empty and almost empty functions in:
> > > (here i see two variants)
> > >
> > > 1) In header file that be in linux/drivers/media/radio/ directory.
> > > Later, we can move some generic/or repeating code in this header.
> > >
> > > 2) In any v4l header. What header may contain this ?
> > >
> > > ?
> > >
> > > For what ? Well, as i understand we can decrease amount of lines and
> > > provide this simple generic functions. It's like
> > > video_device_release_empty function behaviour. Maybe not only radio
> > > drivers can use such vidioc_g_input and vidioc_s_input.
> > >
> > > Is it worth ?
> >
> > I don't think it is worth doing this for g/s_input. I think it is
> > useful to have them here: it makes it very clear that there is just a
> > single input and the overhead in both lines and actual bytes is
> > minimal.
> >
> > But for the empty open and release functions you could easily handle
> > that in v4l2-dev.c: if you leave the open and release callbacks to
> > NULL, then v4l2_open and v4l2_release can just return 0. That would be
> > nice.
> >
> > Regards,
> >
> > 	Hans
>
> May i ask help with this ?
> Hans, should it be looks like:
>
> diff -r 56cf0f1772f7 linux/drivers/media/radio/radio-terratec.c
> --- a/linux/drivers/media/radio/radio-terratec.c	Mon Mar 23 19:18:34 2009
> -0300 +++ b/linux/drivers/media/radio/radio-terratec.c	Fri Mar 27
> 19:32:38 2009 +0300 @@ -333,20 +333,8 @@
>  	return a->index ? -EINVAL : 0;
>  }
>
> -static int terratec_open(struct file *file)
> -{
> -	return 0;
> -}
> -
> -static int terratec_release(struct file *file)
> -{
> -	return 0;
> -}
> -
>  static const struct v4l2_file_operations terratec_fops = {
>  	.owner		= THIS_MODULE,
> -	.open           = terratec_open,
> -	.release        = terratec_release,
>  	.ioctl		= video_ioctl2,
>  };
>
> diff -r 56cf0f1772f7 linux/drivers/media/video/v4l2-dev.c
> --- a/linux/drivers/media/video/v4l2-dev.c	Mon Mar 23 19:18:34 2009 -0300
> +++ b/linux/drivers/media/video/v4l2-dev.c	Fri Mar 27 19:32:38 2009 +0300
> @@ -264,7 +264,10 @@
>  	/* and increase the device refcount */
>  	video_get(vdev);
>  	mutex_unlock(&videodev_lock);
> -	ret = vdev->fops->open(filp);
> +	if (vdev->fops->open == NULL)
> +		ret = 0;
> +	else
> +		ret = vdev->fops->open(filp);
>  	/* decrease the refcount in case of an error */
>  	if (ret)
>  		video_put(vdev);
> @@ -275,7 +278,12 @@
>  static int v4l2_release(struct inode *inode, struct file *filp)
>  {
>  	struct video_device *vdev = video_devdata(filp);
> -	int ret = vdev->fops->release(filp);
> +	int ret;
> +
> +	if (vdev->fops->release == NULL)
> +		ret = 0;
> +	else
> +		ret = vdev->fops->release(filp);
>
>  	/* decrease the refcount unconditionally since the release()
>  	   return value is ignored. */
>
> ?
>
> Or in v4l2_open function i can check if vdev->fops->open == NULL before
> video_get(vdev); (increasing the device refcount), and if it's NULL then
> unlock_mutex and return 0 ?
> And the same in v4l2_release - just return 0 in the begining of function
> in case vdev->fops->release == NULL ?
>
> What approach is better ?

This is simpler:

diff -r 2e0c6ff1bda3 linux/drivers/media/video/v4l2-dev.c
--- a/linux/drivers/media/video/v4l2-dev.c      Mon Mar 23 19:01:18 2009 
+0100
+++ b/linux/drivers/media/video/v4l2-dev.c      Fri Mar 27 17:47:51 2009 
+0100
@@ -250,7 +250,7 @@
 static int v4l2_open(struct inode *inode, struct file *filp)
 {
        struct video_device *vdev;
-       int ret;
+       int ret = 0;

        /* Check if the video device is available */
        mutex_lock(&videodev_lock);
@@ -264,7 +264,9 @@
        /* and increase the device refcount */
        video_get(vdev);
        mutex_unlock(&videodev_lock);
-       ret = vdev->fops->open(filp);
+       if (vdev->fops->open)
+               ret = vdev->fops->open(filp);
+
        /* decrease the refcount in case of an error */
        if (ret)
                video_put(vdev);
@@ -275,7 +277,10 @@
 static int v4l2_release(struct inode *inode, struct file *filp)
 {
        struct video_device *vdev = video_devdata(filp);
-       int ret = vdev->fops->release(filp);
+       int ret = 0;
+
+       if (vdev->fops->release)
+               ret = vdev->fops->release(filp);

        /* decrease the refcount unconditionally since the release()
           return value is ignored. */

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
