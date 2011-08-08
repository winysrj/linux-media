Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45629 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1HHJzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 05:55:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: ISP CCDC freeze-up on STREAMON
Date: Mon, 8 Aug 2011 11:55:47 +0200
Cc: linux-media@vger.kernel.org
References: <1309422713-18675-1-git-send-email-michael.jones@matrix-vision.de> <201107201047.11972.laurent.pinchart@ideasonboard.com> <4E3BB8E0.3000406@matrix-vision.de>
In-Reply-To: <4E3BB8E0.3000406@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108081155.47421.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Friday 05 August 2011 11:33:20 Michael Jones wrote:
> On 07/20/2011 10:47 AM, Laurent Pinchart wrote:
> > On Thursday 30 June 2011 10:31:52 Michael Jones wrote:
> >> Hi Laurent,
> >> 
> >> I'm observing a system freeze-up with the ISP when writing data to
> >> memory directly from the ccdc.
> >> 
> >> Here's the sequence I'm using:
> >> 
> >> 0. apply the patch I'm sending separate in this thread.
> >> 
> >> 1. configure the ISP pipeline for the CCDC to deliver V4L2_PIX_FMT_GREY
> >> directly from the sensor to memory.
> >> 
> >> 2. yavta -c10 /dev/video2
> >> 
> >> The patch is pretty self-explanatory.  It introduces a loop (with ugly
> >> indenting to keep the patch simple) with 100 iterations leaving the
> >> device open between them. My system usually hangs up within the first
> >> 30 iterations.  I've never made it to 100 successfully.  I see the same
> >> behavior with user pointers and with mmap, but I don't see it when
> >> using data from the previewer.
> >> 
> >> Can you please try this out with your setup?  Even if you can't get
> >> 8-bit gray data from your sensor, hopefully you could observe it with
> >> any other format directly from the CCDC.
> >> 
> >> I'll postpone further discussion until you confirm that you can
> >> reproduce the behavior.  As the patch illustrates, it looks like it is
> >> hanging up in STREAMON.
> > 
> > I've tested this with a serial CSI-2 sensor and a parallel sensor
> > (MT9V032, in both 8-bit and 10-bit modes, albeit with SGRBG8 instead of
> > GREY for the 8-bit mode), and I can't reproduce the issue.
> > 
> > I thought I've asked you already but can't find this in my mailbox, so I
> > apologize if I have, but could you try increasing vertical blanking and
> > see if it helps ?
> 
> I think that was the first time you suggested that. Indeed, if I stretch
> out the time between frames, the problem goes away. I haven't tested it
> precisely to see how long it needs to be to work correctly. But what
> does this tell me? This isn't a very appealing fix as 1) I would have to
> fish around for a minimum vertical blank time that works and 2) this
> would slow down the frame rate for the normal case, when frames are just
> being streamed uninterrupted.

Please complain to TI for their flaky hardware design. The OMAP3 ISP driver 
needs to perform operations in interrupt context between the end of a frame 
and the beginning of a new one. If the vertical blanking time is too short the 
ISP will fail. The minimum vertical blanking time depends on the system 
responsiveness to interrupts, so there's no easy way to give you a minimum 
value that will work in all cases.

-- 
Regards,

Laurent Pinchart
