Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49983 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaEZUKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 16:10:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP & BT656
Date: Mon, 26 May 2014 22:10:58 +0200
Message-ID: <1508483.ine07GQHKa@avalon>
In-Reply-To: <4F15ED39.4070604@mlbassoc.com>
References: <4F15ED39.4070604@mlbassoc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Tuesday 17 January 2012 14:50:49 you wrote:
> I have a number of boards with OMAP 3530/3730 that use the
> TVP5150AM1 video decoder.  On most of these boards, I can
> capture reasonable quality video.  However, I have some (more
> than a few which is reason for concern) where the video is
> either really bad or even the ISP doesn't seem to recognize
> the BT656 data stream.  On the ones that have "bad" video,
> the data is all blown out and barely recognizable.
> 
> All the boards are running the same kernel (3.0+ with the
> YUV patches that Lennart and others proposed late last year).
> I've verified that the component registers (ISPCCDC and TVP5150)
> match.  I can't see what could be the cause of such radically
> variable behaviour.
> 
> The one thing I've found is on the boards that don't work
> at all, the CCDC_SYN_MODE[FLDSTAT] bit is not toggling, which
> in turn causes no data to be pushed through the V4L2 pipeline.
> 
> Any ideas what can cause this?  More importantly, what I can
> try to fix it?  The really scary thing is that all the boards
> in my lab work great, but in the factory (some 6000 miles away),
> more than not don't work :-(
> 
> Would it be possible to configure the CCDC to capture the
> raw BT656 data?  These boards are very small and it's impossible
> to get onto the video data lines going into the processor (they
> are all hidden within the circuit board).
> 
> Any help/ideas gladly accepted.

I realize this is a *really* late reply :-)

Just for your information, I've posted patches to the linux-media mailing list 
that add BT.656 support to the OMAP3 ISP driver. I've CC'ed you, in case you 
would find them useful and/or want to test them.

I'm also wondering whether you have been to fix the BT.656 issue you've 
described here.

-- 
Regards,

Laurent Pinchart

