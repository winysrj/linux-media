Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38207 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbbGPIKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 04:10:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v3 04/19] media/usb/uvc: Implement vivioc_g_def_ext_ctrls
Date: Thu, 16 Jul 2015 11:11:18 +0300
Message-ID: <3162887.2tIlvOM8NK@avalon>
In-Reply-To: <55A75F63.1020304@xs4all.nl>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com> <2206042.E86xyoYRaG@avalon> <55A75F63.1020304@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 16 July 2015 09:38:11 Hans Verkuil wrote:
> On 07/15/15 23:05, Laurent Pinchart wrote:
> > On Friday 12 June 2015 18:46:23 Ricardo Ribalda Delgado wrote:
> >> Callback needed by ioctl VIDIOC_G_DEF_EXT_CTRLS as this driver does not
> >> use the controller framework.
> >> 
> >> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> >> ---
> >> 
> >>  drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++++++++++
> >>  1 file changed, 30 insertions(+)
> >> 
> >> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> >> b/drivers/media/usb/uvc/uvc_v4l2.c index 2764f43607c1..e2698a77138a
> >> 100644
> >> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> >> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> >> @@ -1001,6 +1001,35 @@ static int uvc_ioctl_g_ext_ctrls(struct file
> >> *file, void *fh,
> >>  	return uvc_ctrl_rollback(handle);
> >>  }
> >> 
> >> +static int uvc_ioctl_g_def_ext_ctrls(struct file *file, void *fh,
> >> +				     struct v4l2_ext_controls *ctrls)
> >> +{
> >> +	struct uvc_fh *handle = fh;
> >> +	struct uvc_video_chain *chain = handle->chain;
> >> +	struct v4l2_ext_control *ctrl = ctrls->controls;
> >> +	unsigned int i;
> >> +	int ret;
> >> +	struct v4l2_queryctrl qc;
> >> +
> >> +	ret = uvc_ctrl_begin(chain);
> > 
> > There's no need to call uvc_ctrl_begin() here (and if there was, you'd
> > have to call uvc_ctrl_rollback() or uvc_ctrl_commit() before returning).
> > 
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
> >> +		qc.id = ctrl->id;
> >> +		ret = uvc_query_v4l2_ctrl(chain, &qc);
> >> +		if (ret < 0) {
> >> +			ctrls->error_idx = i;
> >> +			return ret;
> >> +		}
> >> +		ctrl->value = qc.default_value;
> >> +	}
> >> +
> >> +	ctrls->error_idx = 0;
> >> +
> >> +	return 0;
> >> +}
> > 
> > Instead of open-coding this in multiple drivers, how about adding a helper
> > function to the core ? Something like (totally untested)
> 
> It's only open-coded in drivers that do not use the control framework. For
> drivers that use the control framework it is completely transparent.

Sure, but still, the same function is implemented several times while a single 
implementation could do. I'd prefer having it in the core until all (or all 
but one) drivers are converted to the control framework.

> > int v4l2_ioctl_g_def_ext_ctrls(struct file *file, void *fh,
> >                                struct v4l2_ext_controls *ctrls)
> > {
> > 	struct video_device *vdev = video_devdata(file);
> > 	unsigned int i;
> > 	int ret;
> > 	
> > 	for (i = 0; i < ctrls->count; ++i) {
> > 		struct v4l2_queryctrl qc;
> > 		
> > 		qc.id = ctrl->id;
> > 		ret = vdev->ioctl_ops->vidioc_queryctrl(file, fh, &qc);
> > 		if (ret < 0) {
> > 			ctrls->error_idx = i;
> > 			return ret;
> > 		}
> > 		ctrls->controls[i].value = qc.default_value;
> > 	}
> > 	ctrls->error_idx = 0;
> > 	
> > 	return 0;
> > }
> > 
> > The function could be called by v4l_g_def_ext_ctrls() when ops->
> > vidioc_g_def_ext_ctrls is NULL.

-- 
Regards,

Laurent Pinchart

