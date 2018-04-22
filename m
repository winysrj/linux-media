Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:42076 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbeDVD2c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 23:28:32 -0400
Subject: Re: [PATCH] media: imx: Skip every second frame in VDIC DIRECT mode
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
References: <20180407130440.24886-1-marex@denx.de>
 <1523527441.3689.7.camel@pengutronix.de>
 <e022d161-71c0-cdd2-7eb4-855dbe3a8e72@mentor.com>
From: Marek Vasut <marex@denx.de>
Message-ID: <92742141-73fa-6e9e-a0eb-14a762479d96@denx.de>
Date: Sun, 22 Apr 2018 05:28:28 +0200
MIME-Version: 1.0
In-Reply-To: <e022d161-71c0-cdd2-7eb4-855dbe3a8e72@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/21/2018 11:29 PM, Steve Longerbeam wrote:
> 
> 
> On 04/12/2018 03:04 AM, Philipp Zabel wrote:
>> On Sat, 2018-04-07 at 15:04 +0200, Marek Vasut wrote:
>>> In VDIC direct mode, the VDIC applies combing filter during and
>>> doubles the framerate, that is, after the first two half-frames
>>> are received and the first frame is emitted by the VDIC, every
>>> subsequent half-frame is patched into the result and a full frame
>>> is produced. The half-frame order in the full frames is as follows
>>> 12 32 34 54 etc.
>> Is that true? We are only supporting full motion mode (VDI_MOT_SEL=2),
>> so I was under the impression that only data from the current field
>> makes it into the full frame. The missing lines should be purely
>> estimated from the available field using the di_vfilt 4-tap filter.
> 
> Yes, the reference manual states that the VDI_MOT_SEL field
> value 2 is "Full motion, only vertical filter is used". Which is
> clearly referring to the di_vfilt 4-tap filter.
> 
> There are still some questions about how full motion mode is
> supposed to work. For one thing, the di_vfilt only operates on four
> consecutive lines of a single field. It makes no sense that the VDIC
> can compensate for motion between fields when it is operating
> with only one field.
> 
> Marek, where did you get the information that full motion mode
> applies some kind of combing filter?

By observing how the HW behaves. The input from NXP forum was mostly
useless or actually outright wrong. I have to admit it's been a while
since I created the patch, but what I saw was basically the hardware
producing frames as a combination of halfframe 1-2 2-3 3-4 etc , thus
doubling the framerate. Setting the skip normalized the framerate
without any loss of image information.

> A combing filter would imply
> taking previous and/or future fields back into the result, which is
> exactly what the other motion modes do, but as I said the reference
> manual is clear that full motion mode uses only the (single field)
> vertical filter.
> 
> The manual also mentions regarding "real-time mode" which we are
> making use of (in which the VDIC FIFO1 receives field F(n-1) directly
> from the CSI rather than from DMA):
> 
> "In addition IDMAC read the field from FIFO1 and store in external memory.
> Then stored frames are used as F(n) and F(n+1).".
> 
> It is nowhere explicitly stated, but the assumption is that this is IDMAC
> channel 13 that stores the CSI field to memory. But many people have
> asked Freescale/NXP how this works in the past, and there has never
> been a satisfactory answer. And people have reported no success in
> getting this channel to work including myself.
> 
> So the approach this driver takes is to use real-time mode to receive
> F(n-1) directly from CSI, in concert with full motion mode, so that
> the VDIC operates on F(n-1) only. Thus no DMA is necessary.
> 
> Finally I have to say that the other modes are supported in this driver,
> but they require DMA transfer of all three fields, and there is no
> output device node written to make use of those modes yet. But
> from experience, the de-interlaced result is of much better quality
> than the real-time/full-motion output.
> 
> 
> Steve
> 
> 


-- 
Best regards,
Marek Vasut
