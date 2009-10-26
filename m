Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:48610 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbZJZJHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 05:07:55 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9Q97uwF009752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 04:07:59 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id n9Q97uKE010198
	for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 14:37:56 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 26 Oct 2009 14:37:55 +0530
Subject: RE: [PATCH 5/6] Davinci VPFE Capture: Add support for Control ioctls
Message-ID: <19F8576C6E063C45BE387C64729E73940436E5F410@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1255446614-16847-1-git-send-email-hvaibhav@ti.com>
 <19F8576C6E063C45BE387C64729E73940436DB2130@dbde02.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE4015555F56A@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015555F56A@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Karicheri, Muralidharan
> Sent: Friday, October 16, 2009 7:53 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Subject: RE: [PATCH 5/6] Davinci VPFE Capture: Add support for
> Control ioctls
> 
> 
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
> >Sent: Tuesday, October 13, 2009 11:28 AM
> >To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> >Subject: RE: [PATCH 5/6] Davinci VPFE Capture: Add support for
> Control
> >ioctls
> >
> >> -----Original Message-----
> >> From: Hiremath, Vaibhav
> >> Sent: Tuesday, October 13, 2009 8:40 PM
> >> To: linux-media@vger.kernel.org
> >> Cc: Hiremath, Vaibhav
> >> Subject: [PATCH 5/6] Davinci VPFE Capture: Add support for
> Control
> >> ioctls
> >>
> >> From: Vaibhav Hiremath <hvaibhav@ti.com>
> >>
> >> Added support for Control IOCTL,
> >> 	- s_ctrl
> >> 	- g_ctrl
> >> 	- queryctrl
> >>
<snip>


> >> +static int vpfe_queryctrl(struct file *file, void *priv,
> >> +		struct v4l2_queryctrl *qctrl)
> >> +{
> >> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> >> +	struct vpfe_subdev_info *sdinfo;
> >> +	int ret = 0;
> >> +
> >> +	sdinfo = vpfe_dev->current_subdev;
> >> +
> >> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> >> >grp_id,
> >> +					 core, queryctrl, qctrl);
> >> +
> >> +	if (ret)
> >> +		qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
> What is this for ? 
[Hiremath, Vaibhav] This is an error indication from driver to application other than supported id. Ideally as per V4L2 spec driver returns error -EINVAL for invalid id. The usage of this flag is to skip a predefined or private control which is not possible with -EINVAL return.



> Why don't we return error to user instead. I see
> there is a function v4l2_ctrl_check() in the v4l2 core which
> translates this to -EINVAL. So better to return an -EINVAL to user
> instead IMO. I am ok with rest of the changes.
[Hiremath, Vaibhav] Yes definitely the patch has typo mistake, it should have been "return ret" instead of 0. Application will iterate infinitely with this, which is wrong.

Thanks for pointing me to this error. I will repost the patch with this fix.

Thanks,
Vaibhav
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int vpfe_g_ctrl(struct file *file, void *priv, struct
> >> v4l2_control *ctrl)
> >> +{
> >> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> >> +	struct vpfe_subdev_info *sdinfo;
> >> +
> >> +	sdinfo = vpfe_dev->current_subdev;
> >> +
> >> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> >> >grp_id,
> >> +					 core, g_ctrl, ctrl);
> >> +}
> >> +
> >> +static int vpfe_s_ctrl(struct file *file, void *priv, struct
> >> v4l2_control *ctrl)
> >> +{
> >> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> >> +	struct vpfe_subdev_info *sdinfo;
> >> +
> >> +	sdinfo = vpfe_dev->current_subdev;
> >> +
> >> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo-
> >> >grp_id,
> >> +					 core, s_ctrl, ctrl);
> >> +}
> >> +
> >>  /*
> >>   *  Videobuf operations
> >>   */
> >> @@ -1939,6 +1979,9 @@ static const struct v4l2_ioctl_ops
> >> vpfe_ioctl_ops = {
> >>  	.vidioc_querystd	 = vpfe_querystd,
> >>  	.vidioc_s_std		 = vpfe_s_std,
> >>  	.vidioc_g_std		 = vpfe_g_std,
> >> +	.vidioc_queryctrl	 = vpfe_queryctrl,
> >> +	.vidioc_g_ctrl		 = vpfe_g_ctrl,
> >> +	.vidioc_s_ctrl		 = vpfe_s_ctrl,
> >>  	.vidioc_reqbufs		 = vpfe_reqbufs,
> >>  	.vidioc_querybuf	 = vpfe_querybuf,
> >>  	.vidioc_qbuf		 = vpfe_qbuf,
> >> --
> >> 1.6.2.4
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html

