Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:36116 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755635AbbDUSJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 14:09:50 -0400
Message-ID: <5536914E.7090407@logicpd.com>
Date: Tue, 21 Apr 2015 13:05:02 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/3] omap3isp: Disable CCDC's VD0 and VD1 interrupts when
 stream is not enabled
References: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com> <1579699.dpjCaSBOhB@avalon> <550998EE.8080801@logicpd.com> <7150396.TWY5qHavDR@avalon>
In-Reply-To: <7150396.TWY5qHavDR@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent -

On 04/21/15 12:58, Laurent Pinchart wrote:
> Hi Tim,
>
> On Wednesday 18 March 2015 10:25:34 Tim Nordell wrote:
>> I'll give that a shot and try add code into the adv7180 driver to turn on
>> and off its output signals.  However, it seems like if the driver can avoid
>> a problem presented by external hardware (or other drivers), that it should.
>> Something like either turning off the VD0 and VD1 interrupts when not in
>> use, or by simply moving the trigger points for those interrupts (as I did
>> here) to avoid problems by presented by signals to the system is probably a
>> good thing for robustness.
> I don't disagree with that. I'll have to review the patch in details, as the
> CCDC code is quite sensitive. In order to do so, I'd like to know whether the
> problem in your case was caused by the adv7180 always being enabled. Any luck
> with adding a s_stream implementation in the adv7180 driver ? :-)
>

I did add the stream on/off code, but it still seemed to have some 
difficulties.  The codebase has effectively been handed off to our 
client, however, at this point.  I still happen to have hardware (we're 
wrapping things up with the client), but likely I won't have the 
hardware in a week or so.

I still think that the driver should avoid having the interrupts enabled 
if it knows it shouldn't be receiving any at a given point. I personally 
like the approach of modifying the VD0/VD1 trigger points as it 
effectively silences those interrupts without touching the central 
interrupt register (less potential locking issues between the various 
components in the OMAP3 ISP), but it could be reworked of course to 
touch the central interrupt register too.

- Tim

