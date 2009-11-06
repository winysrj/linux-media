Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59326 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZKFGgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 01:36:39 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 6 Nov 2009 12:06:35 +0530
Subject: RE: [PATCH V2] Davinci VPFE Capture: Add support for Control ioctls
Message-ID: <19F8576C6E063C45BE387C64729E73940436F93B87@dbde02.ent.ti.com>
References: <hvaibhav@ti.com> <200911051718.20801.hverkuil@xs4all.nl>
 <19F8576C6E063C45BE387C64729E73940436F93B41@dbde02.ent.ti.com>
 <200911060733.23738.hverkuil@xs4all.nl>
In-Reply-To: <200911060733.23738.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Friday, November 06, 2009 12:03 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org
> Subject: Re: [PATCH V2] Davinci VPFE Capture: Add support for
> Control ioctls
> 
> On Friday 06 November 2009 06:30:42 Hiremath, Vaibhav wrote:
> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > owner@vger.kernel.org] On Behalf Of Hans Verkuil
> > > Sent: Thursday, November 05, 2009 9:48 PM
> > > To: Hiremath, Vaibhav
> > > Cc: linux-media@vger.kernel.org
> > > Subject: Re: [PATCH V2] Davinci VPFE Capture: Add support for
> > > Control ioctls
> > >
> > > On Thursday 29 October 2009 07:51:04 hvaibhav@ti.com wrote:
<snip>
> > >
> > > Please remove this bogus flag. Just do:
> > >
> > [Hiremath, Vaibhav] Hans, while implementing this ioctl I was also
> thinking the same, but v4l2_ctrl_check do check this flag and also
> in V4L2 spec it has been mentioned that
> > "This control is permanently disabled and should be ignored by the
> application."
> >
> > So I thought this may be useful for standard applications, we
> still have some drivers do use this flag actually.
> 
> The use of this flag is for very specific cases as is documented in
> a footnote
> in the v4l2 spec:
> 
> "V4L2_CTRL_FLAG_DISABLED was intended for two purposes: Drivers can
> skip predefined
> controls not supported by the hardware (although returning EINVAL
> would do as well),
> or disable predefined and private controls after hardware detection
> without the
> trouble of reordering control arrays and indices (EINVAL cannot be
> used to skip
> private controls because it would prematurely end the enumeration)."
> 
> In both cases you would only check for this flag if queryctrl
> returns 0, so
> setting the flag AND returning an error is unnecessary.
> 
[Hiremath, Vaibhav] Make sense. I will update the patch and submit it again.

Thanks,
Vaibhav

> Regards,
> 
> 	Hans
> 
> >
> > Thanks,
> > Vaibhav
> >
> > > 	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> > > >grp_id,
> > > 				 core, queryctrl, qctrl);
> > >
> > > Simple and effective.
> > >
> > > Regards,
> > >
> > > 	Hans
> > >
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int vpfe_g_ctrl(struct file *file, void *priv, struct
> > > v4l2_control *ctrl)
> > > > +{
> > > > +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> > > > +	struct vpfe_subdev_info *sdinfo;
> > > > +
> > > > +	sdinfo = vpfe_dev->current_subdev;
> > > > +
> > > > +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> sdinfo-
> > > >grp_id,
> > > > +					 core, g_ctrl, ctrl);
> > > > +}
> > > > +
> > > > +static int vpfe_s_ctrl(struct file *file, void *priv, struct
> > > v4l2_control *ctrl)
> > > > +{
> > > > +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> > > > +	struct vpfe_subdev_info *sdinfo;
> > > > +
> > > > +	sdinfo = vpfe_dev->current_subdev;
> > > > +
> > > > +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> sdinfo-
> > > >grp_id,
> > > > +					 core, s_ctrl, ctrl);
> > > > +}
> > > > +
> > > >  /*
> > > >   *  Videobuf operations
> > > >   */
> > > > @@ -1939,6 +1979,9 @@ static const struct v4l2_ioctl_ops
> > > vpfe_ioctl_ops = {
> > > >  	.vidioc_querystd	 = vpfe_querystd,
> > > >  	.vidioc_s_std		 = vpfe_s_std,
> > > >  	.vidioc_g_std		 = vpfe_g_std,
> > > > +	.vidioc_queryctrl	 = vpfe_queryctrl,
> > > > +	.vidioc_g_ctrl		 = vpfe_g_ctrl,
> > > > +	.vidioc_s_ctrl		 = vpfe_s_ctrl,
> > > >  	.vidioc_reqbufs		 = vpfe_reqbufs,
> > > >  	.vidioc_querybuf	 = vpfe_querybuf,
> > > >  	.vidioc_qbuf		 = vpfe_qbuf,
> > > > --
> > > > 1.6.2.4
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe
> linux-
> > > media" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-
> info.html
> > > >
> > >
> > >
> > >
> > > --
> > > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> Telecom
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-
> > > media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-
> info.html
> >
> >
> >
> 
> 
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

