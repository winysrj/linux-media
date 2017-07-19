Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47333 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751448AbdGSIJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 04:09:25 -0400
Message-ID: <1500451764.2364.17.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: disable BWB for all codecs on CODA 960
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ian Arkver <ian.arkver.dev@gmail.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 19 Jul 2017 10:09:24 +0200
In-Reply-To: <594ed2a7-df43-4fb4-b12c-5b215b618087@gmail.com>
References: <20170302101952.16917-1-p.zabel@pengutronix.de>
         <594ed2a7-df43-4fb4-b12c-5b215b618087@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ian,

On Wed, 2017-07-19 at 08:16 +0100, Ian Arkver wrote:
> Hi Philipp,
> 
> On 02/03/17 10:19, Philipp Zabel wrote:
> > I don't know what the BWB unit is, I guess W is for write and one of the
> > Bs is for burst. All I know is that there repeatedly have been issues
> > with it hanging on certain streams (ENGR00223231, ENGR00293425), with
> > various firmware versions, sometimes blocking something related to the
> > GDI bus or the GDI AXI adapter. There are some error cases that we don't
> > know how to recover from without a reboot. Apparently this unit can be
> > disabled by setting bit 12 in the FRAME_MEM_CTRL mailbox register to
> > zero, so do that to avoid crashes.
> 
> Both those FSL ENGR patches to Android and VPU lib are specific to 
> decode, with the first being specific to VC1 decode only.

The first one is older, I suppose VC1 is where the issue has been
observed first.
I have seen sporadic BWB hangups when decoding h.264 RTP streams.

> > Side effects are reduced burst lengths when writing out decoded frames
> > to memory, so there is an "enable_bwb" module parameter to turn it back
> > on.
> 
> These side effects are dramatically reducing the VPU throughput during 
> H.264 encode as well. Prior to this patch I was just about managing to 
> capture and stream 1080p25 H.264. After this change it fell to about 
> 19fps. Reverting this patch (or presumably using the module param) 
> restores the frame rate.
> 
> Can we at least make this decode specific? The VPU library patches do it 
> in vpu_DecOpen. I'd guess disabling the BWB any time prior to stream 
> start would be OK.

Yes, since ENGR00293425 only talks about decoders, and I haven't seen
any BWB related hangups during encoding yet, I'm inclined to agree.

> It might also be worth adding some sort of /* HACK */ marker, since 
> disabling the BWB feels very like a hack to me.

I don't think HACK in itself is very descriptive, but a reference to the
original workaround could be helpful in the future.

regards
Philipp
