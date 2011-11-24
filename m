Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46815 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1KXLWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 06:22:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrew Tubbiolo <andrew.tubbiolo@gmail.com>
Subject: Re: mt9p031 based sensor and ack lockups. Ie CCDC won't become idle.
Date: Thu, 24 Nov 2011 12:22:48 +0100
Cc: linux-media@vger.kernel.org
References: <CAAN7ACQFzNhswnDfsprHDk5C71GCXnbvnpkX+AsoQ9ejCFn6wQ@mail.gmail.com>
In-Reply-To: <CAAN7ACQFzNhswnDfsprHDk5C71GCXnbvnpkX+AsoQ9ejCFn6wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111241222.49453.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

On Monday 21 November 2011 00:54:04 Andrew Tubbiolo wrote:
> Hi All:
> 
>    I'm having fun with my new camera project that uses the mt9p031
> camera. I'm getting nice raw stills, and that's great, but every 16 or
> so images I take I get a troublesome error.
> 
> CCDC won't become idle!
> 
> The message is coming from...
> 
> 
> static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
> 
> in ...
> 
> linux-2.6.39.1/drivers/media/video/omap3isp/ispccdc.c
> 
> I printed out the return of the status of the registers on the CCDC
> and found that the only bit set was the CCDC_BUSY register.

[snip]

> I THINK I'm suffering from a data underflow, where the previous batch
> of images did not complete, or something.

The OMAP3 ISP is quite picky about its input signals and doesn't gracefully 
handle missing or extra sync pulses for instance. A "CCDC won't become idle!" 
message usually indicates that the CCDC received a frame of unexpected size 
(this can happen if the sensor stops in the middle of a frame for instance), 
or that the driver had no time to process the end of frame interrupt before 
the next frame arrived (either because of an unsually long interrupt delay on 
the system, or because of too low vertical blanking).

> Which is funny because I almost always get a full data set if everything
> starts up with no hiccup. I should add that I get this error when I start a
> exposure and data ack. The error is immediate, not in the middle of an ack.
> In fact the error is thrown during the yavta init sequence. During a
> ioctl(STREAM_ON).
> 
> I tried to issue a isp flush to the flush bit as described on (fig
> Table 12-88 ISP_CTRL) pg 1512 of the TI-OMAP manual. This froze the
> whole system. I'm wondering if anyone else is running into a similar
> or even the same problem and if they know of a solution, a fix, or a
> workaround?

-- 
Regards,

Laurent Pinchart
