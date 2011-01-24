Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40239 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1AXAKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 19:10:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [RFC] ISP lane shifter support
Date: Mon, 24 Jan 2011 01:10:52 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D394675.90304@matrix-vision.de>
In-Reply-To: <4D394675.90304@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101240110.52703.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Friday 21 January 2011 09:40:21 Michael Jones wrote:
> Hi all,
> 
> In the OMAP ISP driver, I'm interested in being able to choose between
> 8-bit and 12-bit formats when I have a 12-bit sensor attached.  At the
> moment it looks like it's only possible to define this statically with
> data_lane_shift in the board definition.  But with the ISP's lane
> shifter, it should be possible for the application to ask for 8-bits
> although it has a 12-bit sensor attached.

That's right. This would be an interesting feature for the driver. It's also 
possible to implement this at the input of the video port (but only when 
forwarding data to the preview engine).

> Has anybody already begun implementing this functionality?

Not that I know of.

> One approach that comes to mind is to create a subdev for the
> bridge/lane shifter in front of the CCDC, but this also seems a bit
> overkill.  Otherwise, perhaps consider the lane shifter a part of the
> CCDC and put the code in there?

I would keep the code in isp.c, and call it from ccdc_configure(). It should 
just be a matter of adding an argument to the function.

> Then ccdc_try_format() would have to check whether the sink pad has a pixel
> format which is shiftable to the requested pixel format on the source pad. 
> A problem with this might be if there are architectures which have a CCDC
> but no shifter.

The CCDC module already calls isp_configure_bridge(), so I don't think it's an 
issue for now. Let's fix the code when (and if) we start using the driver on a 
platform without a lane shifter.

> Are there other approaches I'm not considering?  Or problems I'm
> overlooking?

As the lane shifter is located at the CCDC input, it might be easier to 
implement support for this using the CCDC input format. ispvideo.c would need 
to validate the pipeline when the output of the entity connected to the CCDC 
input (parallel sensor, CCP2 or CSI2) is configured with a format that can be 
shifted to the format at the CCDC input.

> Also- it looks like the CCDC now supports writing 12-bit bayer
> data to memory.  Is that true?

That's correct. It will support 8-bit grey data soon (patches have been 
submitted internally already).

-- 
Regards,

Laurent Pinchart
