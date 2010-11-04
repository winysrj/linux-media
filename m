Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41032 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab0KDCf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 22:35:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: New media framework user space usage
Date: Thu, 4 Nov 2010 03:35:35 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com> <201011012302.03284.laurent.pinchart@ideasonboard.com> <AANLkTinWo7siGdbmRPNEfOfJHTZLEqxMFHOO9aqijP0d@mail.gmail.com>
In-Reply-To: <AANLkTinWo7siGdbmRPNEfOfJHTZLEqxMFHOO9aqijP0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011040335.36118.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Bastian,

On Tuesday 02 November 2010 11:31:28 Bastian Hecht wrote:
> >> I am the first guy needing a 12 bit-bus?
> > 
> > Yes you are :-) You will need to implement 12 bit support in the ISP
> > driver, or start by hacking the sensor driver to report a 10 bit format
> > (2 bits will be lost but you should still be able to capture an image).
> 
> Isn't that an "officially" supported procedure to drop the least
> significant bits?
> You gave me the isp configuration
> .bus = { .parallel = {
>                        .data_lane_shift        = 1,
> ...
> that instructs the isp to use 10 of the 12 bits.

If you don't need the full 12 bits, sure, that should work.

> >> Second thing is, the yavta app now gets stuck while dequeuing a buffer.
> >> 
> >> strace ./yavta -f SGRBG10 -s 2592x1944 -n 4 --capture=4 --skip 3 -F
> >> /dev/video2 ...
> >> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> >> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> >> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> >> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> >> ioctl(3, VIDIOC_STREAMON, 0xbec11154)   = 0
> >> ioctl(3, VIDIOC_DQBUF
> >> 
> >> strace gets stuck in mid of this line.
> 
> Somehow the ISP_ENABLE_IRQ register was reset at some point that is
> unclear to me. When I put it on again manually yavta succeeds to read
> the frames.

That's weird. Let me know if you can reproduce the problem.

> Unfortunately the image consists of black pixels only. We found out that the
> 2.8V voltage regulator got broken in the course of development - the 1.8V
> logic still worked but the ADC did not...
> 
> But the heck - I was never that close :)

-- 
Regards,

Laurent Pinchart
