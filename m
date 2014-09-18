Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40283 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaIRJvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 05:51:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: OMAP3 Multiple camera support
Date: Thu, 18 Sep 2014 12:51:41 +0300
Message-ID: <2146472.606ksl2Qke@avalon>
In-Reply-To: <CAH9_wRPyqXWa7-sP2u2BXeM5ecwT8ZBpid6xWQ6aiWDQq-4jEQ@mail.gmail.com>
References: <CAH9_wRM_wd_GkS=j-7pkYTFRg4U1oN=NO+Wfhp56vKturYb+cg@mail.gmail.com> <25198985.8uoHdSYb8S@avalon> <CAH9_wRPyqXWa7-sP2u2BXeM5ecwT8ZBpid6xWQ6aiWDQq-4jEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sriram,

On Thursday 18 September 2014 15:10:13 Sriram V wrote:
> Hi Laurent,
> 
> What you are essentially saying is
> 
> CSI2A => Smart Sensor (YUV422)
> CSI2C => Sensor that gives out RAW Bayer.

Not quite. You can have the following pipelines running in parallel.

Sensor A -> CSI2A -> memory
Sensor B -> (CSI1/CCP2/CSI2C ->) CCDC -> preview -> resizer -> memory

The format captured at the CSI2A output will be set by the sensor. If you use 
a smart sensor that outputs YUV, you will capture YUV images. If you use a 
Bayer sensor, you will capture raw Bayer images. Which sensor to use will 
depend on your use case.

The second pipeline can use the whole ISP. I've showed the full pipeline, but 
you can capture frames at the output of the CCDC, preview engine or resizer, 
depending on your use case.

The H3A blocks are connected to the CCDC output, so they're only available to 
the second pipeline.

Another option would be to run three pipelines.

Sensor A -> CSI2A -> memory
Sensor B -> CSI2C -> memory
memory -> CSI1/CCP2 -> CCDC -> preview -> resizer -> memory

(The second pipeline isn't supported by the driver now, but that's a software 
limitation only, it shouldn't be difficult to fix)

The third pipeline would then be multiplexed between the two sensors, your 
userspace application would push frames captured from sensors A and B 
alternatively through the memory-to-memory processing pipeline.

This will consume more memory bandwidth than the first option, whether it 
would work depends on the frame sizes and rates. Another disadvantage of this 
solution is that reconfiguring the processing pipeline for each frame will 
take time and thus lower the maximum possible frame rate (I don't have numbers 
though).

On the upside you will be able to use H3A for both sensors.

> I guess this is a driver limitation? Am i correct?
> 
> Also, Can i have something like this?
> 
> SMART Sensor => CSI2A => H3A => MEM (Can i have this)
> CSI2C => ISP => H3A => MEM
> 
> Can't i have H3A for both the pipelines?
> Or
> 
> Can i enable H3A on the fly for both the sensors? One After the other?

-- 
Regards,

Laurent Pinchart

