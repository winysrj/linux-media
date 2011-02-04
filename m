Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1560 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1BDKM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 05:12:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v6 7/7] v4l: subdev: Events support
Date: Fri, 4 Feb 2011 11:12:14 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1296131338-29892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131338-29892-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131338-29892-8-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102041112.14105.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, January 27, 2011 13:28:58 Laurent Pinchart wrote:
> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> Provide v4l2_subdevs with v4l2_event support. Subdev drivers only need very
> little to support events.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> Signed-off-by: David Cohen <david.cohen@nokia.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |   18 ++++++
>  drivers/media/video/v4l2-subdev.c            |   75 +++++++++++++++++++++++++-
>  include/media/v4l2-subdev.h                  |   10 ++++
>  3 files changed, 102 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index f683f63..4db1def 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -352,6 +352,24 @@ VIDIOC_TRY_EXT_CTRLS
>  	controls can be also be accessed through one (or several) V4L2 device
>  	nodes.
>  
> +VIDIOC_DQEVENT
> +VIDIOC_SUBSCRIBE_EVENT
> +VIDIOC_UNSUBSCRIBE_EVENT
> +
> +	The events ioctls are identical to the ones defined in V4L2. They
> +	behave identically, with the only exception that they deal only with
> +	events generated by the sub-device. Depending on the driver, those
> +	events can also be reported by one (or several) V4L2 device nodes.
> +
> +	Sub-device drivers that want to use events need to set the
> +	V4L2_SUBDEV_USES_EVENTS v4l2_subdev::flags and initialize
> +	v4l2_subdev::nevents to events queue depth before registering the
> +	sub-device. After registration events can be queued as usual on the
> +	v4l2_subdev::devnode device node.
> +
> +	To properly support events, the poll() file operation is also
> +	implemented.
> +
>  
>  I2C sub-device drivers
>  ----------------------
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index fc57ce7..fbccefd 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -20,27 +20,69 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> -#include <linux/types.h>
>  #include <linux/ioctl.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
>  #include <linux/videodev2.h>
>  
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-event.h>
>  
>  static int subdev_open(struct file *file)
>  {
>  	struct video_device *vdev = video_devdata(file);
>  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> +	struct v4l2_fh *vfh;
> +	int ret;
>  
>  	if (!sd->initialized)
>  		return -EAGAIN;
>  
> +	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
> +		vfh = kzalloc(sizeof(*vfh), GFP_KERNEL);
> +		if (vfh == NULL)
> +			return -ENOMEM;
> +
> +		ret = v4l2_fh_init(vfh, vdev);
> +		if (ret)
> +			goto err;
> +
> +		ret = v4l2_event_init(vfh);
> +		if (ret)
> +			goto err;
> +
> +		ret = v4l2_event_alloc(vfh, sd->nevents);
> +		if (ret)
> +			goto err;
> +
> +		v4l2_fh_add(vfh);
> +		file->private_data = vfh;
> +	}
> +
>  	return 0;
> +
> +err:
> +	if (vfh != NULL) {
> +		v4l2_fh_exit(vfh);
> +		kfree(vfh);
> +	}
> +
> +	return ret;
>  }
>  
>  static int subdev_close(struct file *file)
>  {
> +	struct v4l2_fh *vfh = file->private_data;
> +
> +	if (vfh != NULL) {
> +		v4l2_fh_del(vfh);
> +		v4l2_fh_exit(vfh);
> +		kfree(vfh);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -48,6 +90,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  {
>  	struct video_device *vdev = video_devdata(file);
>  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> +	struct v4l2_fh *fh = file->private_data;
>  
>  	switch (cmd) {
>  	case VIDIOC_QUERYCTRL:
> @@ -71,6 +114,18 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	case VIDIOC_TRY_EXT_CTRLS:
>  		return v4l2_subdev_try_ext_ctrls(sd, arg);
>  
> +	case VIDIOC_DQEVENT:
> +		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
> +			return -ENOIOCTLCMD;
> +
> +		return v4l2_event_dequeue(fh, arg, file->f_flags & O_NONBLOCK);
> +
> +	case VIDIOC_SUBSCRIBE_EVENT:
> +		return v4l2_subdev_call(sd, core, subscribe_event, fh, arg);
> +
> +	case VIDIOC_UNSUBSCRIBE_EVENT:
> +		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
> +
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> @@ -84,11 +139,29 @@ static long subdev_ioctl(struct file *file, unsigned int cmd,
>  	return __video_usercopy(file, cmd, arg, subdev_do_ioctl);
>  }
>  
> +static unsigned int subdev_poll(struct file *file, poll_table *wait)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> +	struct v4l2_fh *fh = file->private_data;
> +
> +	if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
> +		return POLLERR;
> +
> +	poll_wait(file, &fh->events->wait, wait);
> +
> +	if (v4l2_event_pending(fh))
> +		return POLLPRI;
> +
> +	return 0;
> +}
> +
>  const struct v4l2_file_operations v4l2_subdev_fops = {
>  	.owner = THIS_MODULE,
>  	.open = subdev_open,
>  	.unlocked_ioctl = subdev_ioctl,
>  	.release = subdev_close,
> +	.poll = subdev_poll,
>  };
>  
>  void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 90022f5..68cbe48 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -37,6 +37,8 @@
>  
>  struct v4l2_device;
>  struct v4l2_ctrl_handler;
> +struct v4l2_event_subscription;
> +struct v4l2_fh;
>  struct v4l2_subdev;
>  struct tuner_setup;
>  
> @@ -165,6 +167,10 @@ struct v4l2_subdev_core_ops {
>  	int (*s_power)(struct v4l2_subdev *sd, int on);
>  	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
>  						u32 status, bool *handled);
> +	int (*subscribe_event)(struct v4l2_subdev *sd, struct v4l2_fh *fh,
> +			       struct v4l2_event_subscription *sub);
> +	int (*unsubscribe_event)(struct v4l2_subdev *sd, struct v4l2_fh *fh,
> +				 struct v4l2_event_subscription *sub);
>  };
>  
>  /* s_mode: switch the tuner to a specific tuner mode. Replacement of s_radio.
> @@ -424,6 +430,8 @@ struct v4l2_subdev_ops {
>  #define V4L2_SUBDEV_FL_IS_SPI			(1U << 1)
>  /* Set this flag if this subdev needs a device node. */
>  #define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
> +/* Set this flag if this subdev generates events. */
> +#define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)

Do we need this flag...

>  
>  /* Each instance of a subdev driver should create this struct, either
>     stand-alone or embedded in a larger struct.
> @@ -446,6 +454,8 @@ struct v4l2_subdev {
>  	/* subdev device node */
>  	struct video_device devnode;
>  	unsigned int initialized;
> +	/* number of events to be allocated on open */
> +	unsigned int nevents;

...when we have this field? We could just test whether nevents > 0.

>  };
>  
>  #define vdev_to_v4l2_subdev(vdev) \
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
