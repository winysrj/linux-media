Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42748 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946158Ab2JDVjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 17:39:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media ML <linux-media@vger.kernel.org>, sakari.ailus@iki.fi
Subject: Re: omap3isp: timeout in ccdc_disable()
Date: Thu, 04 Oct 2012 23:40:16 +0200
Message-ID: <2255200.LEA9ddc7jS@avalon>
In-Reply-To: <506AF50B.5000606@matrix-vision.de>
References: <506AF50B.5000606@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Tuesday 02 October 2012 16:07:07 Michael Jones wrote:
> Hi Laurent,
> 
> I am looking at a case where the sensor may stop delivering data, at
> which point I want to do a STREAMOFF.  In this case, the STREAMOFF takes
> 2s because of the wait_event_timeout() in ccdc_disable().  This wait
> waits for ccdc->stopping to be CCDC_STOP_FINISHED, which happens in two
> stages (only 2 because LSC is always LSC_STATE_STOPPED for me),
> 1. in VD1 because CCDC_STOP_REQUEST has been set by ccdc_disable()
> 2. in VD0 after CCDC_STOP_REQUEST had happened in VD1.
> 
> But because the data has already stopped coming from the sensor, when I
> do STREAMOFF, I'm no longer getting VD1/0, so ccdc->stopping will never
> become CCDC_STOP_FINISHED, and the wait_event_timeout() has to run its
> course of 2 seconds.  This doesn't change the control flow in
> ccdc_disable(), except to print a warning "CCDC stop timeout!" and
> return -ETIMEDOUT to ccdc_set_stream(), which in turn returns that as
> its return value.  But this value is ignored by its caller,
> isp_pipeline_disable().  It looks to me, then, like the only difference
> between timing out and not timing out is getting the warning message.
> omap3isp_sbl_disble() is called the same in both cases.
> 
> Q: Is there another reason for the wait & timeout?  Is there some
> functional difference between timing out and not timing out?

Yes. The main reason is that the ISP hardware is pretty buggy, and we're lucky 
it works :-)

The ISP modules (CCDC, preview engine, resizer, ...) can be started 
independently, synchronize themselves to the input signal (at least in theory, 
sync can sometime be lost), but can't easily be stopped. To stop a module the 
driver requests a stop by writing to a register and then busy-loops to wait 
until the busy bit is cleared. For reasons I can't understand it seems that 
stopping a module in the middle of a frame was considered as a useless 
features, so modules can only be stopped on a frame boundary. A module that 
has been started will stay busy until it finishes processing a frame, even if 
a stop if requested before the frame begins.

Trying to reconfigure a module that hasn't been stopped results in an 
undefined behaviour. The preview engine, for instance, can crash completely, 
leading to a complete SoC crash. The CCDC seems to be a little more tolerant, 
but memory corruption or other bad issues can't be ruled out.

The CCDC case is even more complex, as we need to stop LSC (Lens Shading 
Correction) as well. There's a pretty complex state machine in the code, based 
on the assumption that the module will need to wait for the end of the frame 
before stopping anyway. That, coupled with the fact that requesting a stop at 
a random point might be race-prone, lead to the current implementation. It 
might be possible to modify the state machine to request a stop sooner without 
waiting for VD1, but even then the CCDC won't be able to stop properly, as it 
won't get a complete frame to process. It would be better than not stopping 
the CCDC at all though.

TI mentioned at some point that forcing the CCDC to stop without busy-loops 
was possible but I've never been told how it could be done. If you can come up 
with a fix (that doesn't break LSC usage) I'll be very happy to review and 
merge it :-)

> 2 seconds sounds fairly arbitrary, are there constraints on that, or could I
> at least lower it to speed up STREAMOFF?

It's arbitrary. The timeout needs to be large enough to wait until the end of 
the frame in the normal case.

> I know that normally the data wouldn't stop coming from the sensor until
> after the CCDC is disabled, when the sensor's s_stream(0) is called.
> But in this case the sensor is being driven externally, and I'm trying
> to react to that.

The OMAP3 ISP hardware doesn't like that much unfortunately :-S

-- 
Regards,

Laurent Pinchart

