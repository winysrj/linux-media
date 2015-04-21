Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55110 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbbDUR6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 13:58:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH 2/3] omap3isp: Disable CCDC's VD0 and VD1 interrupts when stream is not enabled
Date: Tue, 21 Apr 2015 20:58:25 +0300
Message-ID: <7150396.TWY5qHavDR@avalon>
In-Reply-To: <550998EE.8080801@logicpd.com>
References: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com> <1579699.dpjCaSBOhB@avalon> <550998EE.8080801@logicpd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Wednesday 18 March 2015 10:25:34 Tim Nordell wrote:
> On 03/18/15 10:19, Laurent Pinchart wrote:
> > On Tuesday 10 March 2015 14:24:53 Tim Nordell wrote:
> >> During testing there appeared to be a race condition where the IRQs
> >> for VD0 and VD1 could be triggered while enabling the CCDC module
> >> before the pipeline status was updated.  Simply modify the trigger
> >> conditions for VD0 and VD1 so they won't occur when the CCDC module
> >> is not enabled.
> >> 
> >> (When this occurred during testing, the VD0 interrupt was occurring
> >> over and over again starving the rest of the system.)
> > 
> > I'm curious, might this be caused by the input (adv7180 in your case)
> > being enabled before the ISP ? The CCDC is very sensitive to any glitch in
> > its input signals, you need to make sure that the source is disabled
> > before its subdev s_stream operation is called. Given that the adv7180
> > driver doesn't implement s_stream, I expect it to be free-running, which
> > is definitely a problem.
>
> I'll give that a shot and try add code into the adv7180 driver to turn on
> and off its output signals.  However, it seems like if the driver can avoid
> a problem presented by external hardware (or other drivers), that it should. 
> Something like either turning off the VD0 and VD1 interrupts when not in
> use, or by simply moving the trigger points for those interrupts (as I did
> here) to avoid problems by presented by signals to the system is probably a
> good thing for robustness.

I don't disagree with that. I'll have to review the patch in details, as the 
CCDC code is quite sensitive. In order to do so, I'd like to know whether the 
problem in your case was caused by the adv7180 always being enabled. Any luck 
with adding a s_stream implementation in the adv7180 driver ? :-)

-- 
Regards,

Laurent Pinchart

