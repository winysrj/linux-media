Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33937 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1AXN5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 08:57:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [RFC] ISP lane shifter support
Date: Mon, 24 Jan 2011 14:57:43 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D394675.90304@matrix-vision.de> <201101240110.52703.laurent.pinchart@ideasonboard.com> <4D3D82D8.2010203@matrix-vision.de>
In-Reply-To: <4D3D82D8.2010203@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241457.44866.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Monday 24 January 2011 14:47:04 Michael Jones wrote:
> On 01/24/2011 01:10 AM, Laurent Pinchart wrote:
> > On Friday 21 January 2011 09:40:21 Michael Jones wrote:
> >> Hi all,
> >> 
> >> In the OMAP ISP driver, I'm interested in being able to choose between
> >> 8-bit and 12-bit formats when I have a 12-bit sensor attached.  At the
> >> moment it looks like it's only possible to define this statically with
> >> data_lane_shift in the board definition.  But with the ISP's lane
> >> shifter, it should be possible for the application to ask for 8-bits
> >> although it has a 12-bit sensor attached.
> > 
> > That's right. This would be an interesting feature for the driver. It's
> > also possible to implement this at the input of the video port (but only
> > when forwarding data to the preview engine).
> 
> True, but I do also want the feature available for data written
> directly to memory.
> 
> >> Has anybody already begun implementing this functionality?
> > 
> > Not that I know of.
> > 
> >> One approach that comes to mind is to create a subdev for the
> >> bridge/lane shifter in front of the CCDC, but this also seems a bit
> >> overkill.  Otherwise, perhaps consider the lane shifter a part of the
> >> CCDC and put the code in there?
> > 
> > I would keep the code in isp.c, and call it from ccdc_configure(). It
> > should just be a matter of adding an argument to the function.
> 
> It seems unnecessary to add an arg to ccdc_configure (that's what I
> understood you to mean). It gets isp_ccdc_device, which has all the
> necessary info (pixel format in, which output is active, pixel format
> out).  Seems like I could implement it entirely within
> isp_configure_bridge(). And of course some changes in
> ccdc_[try/set]_format().  This is what I will try to do.
> 
> >> Then ccdc_try_format() would have to check whether the sink pad has a
> >> pixel format which is shiftable to the requested pixel format on the
> >> source pad. A problem with this might be if there are architectures
> >> which have a CCDC but no shifter.
> > 
> > The CCDC module already calls isp_configure_bridge(), so I don't think
> > it's an issue for now. Let's fix the code when (and if) we start using
> > the driver on a platform without a lane shifter.
> 
> Agreed.
> 
> >> Are there other approaches I'm not considering?  Or problems I'm
> >> overlooking?
> > 
> > As the lane shifter is located at the CCDC input, it might be easier to
> > implement support for this using the CCDC input format. ispvideo.c would
> > need to validate the pipeline when the output of the entity connected to
> > the CCDC input (parallel sensor, CCP2 or CSI2) is configured with a
> > format that can be shifted to the format at the CCDC input.
> 
> This crossed my mind, but it seems illogical to have a link with a
> different format at each of its ends.

I agree in theory, but it might be problematic for the CCDC. Right now the 
CCDC can write to memory or send the data to the preview engine, but not both 
at the same time. That's something that I'd like to change in the future. What 
happens if the user then sets differents widths on the output pads ?

> For instance, I think it is a sensible assumption that media-ctl
> automatically sets the format at the remote end of a link if you're setting
> an output pad's format. This is when I thought a subdev of its own would be
> more logically consistent with the media controller framework (although
> overkill).

-- 
Regards,

Laurent Pinchart
