Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2029 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1AYIDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 03:03:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kim HeungJun <riverful@gmail.com>
Subject: Re: [RFC PATCH 03/12] mt9m001: convert to the control framework.
Date: Tue, 25 Jan 2011 09:02:58 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1101222135010.31015@axis700.grange> <EF95014F-3C7A-46E3-B298-032E0CB58D61@gmail.com>
In-Reply-To: <EF95014F-3C7A-46E3-B298-032E0CB58D61@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101250902.58987.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, January 23, 2011 04:38:21 Kim HeungJun wrote:
> Hello,
> 
> I'm reading threads about the new v4l2_ctrl framework and If you don't mind
> I gotta tell you my humble opinion about testing result the new v4l2_ctrl
> framework subdev.
> I have actually similar curcumstance, with I2C subdev M5MOLS Fujitsu device
> which is just send the patch and S5PC210 board for testing this, except not
> using soc_camera framework.
> But, it's maybe helpful to discuss about this changes to everyone.
> 
> 2011. 1. 23., 오전 6:21, Guennadi Liakhovetski 작성:
> 
> > On Wed, 12 Jan 2011, Hans Verkuil wrote:
> > 
> >> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> [snip]
> 
> >> -	case V4L2_CID_EXPOSURE:
> >> -		/* mt9m001 has maximum == default */
> >> -		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
> >> -			return -EINVAL;
> >> -		else {
> >> -			unsigned long range = qctrl->maximum - qctrl->minimum;
> >> -			unsigned long shutter = ((ctrl->value - qctrl->minimum) * 1048 +
> >> +	case V4L2_CID_EXPOSURE_AUTO:
> >> +		/* Force manual exposure if only the exposure was changed */
> >> +		if (!ctrl->has_new)
> >> +			ctrl->val = V4L2_EXPOSURE_MANUAL;
> >> +		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
> >> +			unsigned long range = exp->maximum - exp->minimum;
> >> +			unsigned long shutter = ((exp->val - exp->minimum) * 1048 +
> >> 						 range / 2) / range + 1;
> >> 
> >> 			dev_dbg(&client->dev,
> >> 				"Setting shutter width from %d to %lu\n",
> >> -				reg_read(client, MT9M001_SHUTTER_WIDTH),
> >> -				shutter);
> >> +				reg_read(client, MT9M001_SHUTTER_WIDTH), shutter);
> >> 			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
> >> 				return -EIO;
> >> -			mt9m001->exposure = ctrl->value;
> >> -			mt9m001->autoexposure = 0;
> >> -		}
> >> -		break;
> >> -	case V4L2_CID_EXPOSURE_AUTO:
> >> -		if (ctrl->value) {
> >> +		} else {
> >> 			const u16 vblank = 25;
> >> 			unsigned int total_h = mt9m001->rect.height +
> >> 				mt9m001->y_skip_top + vblank;
> >> -			if (reg_write(client, MT9M001_SHUTTER_WIDTH,
> >> -				      total_h) < 0)
> >> +
> >> +			if (reg_write(client, MT9M001_SHUTTER_WIDTH, total_h) < 0)
> >> 				return -EIO;
> >> -			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
> >> -			mt9m001->exposure = (524 + (total_h - 1) *
> >> -				 (qctrl->maximum - qctrl->minimum)) /
> >> -				1048 + qctrl->minimum;
> >> -			mt9m001->autoexposure = 1;
> >> -		} else
> >> -			mt9m001->autoexposure = 0;
> >> -		break;
> >> +			exp->val = (524 + (total_h - 1) *
> >> +					(exp->maximum - exp->minimum)) / 1048 +
> >> +						exp->minimum;
> >> +		}
> >> +		return 0;
> >> 	}
> >> -	return 0;
> >> +	return -EINVAL;
> > 
> > It seems to me, that you've dropped V4L2_CID_EXPOSURE here, was it 
> > intentional? I won't verify this in detail now, because, if it wasn't 
> > intentional and you fix it in v2, I'll have to re-check it anyway. Or is 
> > it supposed to be handled by that V4L2_EXPOSURE_MANUAL? So, if the user 
> > issues a V4L2_CID_EXPOSURE, are you getting V4L2_CID_EXPOSURE_AUTO with 
> > val == V4L2_EXPOSURE_MANUAL instead? Weird...
> 
> I also wonder first at this part for a long time like below:
> 
> 1. when calling V4L2_CID_EXPOSURE_AUTO with V4L2_EXPOSURE_AUTO, it's ok.
> 2. when calling V4L2_CID_EXPOSURE_AUTO with V4L2_EXPOSURE_MANUAL, it's
> also ok.
> 3. when calling V4L2_CID_EXPOSURE? where the device handle this CID?
> 
> but, after testing with application step by step, I finally know below:
> when calling V4L2_CID_EXPOSURE, changing internal(v4l2_ctrl framework) variable,
> exactly struct v4l2_ctrl exposure, which is register for probing time by
> V4L2_CID_EXPOSURE, and clustered with struct v4l2_ctrl autoexposure. So, when
> the device no needs to handle this values, but it automatically calls control clustered with
> itself, in this case the V4L2_CID_EXPOSURE calls(just words)V4L2_CID_EXPOSURE_AUTO.
> 
> So, the my POV is that foo clustered with auto_foo calls auto_foo with foo's characteristics.  

Correct. This tells me two things: 1) nobody ever reads documentation, and 2) I
must place a comment in the code making people aware that the V4L2_CID_EXPOSURE_AUTO
case will handle all controls in the cluster.

Regards,

	Hans

> 
> But, Hans probably would do more clear answer.
> 
> Regards,
> Heungjun Kim
> 
>   --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
