Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:39555 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0H3Hxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 03:53:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lane Brooks <lane@brooks.nu>
Subject: Re: Snapshot with the OMAP
Date: Mon, 30 Aug 2010 09:53:46 +0200
Cc: linux-media@vger.kernel.org
References: <4C79EF0F.2090401@brooks.nu>
In-Reply-To: <4C79EF0F.2090401@brooks.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008300953.47420.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Lane,

On Sunday 29 August 2010 07:24:31 Lane Brooks wrote:
>   Laurent,
> 
> Suppose I am streaming 2048x1536 YUV images from a sensor into the OMAP.
> I am piping it through the resizer to drop it to 640x480 for display. So
> I am reading from /dev/video6 (resizer) and have the media bus links
> setup appropriately. Now the user presses the shutter button. What is
> the recommended way to read a single full resolution image?
> 
> It seems there are several options:
> 
> 1. Reconfigure the media bus and read a single single full resolution
> image out of the CCDC output on /dev/video2 and then
> reconfigure it back to video mode.
> 
> 2. Reconfigure the resizer to stop downsampling but instead output the
> full resolution image for a single frame.
> 
> Do I need to stop the stream while doing either option?

Both options require you to stop the stream. Reconfiguring the pipeline or 
changing formats can't be done during streaming (for completeness' sake, note 
that changing the crop rectangle at the resizer input can be done during 
streaming, but that won't solve your problem).

> These seem like clunky and slow options, though.
> 
> Is there a way to setup the media bus links so that I can actually have
> handles to /dev/video2 and /dev/video6 open simultaneously? Then I can
> normally read from /dev/video6 and then read single frames from
> /dev/video2 whenever the user presses the shutter button?

Not at the moment, but I'd be very happy to receive a patch that implements 
that feature :-)

> I have noticed there is a some ISP_PIPELINE_STREAM_SINGLESHOT streaming
> states in the isp code, but I don't what it is for or how to use it. Is
> it related to my questions at all?

No. They're used for memory-to-memory operation that requires the ISP to 
operate in single-shot mode.

> It gets even more complex if I want the streaming the video out of the
> sensor at a lower resolution (for higher video rates) and want to change
> the resolution of the sensor for the snapshot.

You will need to stop the pipeline, change the formats and restart it. There's 
no alternative at the moment.

-- 
Regards,

Laurent Pinchart
