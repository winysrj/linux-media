Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46189 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1CJPc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:32:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH v2 4/4] omap3isp: lane shifter support
Date: Thu, 10 Mar 2011 16:32:47 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299686863-20701-1-git-send-email-michael.jones@matrix-vision.de> <201103101121.40846.laurent.pinchart@ideasonboard.com> <4D78EEA8.7060301@matrix-vision.de>
In-Reply-To: <4D78EEA8.7060301@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101632.49187.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Thursday 10 March 2011 16:30:48 Michael Jones wrote:
> On 03/10/2011 11:21 AM, Laurent Pinchart wrote:
> > Hi Michael,
> 
> [snip]
> 
> > I've had a closer look at the boards I have here, and it turns out one of
> > them connects a 10-bit sensor to DATA[11:2] :-/ data_lane_shift is thus
> > needed for it.
> > 
> > I'm fine with leaving data_lane_shift out of this patch, but can you
> > submit a second patch to add it back ? I'd rather avoid applying a patch
> > that breaks one of my boards and then have to fix it myself :-)
> 
> OK, but in that case I'd rather incorporate it into this last patch than
> introduce a new patch for it.  I don't think it will be very complex and
> they logically belong together.  I had just been hoping to avoid
> implementing it altogether.

As you wish. You can also submit two patches and then squash them together if 
it makes it simpler to develop/review the code.

-- 
Regards,

Laurent Pinchart
