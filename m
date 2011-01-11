Return-path: <mchehab@pedra>
Received: from smtp-roam1.Stanford.EDU ([171.67.219.88]:34140 "EHLO
	smtp-roam.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932345Ab1AKTNf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 14:13:35 -0500
Message-ID: <4D2CAA4C.7060803@stanford.edu>
Date: Tue, 11 Jan 2011 11:06:52 -0800
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] Cropping and scaling with subdev pad-level operations
References: <201101061633.30029.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101061633.30029.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 1/6/2011 7:33 AM, Laurent Pinchart wrote:
> Hi everybody,
...
> The OMAP3 ISP resizer currently implements the second option, and I'll modify
> it to implement the first option. The drawback is that some crop/output
> combinations will require an extra step to be achieved. I'd like your opinion
> on this issue. Is the behaviour described in option one acceptable ? Should
> the API be extended/modified to make it simpler for applications to configure
> the various sizes in the image pipeline ? Are we all doomed and will we have
> to use a crop/scale API that nobody will ever understand ? :-)
>
I'm personally a big fan of having some way to atomically set multiple 
settings at once, exactly to avoid these sorts of problems. The 
fundamental problem here is that the interface implicitly assumes that 
every intermediate state has to be a valid one, when during device 
configuration most states are transitory because the application hasn't 
finished configuring the pipeline/sensor/etc, and the state shouldn't 
get vetted and adjusted until the configuration is complete.  The 
VIDOC_S_EXT_CTRLS seems like a reasonable solution - can't something 
like that apply to the subdev interfaces? (Or am I missing something 
beyond that?)

Similar issues have cropped up for us with other interdependent settings 
like exposure time/frame duration, or the cropping/scaling options found 
directly on the mt9p031 sensor, which are quite analogous to your issue 
- there's 1-4x scaling and a selectable ROI, which interact, especially 
during streaming when a constant output size has to be maintained.  What 
I ended up doing was effectively hacking in an atomic control update 
procedure for the old v4l2_int_device stuff (very hacky), but then I 
didn't have to worry about it any more.

In general, I'd be worried if executing the same stream of control 
updates in a different order gave a different final result.  With atomic 
updates, you'd still have to decide how to round to the closest valid 
state, but at least it'd be consistent.

Regards,

Eino-Ville Talvala
Stanford University
