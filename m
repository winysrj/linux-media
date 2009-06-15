Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2048 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZFOODF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 10:03:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFC: remove video_register_device_index, add video_register_device_range
Date: Mon, 15 Jun 2009 16:02:40 +0200
Cc: linux-media@vger.kernel.org
References: <200906151325.29079.hverkuil@xs4all.nl> <20090615104421.5d6db842@pedra.chehab.org>
In-Reply-To: <20090615104421.5d6db842@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151602.40677.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 15 June 2009 15:44:21 Mauro Carvalho Chehab wrote:
> Em Mon, 15 Jun 2009 13:25:28 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi all,
> > 
> > While looking at the video_register_device changes that broke ov511 I realized
> > that the video_register_device_index function is never called from drivers. It
> > will always assign a default index number. I also don't see a good use-case
> > for giving it an explicit index. My proposal is to remove this API. Since it
> > is never called, nothing will change effectively. I'm never happy with unused
> > functions.
> 
> It sounds ok to me.
> 
> > However, I think we do need a new video_register_device_range function. This
> > would be identical to video_register_device, but with an additional count
> > argument: this allows drivers to select a kernel number in the range of
> > nr to nr + count - 1. If cnt == -1, then the maximum is the compiled-in
> > maximum.
> > 
> > So video_register_device would call video_register_device_range(...nr, 1),
> > thus restoring the original behavior, while ivtv and cx18 can call
> > video_register_device_range(...nr, -1), thus keeping the current behavior.
> 
> I don't think that this is needed. The issue with ov511 is that it was using
> the error condition of video_register to identify how much ov511 devices were
> already registered.
> 
> I already fixed it by adding an explicit device number count on it, just like
> all the other drivers. With this, ov511 will behave like the other drivers.
> 
> With the current implementation, it should honor the explicit minor order
> passed via modprobe parameter, as before.
> 
> There's one small change on the behavior that it is also present on all other
> devices that allow users to explicit the desired minor order: instead of
> failing if that device is already used, it will get the next available one.
> IMO, this is better than just failing. So, the only remaining issue is that
> video_register should print a warning if it had to get a different minor than
> specified.

The sticking point for me is that warning since for cx18/ivtv it is OK if you
get something else then you specified (since it is a starting index meant to
distinguish mpeg encoders from raw video inputs, from mpeg decoders, etc.).

So generating a warning for those two drivers is not correct.

Perhaps we should add a V4L2_FL_KNUM_OFFSET flag for the struct video_device
flags field that tell the register function that 'nr' should be interpreted
as a kernel number offset, and not as a preferred number. In the latter case
you generate a warning, in the first case you don't.

I think it isn't a bad idea to use a flag. It reflects the two possible use
cases: one for drivers that create multiple video (or vbi) devices and use the
kernel number to reflect the purpose of each video device, and the other where
the user wants a specific kernel number. In the latter case the driver creates
a single video device.

I don't want to see a lot of kernel warnings each time an ivtv or cx18 driver
is loaded. Those warnings do not apply to those drivers.

BTW: please note that my v4l-dvb-misc tree contains a patch to clean up the
comments/variable names in v4l2-dev.c. You might want to pull that in first.

Regards,

	Hans

