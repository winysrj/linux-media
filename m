Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33573 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1BHMPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 07:15:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v5 0/5] OMAP3 ISP driver
Date: Tue, 8 Feb 2011 13:15:37 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1296131541-30092-1-git-send-email-laurent.pinchart@ideasonboard.com> <201102041255.50253.hverkuil@xs4all.nl>
In-Reply-To: <201102041255.50253.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081315.38314.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the review.

On Friday 04 February 2011 12:55:50 Hans Verkuil wrote:
> On Thursday, January 27, 2011 13:32:16 Laurent Pinchart wrote:
> > Hi everybody,
> > 
> > Here's the fifth version of the OMAP3 ISP driver patches, updated to
> > 2.6.37 and the latest changes in the media controller and sub-device
> > APIs.
> 
> Hmm, patch 5/5 is missing. It's probably too big.

Yes it is. I forgot to mention that in the cover letter.

> Anyway, I got the patch from your git tree and did a review. It's always
> hard to review over 21000 lines of driver code :-), so I limited myself to
> the V4L2 API parts. I can't really comment on the OMAP3 specific parts
> anyway.
> 
> The first issue I found was related to controls: it seems you set up
> control handlers for subdevs that don't have any controls. You can just
> leave sd->ctrl_handler to NULL in that case and you don't need to use a
> control handler at all.

OK. It was a leftover.

> There is also no need to set the core ctrl ops:
> 
> +       .queryctrl = v4l2_subdev_queryctrl,
> +       .querymenu = v4l2_subdev_querymenu,
> +       .g_ctrl = v4l2_subdev_g_ctrl,
> +       .s_ctrl = v4l2_subdev_s_ctrl,
> +       .g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> +       .try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> +       .s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> 
> These are only necessary if the master driver doesn't use the control
> framework but called core.queryctrl directly. That shouldn't be the case
> for this driver.

OK.

> What isn't clear to me is whether the /dev/videoX nodes should give access
> to the subdev controls as well. As far as I can see the ctrl_handler
> pointer of neither v4l2_device nor video_device is ever set, so that means
> that the controls are only accessible through /dev/v4l-subdevX.
> 
> I'm not sure whether that is intentional or not.

It's intentional.

> The other comment I have is regarding include/linux/omap3isp.h: both the
> ioctls and the events need to be documented there. A one-liner for each is
> probably enough. I also see that struct omap3isp_stat_data has a deprecated
> field: perhaps when creating the final pull request the time is right to
> remove it?

OK.

> Finally, I noticed that OMAP3 has its own implementation of videobuf. Are
> there plans to move to vb2?

Yes, but not before 2.6.39 :-)

-- 
Regards,

Laurent Pinchart
