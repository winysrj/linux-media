Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab2EJIAP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:00:15 -0400
Message-ID: <4FAB758F.4040903@redhat.com>
Date: Thu, 10 May 2012 10:00:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/5] v4l2-dev: make it possible to skip locking
 for selected ioctls.
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <0f97ebe03ff17602c7a62e8a6a16414f1f897270.1336632433.git.hans.verkuil@cisco.com>
In-Reply-To: <0f97ebe03ff17602c7a62e8a6a16414f1f897270.1336632433.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks good, ack.

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


On 05/10/2012 09:05 AM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Using the V4L2 core lock is a very robust method that is usually very good
> at doing the right thing. But some drivers, particularly USB drivers, may
> want to prevent the core from taking the lock for specific ioctls, particularly
> buffer queuing ioctls.
>
> The reason is that certain commands like S_CTRL can take a long time to process
> over USB and all the time the core has the lock, preventing VIDIOC_DQBUF from
> proceeding, even though a frame may be ready in the queue.
>
> This introduces unwanted latency.
>
> Since the buffer queuing commands often have their own internal lock it is
> often not necessary to take the core lock. Drivers can now say that they don't
> want the core to take the lock for specific ioctls.
>
> As it is a specific opt-out it makes it clear to the reviewer that those
> ioctls will need more care when reviewing.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   Documentation/video4linux/v4l2-framework.txt |   27 +++-
>   drivers/media/video/v4l2-dev.c               |   14 +-
>   drivers/media/video/v4l2-ioctl.c             |  189 ++++++++++++++------------
>   include/media/v4l2-dev.h                     |   11 ++
>   4 files changed, 148 insertions(+), 93 deletions(-)
>
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 369d4bc..4b9b407 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -559,19 +559,25 @@ allocated memory.
>   You should also set these fields:
>
>   - v4l2_dev: set to the v4l2_device parent device.
> +
>   - name: set to something descriptive and unique.
> +
>   - fops: set to the v4l2_file_operations struct.
> +
>   - ioctl_ops: if you use the v4l2_ioctl_ops to simplify ioctl maintenance
>     (highly recommended to use this and it might become compulsory in the
>     future!), then set this to your v4l2_ioctl_ops struct.
> +
>   - lock: leave to NULL if you want to do all the locking in the driver.
>     Otherwise you give it a pointer to a struct mutex_lock and before any
>     of the v4l2_file_operations is called this lock will be taken by the
> -  core and released afterwards.
> +  core and released afterwards. See the next section for more details.
> +
>   - prio: keeps track of the priorities. Used to implement VIDIOC_G/S_PRIORITY.
>     If left to NULL, then it will use the struct v4l2_prio_state in v4l2_device.
>     If you want to have a separate priority state per (group of) device node(s),
>     then you can point it to your own struct v4l2_prio_state.
> +
>   - parent: you only set this if v4l2_device was registered with NULL as
>     the parent device struct. This only happens in cases where one hardware
>     device has multiple PCI devices that all share the same v4l2_device core.
> @@ -581,6 +587,7 @@ You should also set these fields:
>     (cx8802). Since the v4l2_device cannot be associated with a particular
>     PCI device it is setup without a parent device. But when the struct
>     video_device is setup you do know which parent PCI device to use.
> +
>   - flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the framework
>     handle the VIDIOC_G/S_PRIORITY ioctls. This requires that you use struct
>     v4l2_fh. Eventually this flag will disappear once all drivers use the core
> @@ -613,8 +620,22 @@ v4l2_file_operations and locking
>   --------------------------------
>
>   You can set a pointer to a mutex_lock in struct video_device. Usually this
> -will be either a top-level mutex or a mutex per device node. If you want
> -finer-grained locking then you have to set it to NULL and do you own locking.
> +will be either a top-level mutex or a mutex per device node. By default this
> +lock will be used for each file operation and ioctl, but you can disable
> +locking for selected ioctls by calling:
> +
> +	void v4l2_dont_use_lock(struct video_device *vdev, unsigned int cmd);
> +
> +E.g.: v4l2_dont_use_lock(vdev, VIDIOC_DQBUF);
> +
> +You have to call this before you register the video_device.
> +
> +Particularly with USB drivers where certain commands such as setting controls
> +can take a long time you may want to do your own locking for the buffer queuing
> +ioctls.
> +
> +If you want still finer-grained locking then you have to set mutex_lock to NULL
> +and do you own locking completely.
>
>   It is up to the driver developer to decide which method to use. However, if
>   your driver has high-latency operations (for example, changing the exposure
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 70bec54..a51a061 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -322,11 +322,19 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	int ret = -ENODEV;
>
>   	if (vdev->fops->unlocked_ioctl) {
> -		if (vdev->lock&&  mutex_lock_interruptible(vdev->lock))
> -			return -ERESTARTSYS;
> +		bool locked = false;
> +
> +		if (vdev->lock) {
> +			/* always lock unless the cmd is marked as "don't use lock" */
> +			locked = !v4l2_is_valid_ioctl(cmd) ||
> +				 !test_bit(_IOC_NR(cmd), vdev->dont_use_lock);
> +
> +			if (locked&&  mutex_lock_interruptible(vdev->lock))
> +				return -ERESTARTSYS;
> +		}
>   		if (video_is_registered(vdev))
>   			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> -		if (vdev->lock)
> +		if (locked)
>   			mutex_unlock(vdev->lock);
>   	} else if (vdev->fops->ioctl) {
>   		/* This code path is a replacement for the BKL. It is a major
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 5b2ec1f..3f34098 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -195,93 +195,106 @@ static const char *v4l2_memory_names[] = {
>
>   /* ------------------------------------------------------------------ */
>   /* debug help functions                                               */
> -static const char *v4l2_ioctls[] = {
> -	[_IOC_NR(VIDIOC_QUERYCAP)]         = "VIDIOC_QUERYCAP",
> -	[_IOC_NR(VIDIOC_RESERVED)]         = "VIDIOC_RESERVED",
> -	[_IOC_NR(VIDIOC_ENUM_FMT)]         = "VIDIOC_ENUM_FMT",
> -	[_IOC_NR(VIDIOC_G_FMT)]            = "VIDIOC_G_FMT",
> -	[_IOC_NR(VIDIOC_S_FMT)]            = "VIDIOC_S_FMT",
> -	[_IOC_NR(VIDIOC_REQBUFS)]          = "VIDIOC_REQBUFS",
> -	[_IOC_NR(VIDIOC_QUERYBUF)]         = "VIDIOC_QUERYBUF",
> -	[_IOC_NR(VIDIOC_G_FBUF)]           = "VIDIOC_G_FBUF",
> -	[_IOC_NR(VIDIOC_S_FBUF)]           = "VIDIOC_S_FBUF",
> -	[_IOC_NR(VIDIOC_OVERLAY)]          = "VIDIOC_OVERLAY",
> -	[_IOC_NR(VIDIOC_QBUF)]             = "VIDIOC_QBUF",
> -	[_IOC_NR(VIDIOC_DQBUF)]            = "VIDIOC_DQBUF",
> -	[_IOC_NR(VIDIOC_STREAMON)]         = "VIDIOC_STREAMON",
> -	[_IOC_NR(VIDIOC_STREAMOFF)]        = "VIDIOC_STREAMOFF",
> -	[_IOC_NR(VIDIOC_G_PARM)]           = "VIDIOC_G_PARM",
> -	[_IOC_NR(VIDIOC_S_PARM)]           = "VIDIOC_S_PARM",
> -	[_IOC_NR(VIDIOC_G_STD)]            = "VIDIOC_G_STD",
> -	[_IOC_NR(VIDIOC_S_STD)]            = "VIDIOC_S_STD",
> -	[_IOC_NR(VIDIOC_ENUMSTD)]          = "VIDIOC_ENUMSTD",
> -	[_IOC_NR(VIDIOC_ENUMINPUT)]        = "VIDIOC_ENUMINPUT",
> -	[_IOC_NR(VIDIOC_G_CTRL)]           = "VIDIOC_G_CTRL",
> -	[_IOC_NR(VIDIOC_S_CTRL)]           = "VIDIOC_S_CTRL",
> -	[_IOC_NR(VIDIOC_G_TUNER)]          = "VIDIOC_G_TUNER",
> -	[_IOC_NR(VIDIOC_S_TUNER)]          = "VIDIOC_S_TUNER",
> -	[_IOC_NR(VIDIOC_G_AUDIO)]          = "VIDIOC_G_AUDIO",
> -	[_IOC_NR(VIDIOC_S_AUDIO)]          = "VIDIOC_S_AUDIO",
> -	[_IOC_NR(VIDIOC_QUERYCTRL)]        = "VIDIOC_QUERYCTRL",
> -	[_IOC_NR(VIDIOC_QUERYMENU)]        = "VIDIOC_QUERYMENU",
> -	[_IOC_NR(VIDIOC_G_INPUT)]          = "VIDIOC_G_INPUT",
> -	[_IOC_NR(VIDIOC_S_INPUT)]          = "VIDIOC_S_INPUT",
> -	[_IOC_NR(VIDIOC_G_OUTPUT)]         = "VIDIOC_G_OUTPUT",
> -	[_IOC_NR(VIDIOC_S_OUTPUT)]         = "VIDIOC_S_OUTPUT",
> -	[_IOC_NR(VIDIOC_ENUMOUTPUT)]       = "VIDIOC_ENUMOUTPUT",
> -	[_IOC_NR(VIDIOC_G_AUDOUT)]         = "VIDIOC_G_AUDOUT",
> -	[_IOC_NR(VIDIOC_S_AUDOUT)]         = "VIDIOC_S_AUDOUT",
> -	[_IOC_NR(VIDIOC_G_MODULATOR)]      = "VIDIOC_G_MODULATOR",
> -	[_IOC_NR(VIDIOC_S_MODULATOR)]      = "VIDIOC_S_MODULATOR",
> -	[_IOC_NR(VIDIOC_G_FREQUENCY)]      = "VIDIOC_G_FREQUENCY",
> -	[_IOC_NR(VIDIOC_S_FREQUENCY)]      = "VIDIOC_S_FREQUENCY",
> -	[_IOC_NR(VIDIOC_CROPCAP)]          = "VIDIOC_CROPCAP",
> -	[_IOC_NR(VIDIOC_G_CROP)]           = "VIDIOC_G_CROP",
> -	[_IOC_NR(VIDIOC_S_CROP)]           = "VIDIOC_S_CROP",
> -	[_IOC_NR(VIDIOC_G_SELECTION)]      = "VIDIOC_G_SELECTION",
> -	[_IOC_NR(VIDIOC_S_SELECTION)]      = "VIDIOC_S_SELECTION",
> -	[_IOC_NR(VIDIOC_G_JPEGCOMP)]       = "VIDIOC_G_JPEGCOMP",
> -	[_IOC_NR(VIDIOC_S_JPEGCOMP)]       = "VIDIOC_S_JPEGCOMP",
> -	[_IOC_NR(VIDIOC_QUERYSTD)]         = "VIDIOC_QUERYSTD",
> -	[_IOC_NR(VIDIOC_TRY_FMT)]          = "VIDIOC_TRY_FMT",
> -	[_IOC_NR(VIDIOC_ENUMAUDIO)]        = "VIDIOC_ENUMAUDIO",
> -	[_IOC_NR(VIDIOC_ENUMAUDOUT)]       = "VIDIOC_ENUMAUDOUT",
> -	[_IOC_NR(VIDIOC_G_PRIORITY)]       = "VIDIOC_G_PRIORITY",
> -	[_IOC_NR(VIDIOC_S_PRIORITY)]       = "VIDIOC_S_PRIORITY",
> -	[_IOC_NR(VIDIOC_G_SLICED_VBI_CAP)] = "VIDIOC_G_SLICED_VBI_CAP",
> -	[_IOC_NR(VIDIOC_LOG_STATUS)]       = "VIDIOC_LOG_STATUS",
> -	[_IOC_NR(VIDIOC_G_EXT_CTRLS)]      = "VIDIOC_G_EXT_CTRLS",
> -	[_IOC_NR(VIDIOC_S_EXT_CTRLS)]      = "VIDIOC_S_EXT_CTRLS",
> -	[_IOC_NR(VIDIOC_TRY_EXT_CTRLS)]    = "VIDIOC_TRY_EXT_CTRLS",
> -#if 1
> -	[_IOC_NR(VIDIOC_ENUM_FRAMESIZES)]  = "VIDIOC_ENUM_FRAMESIZES",
> -	[_IOC_NR(VIDIOC_ENUM_FRAMEINTERVALS)] = "VIDIOC_ENUM_FRAMEINTERVALS",
> -	[_IOC_NR(VIDIOC_G_ENC_INDEX)] 	   = "VIDIOC_G_ENC_INDEX",
> -	[_IOC_NR(VIDIOC_ENCODER_CMD)] 	   = "VIDIOC_ENCODER_CMD",
> -	[_IOC_NR(VIDIOC_TRY_ENCODER_CMD)]  = "VIDIOC_TRY_ENCODER_CMD",
> -
> -	[_IOC_NR(VIDIOC_DECODER_CMD)]	   = "VIDIOC_DECODER_CMD",
> -	[_IOC_NR(VIDIOC_TRY_DECODER_CMD)]  = "VIDIOC_TRY_DECODER_CMD",
> -	[_IOC_NR(VIDIOC_DBG_S_REGISTER)]   = "VIDIOC_DBG_S_REGISTER",
> -	[_IOC_NR(VIDIOC_DBG_G_REGISTER)]   = "VIDIOC_DBG_G_REGISTER",
> -
> -	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
> -	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
> -#endif
> -	[_IOC_NR(VIDIOC_ENUM_DV_PRESETS)]  = "VIDIOC_ENUM_DV_PRESETS",
> -	[_IOC_NR(VIDIOC_S_DV_PRESET)]	   = "VIDIOC_S_DV_PRESET",
> -	[_IOC_NR(VIDIOC_G_DV_PRESET)]	   = "VIDIOC_G_DV_PRESET",
> -	[_IOC_NR(VIDIOC_QUERY_DV_PRESET)]  = "VIDIOC_QUERY_DV_PRESET",
> -	[_IOC_NR(VIDIOC_S_DV_TIMINGS)]     = "VIDIOC_S_DV_TIMINGS",
> -	[_IOC_NR(VIDIOC_G_DV_TIMINGS)]     = "VIDIOC_G_DV_TIMINGS",
> -	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
> -	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
> -	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> -	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
> -	[_IOC_NR(VIDIOC_PREPARE_BUF)]      = "VIDIOC_PREPARE_BUF",
> +
> +struct v4l2_ioctl_info {
> +	unsigned int ioctl;
> +	const char * const name;
> +};
> +
> +#define IOCTL_INFO(_ioctl) [_IOC_NR(_ioctl)] = {	\
> +	.ioctl = _ioctl,				\
> +	.name = #_ioctl,				\
> +}
> +
> +static struct v4l2_ioctl_info v4l2_ioctls[] = {
> +	IOCTL_INFO(VIDIOC_QUERYCAP),
> +	IOCTL_INFO(VIDIOC_ENUM_FMT),
> +	IOCTL_INFO(VIDIOC_G_FMT),
> +	IOCTL_INFO(VIDIOC_S_FMT),
> +	IOCTL_INFO(VIDIOC_REQBUFS),
> +	IOCTL_INFO(VIDIOC_QUERYBUF),
> +	IOCTL_INFO(VIDIOC_G_FBUF),
> +	IOCTL_INFO(VIDIOC_S_FBUF),
> +	IOCTL_INFO(VIDIOC_OVERLAY),
> +	IOCTL_INFO(VIDIOC_QBUF),
> +	IOCTL_INFO(VIDIOC_DQBUF),
> +	IOCTL_INFO(VIDIOC_STREAMON),
> +	IOCTL_INFO(VIDIOC_STREAMOFF),
> +	IOCTL_INFO(VIDIOC_G_PARM),
> +	IOCTL_INFO(VIDIOC_S_PARM),
> +	IOCTL_INFO(VIDIOC_G_STD),
> +	IOCTL_INFO(VIDIOC_S_STD),
> +	IOCTL_INFO(VIDIOC_ENUMSTD),
> +	IOCTL_INFO(VIDIOC_ENUMINPUT),
> +	IOCTL_INFO(VIDIOC_G_CTRL),
> +	IOCTL_INFO(VIDIOC_S_CTRL),
> +	IOCTL_INFO(VIDIOC_G_TUNER),
> +	IOCTL_INFO(VIDIOC_S_TUNER),
> +	IOCTL_INFO(VIDIOC_G_AUDIO),
> +	IOCTL_INFO(VIDIOC_S_AUDIO),
> +	IOCTL_INFO(VIDIOC_QUERYCTRL),
> +	IOCTL_INFO(VIDIOC_QUERYMENU),
> +	IOCTL_INFO(VIDIOC_G_INPUT),
> +	IOCTL_INFO(VIDIOC_S_INPUT),
> +	IOCTL_INFO(VIDIOC_G_OUTPUT),
> +	IOCTL_INFO(VIDIOC_S_OUTPUT),
> +	IOCTL_INFO(VIDIOC_ENUMOUTPUT),
> +	IOCTL_INFO(VIDIOC_G_AUDOUT),
> +	IOCTL_INFO(VIDIOC_S_AUDOUT),
> +	IOCTL_INFO(VIDIOC_G_MODULATOR),
> +	IOCTL_INFO(VIDIOC_S_MODULATOR),
> +	IOCTL_INFO(VIDIOC_G_FREQUENCY),
> +	IOCTL_INFO(VIDIOC_S_FREQUENCY),
> +	IOCTL_INFO(VIDIOC_CROPCAP),
> +	IOCTL_INFO(VIDIOC_G_CROP),
> +	IOCTL_INFO(VIDIOC_S_CROP),
> +	IOCTL_INFO(VIDIOC_G_SELECTION),
> +	IOCTL_INFO(VIDIOC_S_SELECTION),
> +	IOCTL_INFO(VIDIOC_G_JPEGCOMP),
> +	IOCTL_INFO(VIDIOC_S_JPEGCOMP),
> +	IOCTL_INFO(VIDIOC_QUERYSTD),
> +	IOCTL_INFO(VIDIOC_TRY_FMT),
> +	IOCTL_INFO(VIDIOC_ENUMAUDIO),
> +	IOCTL_INFO(VIDIOC_ENUMAUDOUT),
> +	IOCTL_INFO(VIDIOC_G_PRIORITY),
> +	IOCTL_INFO(VIDIOC_S_PRIORITY),
> +	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP),
> +	IOCTL_INFO(VIDIOC_LOG_STATUS),
> +	IOCTL_INFO(VIDIOC_G_EXT_CTRLS),
> +	IOCTL_INFO(VIDIOC_S_EXT_CTRLS),
> +	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS),
> +	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES),
> +	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS),
> +	IOCTL_INFO(VIDIOC_G_ENC_INDEX),
> +	IOCTL_INFO(VIDIOC_ENCODER_CMD),
> +	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD),
> +	IOCTL_INFO(VIDIOC_DECODER_CMD),
> +	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD),
> +	IOCTL_INFO(VIDIOC_DBG_S_REGISTER),
> +	IOCTL_INFO(VIDIOC_DBG_G_REGISTER),
> +	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT),
> +	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK),
> +	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS),
> +	IOCTL_INFO(VIDIOC_S_DV_PRESET),
> +	IOCTL_INFO(VIDIOC_G_DV_PRESET),
> +	IOCTL_INFO(VIDIOC_QUERY_DV_PRESET),
> +	IOCTL_INFO(VIDIOC_S_DV_TIMINGS),
> +	IOCTL_INFO(VIDIOC_G_DV_TIMINGS),
> +	IOCTL_INFO(VIDIOC_DQEVENT),
> +	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT),
> +	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT),
> +	IOCTL_INFO(VIDIOC_CREATE_BUFS),
> +	IOCTL_INFO(VIDIOC_PREPARE_BUF),
>   };
>   #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>
> +bool v4l2_is_valid_ioctl(unsigned int cmd)
> +{
> +	if (_IOC_NR(cmd)>= V4L2_IOCTLS)
> +		return false;
> +	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
> +}
> +
>   /* Common ioctl debug function. This function can be used by
>      external ioctl messages as well as internal V4L ioctl */
>   void v4l_printk_ioctl(unsigned int cmd)
> @@ -297,7 +310,7 @@ void v4l_printk_ioctl(unsigned int cmd)
>   			type = "v4l2";
>   			break;
>   		}
> -		printk("%s", v4l2_ioctls[_IOC_NR(cmd)]);
> +		printk("%s", v4l2_ioctls[_IOC_NR(cmd)].name);
>   		return;
>   	default:
>   		type = "unknown";
> @@ -1948,9 +1961,9 @@ static long __video_do_ioctl(struct file *file,
>   				vfd->v4l2_dev->name);
>   		break;
>   	}
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
>   	case VIDIOC_DBG_G_REGISTER:
>   	{
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>   		struct v4l2_dbg_register *p = arg;
>
>   		if (ops->vidioc_g_register) {
> @@ -1959,10 +1972,12 @@ static long __video_do_ioctl(struct file *file,
>   			else
>   				ret = ops->vidioc_g_register(file, fh, p);
>   		}
> +#endif
>   		break;
>   	}
>   	case VIDIOC_DBG_S_REGISTER:
>   	{
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>   		struct v4l2_dbg_register *p = arg;
>
>   		if (ops->vidioc_s_register) {
> @@ -1971,9 +1986,9 @@ static long __video_do_ioctl(struct file *file,
>   			else
>   				ret = ops->vidioc_s_register(file, fh, p);
>   		}
> +#endif
>   		break;
>   	}
> -#endif
>   	case VIDIOC_DBG_G_CHIP_IDENT:
>   	{
>   		struct v4l2_dbg_chip_ident *p = arg;
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 96d2221..0da84dc 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -128,6 +128,7 @@ struct video_device
>   	const struct v4l2_ioctl_ops *ioctl_ops;
>
>   	/* serialization lock */
> +	DECLARE_BITMAP(dont_use_lock, BASE_VIDIOC_PRIVATE);
>   	struct mutex *lock;
>   };
>
> @@ -173,6 +174,16 @@ void video_device_release(struct video_device *vdev);
>      a dubious construction at best. */
>   void video_device_release_empty(struct video_device *vdev);
>
> +/* returns true if cmd is a valid V4L2 ioctl */
> +bool v4l2_is_valid_ioctl(unsigned int cmd);
> +
> +/* mark that this command shouldn't use core locking */
> +static inline void v4l2_dont_use_lock(struct video_device *vdev, unsigned int cmd)
> +{
> +	if (_IOC_NR(cmd)<  BASE_VIDIOC_PRIVATE)
> +		set_bit(_IOC_NR(cmd), vdev->dont_use_lock);
> +}
> +
>   /* helper functions to access driver private data. */
>   static inline void *video_get_drvdata(struct video_device *vdev)
>   {