> 
> In other words, the enclosed patch seems to be a good approach to close this
> issue
> 
> 
> 
> Cheers,
> Mauro
> 
> ---
> 
> v4l2-dev: Print a warning if need to use a different minor than specified
> 
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> video_register_device has two behaviors: dynamic minor attribution or 
> forced minor attribution. The latter mode is used to allow users to 
> force probing a device using a certain minor order. Even for the last 
> case, video_register_device won't fail if that minor is already used 
> but, instead, it will seek for the next available minor, without warning 
> users about that.
> 
> While don't fail due to a busy minor seems the better behavior, it 
> should be printing a warning when this happen.
> 
> While here, let's remove video_register_device_index(), since no driver 
> is using it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> ---
>  linux/drivers/media/video/v4l2-dev.c |   31 ++++++++++++++++---------------
>  linux/include/media/v4l2-dev.h       |    5 ++---
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> --- master.orig/linux/drivers/media/video/v4l2-dev.c
> +++ master/linux/drivers/media/video/v4l2-dev.c
> @@ -384,23 +384,18 @@ static int get_index(struct video_device
>  	return i == VIDEO_NUM_DEVICES ? -ENFILE : i;
>  }
>  
> -int video_register_device(struct video_device *vdev, int type, int nr)
> -{
> -	return video_register_device_index(vdev, type, nr, -1);
> -}
> -EXPORT_SYMBOL(video_register_device);
>  
>  /**
> - *	video_register_device_index - register video4linux devices
> + *	video_register_device - register video4linux devices
>   *	@vdev: video device structure we want to register
>   *	@type: type of device to register
>   *	@nr:   which device number (0 == /dev/video0, 1 == /dev/video1, ...
>   *             -1 == first free)
> - *	@index: stream number based on parent device;
> - *		-1 if auto assign, requested number otherwise
>   *
>   *	The registration code assigns minor numbers based on the type
> - *	requested. -ENFILE is returned in all the device slots for this
> + *	requested. If the requested one is already used, get the next
> + *	available one and prints a warning.
> + *	-ENFILE is returned in all the device slots for this
>   *	category are full. If not then the minor field is set and the
>   *	driver initialize function is called (if non %NULL).
>   *
> @@ -416,10 +411,10 @@ EXPORT_SYMBOL(video_register_device);
>   *
>   *	%VFL_TYPE_RADIO - A radio card
>   */
> -int video_register_device_index(struct video_device *vdev, int type, int nr,
> -					int index)
> +int video_register_device(struct video_device *vdev, const int type,
> +			  const int desirednr)
>  {
> -	int i = 0;
> +	int i = 0, nr;
>  	int ret;
>  	int minor_offset = 0;
>  	int minor_cnt = VIDEO_NUM_DEVICES;
> @@ -493,7 +488,8 @@ int video_register_device_index(struct v
>  
>  	/* Pick a minor number */
>  	mutex_lock(&videodev_lock);
> -	nr = find_next_zero_bit(video_nums[type], minor_cnt, nr == -1 ? 0 : nr);
> +	nr = find_next_zero_bit(video_nums[type], minor_cnt,
> +				desirednr == -1 ? 0 : desirednr);
>  	if (nr == minor_cnt)
>  		nr = find_first_zero_bit(video_nums[type], minor_cnt);
>  	if (nr == minor_cnt) {
> @@ -501,6 +497,11 @@ int video_register_device_index(struct v
>  		mutex_unlock(&videodev_lock);
>  		return -ENFILE;
>  	}
> +
> +	if (desirednr >= 0 && nr != desirednr)
> +		printk(KERN_INFO "Minor %d is already used. Using instead %d\n",
> +		       desirednr, nr);
> +
>  #ifdef CONFIG_VIDEO_FIXED_MINOR_RANGES
>  	/* 1-on-1 mapping of kernel number to minor number */
>  	i = nr;
> @@ -520,7 +521,7 @@ int video_register_device_index(struct v
>  	set_bit(nr, video_nums[type]);
>  	/* Should not happen since we thought this minor was free */
>  	WARN_ON(video_device[vdev->minor] != NULL);
> -	ret = vdev->index = get_index(vdev, index);
> +	ret = vdev->index = get_index(vdev, -1);
>  	mutex_unlock(&videodev_lock);
>  
>  	if (ret < 0) {
> @@ -612,7 +613,7 @@ cleanup:
>  	vdev->minor = -1;
>  	return ret;
>  }
> -EXPORT_SYMBOL(video_register_device_index);
> +EXPORT_SYMBOL(video_register_device);
>  
>  /**
>   *	video_unregister_device - unregister a video4linux device
> --- master.orig/linux/include/media/v4l2-dev.h
> +++ master/linux/include/media/v4l2-dev.h
> @@ -103,9 +103,8 @@ struct video_device
>     you call video_device_release() on failure.
>  
>     Also note that vdev->minor is set to -1 if the registration failed. */
> -int __must_check video_register_device(struct video_device *vdev, int type, int nr);
> -int __must_check video_register_device_index(struct video_device *vdev,
> -						int type, int nr, int index);
> +int __must_check video_register_device(struct video_device *vdev,
> +				       const int type, const int nr);
>  
>  /* Unregister video devices. Will do nothing if vdev == NULL or
>     vdev->minor < 0. */
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
