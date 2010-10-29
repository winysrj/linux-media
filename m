Return-path: <mchehab@pedra>
Received: from mailgate.plextek.co.uk ([62.254.222.163]:60084 "EHLO
	mailgate.plextek.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab0J2Ifs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 04:35:48 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: Changing frame size on the fly in SOC module
Date: Fri, 29 Oct 2010 09:35:46 +0100
Message-ID: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF3325@plextek3.plextek.lan>
References: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF331B@plextek3.plextek.lan> <Pine.LNX.4.64.1010282009160.1257@axis700.grange>
From: "Adam Sutton" <aps@plextek.co.uk>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

Thanks for the response, it's good just to get confirmation that I was
indeed interpreting the code properly.

I guess the main reason this is more significant for me is the
constraints I have on the hardware, i.e. it cannot handle the 640x480 at
any reasonable frame rate so we need the camera hardware to provide the
smaller image and second closing the camera powers the module down to
conserve power, which means time from open to image capture is slow
(particularly because I have to drop the first few frames with the auto
white balance etc... settles).

I had already assumed that streaming would need to be stopped before the
size could be changed, really don't see a problem with that. I had used
that approach with non-SOC style modules.

I think the documentation in videobuf talks about requesting the MAX
buffer size you will require from the start. So again I had already
assumed I'd need to do that as well.

I'm not sure I fully understand the concern about multiple simultaneous
users. I certainly don't have that as a user case in my own requirements
(device is a small handheld teaching aid) and I would have thought that
if 2 users try to use the same camera module at the same time all hell
would probably break out anyway. Have to admit I've never tried it
before.

Adam


-----Original Message-----
From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
Sent: 28 October 2010 20:01
To: Adam Sutton
Cc: linux-media@vger.kernel.org
Subject: Re: Changing frame size on the fly in SOC module

Hi Adam

On Thu, 28 Oct 2010, Adam Sutton wrote:

> Hi,
> 
> Sometime ago I developed an SOC based camera driver for my platform
> (ov7675 on iMX25), for the most part it seems to be working well
however
> at the time I couldn't manage to change the frame size on the fly
> (without closing / re-opening the device).
> 
> The current problem I have is that my application needs to display a
> 320x240 preview image on screen, but to capture a static image at
> 640x480. I can do this as long as I close the device in between,
> unfortunately for power consumption reasons the camera device is put
> into a low power state whenever the device is released. This means
that
> the image capture takes approx 1.5s (the requirement I have to meet is
> 1s).
> 
> Now I could cheat and simply subsample (in software) the 640x480
image,
> but that puts additional burden on an already overworked MCU.
> 
> Having been through the soc_camera and videobuf code and as far as I
can
> tell this inability to change the frame size without closing the
camera
> device appears to be a design decision.

Yes, it is.

> What I'm really after is confirmation one way of the other. If it's
not,
> what is the correct process to achieve the frame change without
closing
> the device. And if it is, does anybody have any suggestions of
possible
> workarounds?

It has been decided that way, because we didn't have a good use-case for

changing the frame format on-the-fly to develop for and to test with.
You 
seem to have one now, so, go ahead;)

There are a couple of issues to address though - videobuffer
configuration 
is one of them, host reconfiguration is the other one, possible multiple

simultaneous users is the third one (ok, only one of them will be
actually 
streaming).

This use case - different size preview and single shot capture has come
up 
a couple of times before, but noone has brought it to a proper
mainstream 
solution.

One thing you'd still want to do, I think, is to stop streaming before 
reconfiguring, and restart it afterwards.

So, maybe a viable solution would be:

in soc_camera_s_fmt_vid_cap() check not just for "icf->vb_vidq.bufs[0]
!= 
NULL", but rather for if streaming is not running, and then someone will

certainly have to check for large enough buffers. So, you'd have to 
request max size buffers from the beginning even for preview.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
Plextek Limited
Registered Address: London Road, Great Chesterford, Essex, CB10 1NY, UK Company Registration No. 2305889
VAT Registration No. GB 918 4425 15
Tel: +44 1799 533 200. Fax: +44 1799 533 201 Web:http://www.plextek.com 
Electronics Design and Consultancy

