Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33718 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1CJKVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 05:21:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH v2 4/4] omap3isp: lane shifter support
Date: Thu, 10 Mar 2011 11:21:39 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299686863-20701-1-git-send-email-michael.jones@matrix-vision.de> <201103100113.25952.laurent.pinchart@ideasonboard.com> <4D78A390.8040500@matrix-vision.de>
In-Reply-To: <4D78A390.8040500@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101121.40846.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Thursday 10 March 2011 11:10:24 Michael Jones wrote:
> Hi Laurent,
> 
> Thanks for the review.  Most of your suggestions didn't warrant
> discussion and I will incorporate those changes.  The others are below.
> 
> On 03/10/2011 01:13 AM, Laurent Pinchart wrote:
> > On Wednesday 09 March 2011 17:07:43 Michael Jones wrote:
> >> To use the lane shifter, set different pixel formats at each end of
> >> the link at the CCDC input.
> >> 
> >> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> > 
> > [snip]
> > 
> >> diff --git a/drivers/media/video/omap3-isp/isp.h
> >> b/drivers/media/video/omap3-isp/isp.h index 21fa88b..3d13f8b 100644
> >> --- a/drivers/media/video/omap3-isp/isp.h
> >> +++ b/drivers/media/video/omap3-isp/isp.h
> >> @@ -144,8 +144,6 @@ struct isp_reg {
> >> 
> >>   *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
> >>   */
> >>  
> >>  struct isp_parallel_platform_data {
> >> 
> >> -	unsigned int width;
> >> -	unsigned int data_lane_shift:2;
> > 
> > I'm afraid you can't remove the data_lane_shift field completely. Board
> > can wire a 8 bits sensor to DATA[9:2] :-/ That needs to be taken into
> > account as well when computing the total shift value.
> > 
> > Hardware configuration can be done by adding the requested shift value to
> > data_lane_shift for parallel sensors in omap3isp_configure_bridge(), but
> > we also need to take it into account when validating the pipeline.
> > 
> > I'm not aware of any board requiring data_lane_shift at the moment
> > though, so we could just drop it now and add it back later when needed.
> > This will avoid making this patch more complex.
> 
> I'm in favor of leaving it as is for now and adding it back when needed.
>  It's a good point, and I do think it should be supported in the long
> run, but it'd be nice to not have to worry about it for this patch.  Is
> it OK with you to leave 'data_lane_shift' out for now?

I've had a closer look at the boards I have here, and it turns out one of them 
connects a 10-bit sensor to DATA[11:2] :-/ data_lane_shift is thus needed for 
it.

I'm fine with leaving data_lane_shift out of this patch, but can you submit a 
second patch to add it back ? I'd rather avoid applying a patch that breaks 
one of my boards and then have to fix it myself :-)

> >>  	unsigned int clk_pol:1;
> >>  	unsigned int bridge:4;
> >>  
> >>  };

-- 
Regards,

Laurent Pinchart
