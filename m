Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4126 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZKFGdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 01:33:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH V2] Davinci VPFE Capture: Add support for Control ioctls
Date: Fri, 6 Nov 2009 07:33:23 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <hvaibhav@ti.com> <200911051718.20801.hverkuil@xs4all.nl> <19F8576C6E063C45BE387C64729E73940436F93B41@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436F93B41@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911060733.23738.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 06 November 2009 06:30:42 Hiremath, Vaibhav wrote:
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Hans Verkuil
> > Sent: Thursday, November 05, 2009 9:48 PM
> > To: Hiremath, Vaibhav
> > Cc: linux-media@vger.kernel.org
> > Subject: Re: [PATCH V2] Davinci VPFE Capture: Add support for
> > Control ioctls
> > 
> > On Thursday 29 October 2009 07:51:04 hvaibhav@ti.com wrote:
> > > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > >
> > > Added support for Control IOCTL,
> > > 	- s_ctrl
> > > 	- g_ctrl
> > > 	- queryctrl
> > >
> > > Change from last patch:
> > > 	- added room for error return in queryctrl function.
> > >
> > > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > > ---
> > >  drivers/media/video/davinci/vpfe_capture.c |   43
> > ++++++++++++++++++++++++++++
> > >  1 files changed, 43 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/media/video/davinci/vpfe_capture.c
> > b/drivers/media/video/davinci/vpfe_capture.c
> > > index abe21e4..8275d02 100644
> > > --- a/drivers/media/video/davinci/vpfe_capture.c
> > > +++ b/drivers/media/video/davinci/vpfe_capture.c
> > > @@ -1368,6 +1368,46 @@ static int vpfe_g_std(struct file *file,
> > void *priv, v4l2_std_id *std_id)
> > >  	return 0;
> > >  }
> > >
> > > +static int vpfe_queryctrl(struct file *file, void *priv,
> > > +		struct v4l2_queryctrl *qctrl)
> > > +{
> > > +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> > > +	struct vpfe_subdev_info *sdinfo;
> > > +	int ret = 0;
> > > +
> > > +	sdinfo = vpfe_dev->current_subdev;
> > > +
> > > +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> > >grp_id,
> > > +					 core, queryctrl, qctrl);
> > > +
> > > +	if (ret)
> > > +		qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
> > 
> > Please remove this bogus flag. Just do:
> > 
> [Hiremath, Vaibhav] Hans, while implementing this ioctl I was also thinking the same, but v4l2_ctrl_check do check this flag and also in V4L2 spec it has been mentioned that 
> "This control is permanently disabled and should be ignored by the application."
> 
> So I thought this may be useful for standard applications, we still have some drivers do use this flag actually.

The use of this flag is for very specific cases as is documented in a footnote
in the v4l2 spec:

"V4L2_CTRL_FLAG_DISABLED was intended for two purposes: Drivers can skip predefined
controls not supported by the hardware (although returning EINVAL would do as well),
or disable predefined and private controls after hardware detection without the
trouble of reordering control arrays and indices (EINVAL cannot be used to skip
private controls because it would prematurely end the enumeration)."

In both cases you would only check for this flag if queryctrl returns 0, so
setting the flag AND returning an error is unnecessary.

Regards,

	Hans

> 
> Thanks,
> Vaibhav
> 
> > 	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> > >grp_id,
> > 				 core, queryctrl, qctrl);
> > 
> > Simple and effective.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int vpfe_g_ctrl(struct file *file, void *priv, struct
> > v4l2_control *ctrl)
> > > +{
> > > +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> > > +	struct vpfe_subdev_info *sdinfo;
> > > +
> > > +	sdinfo = vpfe_dev->current_subdev;
> > > +
> > > +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> > >grp_id,
> > > +					 core, g_ctrl, ctrl);
> > > +}
> > > +
> > > +static int vpfe_s_ctrl(struct file *file, void *priv, struct
> > v4l2_control *ctrl)
> > > +{
> > > +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> > > +	struct vpfe_subdev_info *sdinfo;
> > > +
> > > +	sdinfo = vpfe_dev->current_subdev;
> > > +
> > > +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> > >grp_id,
> > > +					 core, s_ctrl, ctrl);
> > > +}
> > > +
> > >  /*
> > >   *  Videobuf operations
> > >   */
> > > @@ -1939,6 +1979,9 @@ static const struct v4l2_ioctl_ops
> > vpfe_ioctl_ops = {
> > >  	.vidioc_querystd	 = vpfe_querystd,
> > >  	.vidioc_s_std		 = vpfe_s_std,
> > >  	.vidioc_g_std		 = vpfe_g_std,
> > > +	.vidioc_queryctrl	 = vpfe_queryctrl,
> > > +	.vidioc_g_ctrl		 = vpfe_g_ctrl,
> > > +	.vidioc_s_ctrl		 = vpfe_s_ctrl,
> > >  	.vidioc_reqbufs		 = vpfe_reqbufs,
> > >  	.vidioc_querybuf	 = vpfe_querybuf,
> > >  	.vidioc_qbuf		 = vpfe_qbuf,
> > > --
> > > 1.6.2.4
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-
> > media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > 
> > 
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
