Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:40734 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753333Ab0J1TAo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 15:00:44 -0400
Date: Thu, 28 Oct 2010 21:01:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Adam Sutton <aps@plextek.co.uk>
cc: linux-media@vger.kernel.org
Subject: Re: Changing frame size on the fly in SOC module
In-Reply-To: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF331B@plextek3.plextek.lan>
Message-ID: <Pine.LNX.4.64.1010282009160.1257@axis700.grange>
References: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF331B@plextek3.plextek.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Adam

On Thu, 28 Oct 2010, Adam Sutton wrote:

> Hi,
> 
> Sometime ago I developed an SOC based camera driver for my platform
> (ov7675 on iMX25), for the most part it seems to be working well however
> at the time I couldn't manage to change the frame size on the fly
> (without closing / re-opening the device).
> 
> The current problem I have is that my application needs to display a
> 320x240 preview image on screen, but to capture a static image at
> 640x480. I can do this as long as I close the device in between,
> unfortunately for power consumption reasons the camera device is put
> into a low power state whenever the device is released. This means that
> the image capture takes approx 1.5s (the requirement I have to meet is
> 1s).
> 
> Now I could cheat and simply subsample (in software) the 640x480 image,
> but that puts additional burden on an already overworked MCU.
> 
> Having been through the soc_camera and videobuf code and as far as I can
> tell this inability to change the frame size without closing the camera
> device appears to be a design decision.

Yes, it is.

> What I'm really after is confirmation one way of the other. If it's not,
> what is the correct process to achieve the frame change without closing
> the device. And if it is, does anybody have any suggestions of possible
> workarounds?

It has been decided that way, because we didn't have a good use-case for 
changing the frame format on-the-fly to develop for and to test with. You 
seem to have one now, so, go ahead;)

There are a couple of issues to address though - videobuffer configuration 
is one of them, host reconfiguration is the other one, possible multiple 
simultaneous users is the third one (ok, only one of them will be actually 
streaming).

This use case - different size preview and single shot capture has come up 
a couple of times before, but noone has brought it to a proper mainstream 
solution.

One thing you'd still want to do, I think, is to stop streaming before 
reconfiguring, and restart it afterwards.

So, maybe a viable solution would be:

in soc_camera_s_fmt_vid_cap() check not just for "icf->vb_vidq.bufs[0] != 
NULL", but rather for if streaming is not running, and then someone will 
certainly have to check for large enough buffers. So, you'd have to 
request max size buffers from the beginning even for preview.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
