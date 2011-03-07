Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59878 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1CGOC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 09:02:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH 4/4] omap3isp: lane shifter support
Date: Mon, 7 Mar 2011 15:02:47 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de> <201103041733.23754.laurent.pinchart@ideasonboard.com> <4D74B926.3010304@matrix-vision.de>
In-Reply-To: <4D74B926.3010304@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103071502.48141.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Monday 07 March 2011 11:53:26 Michael Jones wrote:
> On 03/04/2011 05:33 PM, Laurent Pinchart wrote:

[snip]

> >> +
> >> +	if (in_info->flavor != out_info->flavor)
> >> +		return 0;
> >> +
> >> +	switch (in_info->bpp - out_info->bpp) {
> >> +	case 2:
> >> +	case 4:
> >> +	case 6:
> >> +		shiftable = 1;
> >> +		break;
> >> +	default:
> >> +		shiftable = 0;
> >> +	}
> > 
> > What about
> > 
> > return in_info->bpp - out_info->bpp <= 6;
> 
> As long as there are never formats which are the same flavor but shifted
> 1, 3, or 5 bits, that's fine.  I suppose this is a safe assumption?

I think so. If we need to add support for those formats later we can revisit 
the code.

> >> +
> >> +	return shiftable;
> >> +}
> >> +
> >> +/*
> >> 
> >>   * Configure the bridge and lane shifter. Valid inputs are
> >>   *
> >>   * CCDC_INPUT_PARALLEL: Parallel interface
> >> 

[snip]

> >> +	/* find CCDC input format */
> >> +	fmt_info = omap3isp_video_format_info
> >> +		(isp->isp_ccdc.formats[CCDC_PAD_SINK].code);
> >> +	depth_out = fmt_info ? fmt_info->bpp : 0;
> >> +
> >> +	isp->isp_ccdc.syncif.datsz = depth_out;
> >> +
> >> +	/* determine necessary shifting */
> >> +	if (depth_in == depth_out + 6)
> >> +		shift = 3;
> >> +	else if (depth_in == depth_out + 4)
> >> +		shift = 2;
> >> +	else if (depth_in == depth_out + 2)
> >> +		shift = 1;
> >> +	else
> >> +		shift = 0;
> > 
> > Maybe shift = (depth_out - depth_in) / 2; ?
> 
> First of all, the other way around: (depth_in - depth_out).  I suppose I
> don't need to account for e.g. (depth_in - depth_out > 6) because then
> the pipeline would've been invalid in the first place?  If I do this, I
> would at least use ISPCTRL_SHIFT_MASK when writing 'shift' into
> ispctrl_val as a final catch if something went wrong with shift.

Sounds good to me.

-- 
Regards,

Laurent Pinchart
