Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53273 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753343AbdGSJcr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:32:47 -0400
Message-ID: <1500456765.2364.24.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: disable BWB for all codecs on CODA 960
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ian Arkver <ian.arkver.dev@gmail.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 19 Jul 2017 11:32:45 +0200
In-Reply-To: <be0903ff-307d-bcd0-5193-118a6f995bcb@gmail.com>
References: <20170302101952.16917-1-p.zabel@pengutronix.de>
         <594ed2a7-df43-4fb4-b12c-5b215b618087@gmail.com>
         <1500451764.2364.17.camel@pengutronix.de>
         <be0903ff-307d-bcd0-5193-118a6f995bcb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-07-19 at 10:15 +0100, Ian Arkver wrote:
> On 19/07/17 09:09, Philipp Zabel wrote:
> > Hi Ian,
> > 
> > On Wed, 2017-07-19 at 08:16 +0100, Ian Arkver wrote:
> >> Hi Philipp,
> >>
> >> On 02/03/17 10:19, Philipp Zabel wrote:
> >>> Side effects are reduced burst lengths when writing out decoded frames
> >>> to memory, so there is an "enable_bwb" module parameter to turn it back
> >>> on.
> >>
> >> These side effects are dramatically reducing the VPU throughput during
> >> H.264 encode as well. Prior to this patch I was just about managing to
> >> capture and stream 1080p25 H.264. After this change it fell to about
> >> 19fps. Reverting this patch (or presumably using the module param)
> >> restores the frame rate.
> >>
> >> Can we at least make this decode specific? The VPU library patches do it
> >> in vpu_DecOpen. I'd guess disabling the BWB any time prior to stream
> >> start would be OK.
> > 
> > Yes, since ENGR00293425 only talks about decoders, and I haven't seen
> > any BWB related hangups during encoding yet, I'm inclined to agree.
> 
> I took a look at where ctx->frame_mem_ctrl is used, i.e.
> coda_start_encoding and __coda_start_decoding. Is it possible to have
> one instance of coda open for encode and one for decode at the same
> time? 

Sure, when transcoding with a decoder / encoder pair, for example.

> If so, how is the CODA_REG_BIT_FRAME_MEM_CTRL setting
> updated between runs, eg. for differing CODA_FRAME_CHROMA_INTERLEAVE?

Yes. coda_command_async writes ctx->frame_mem_ctrl to
CODA_REG_BIT_FRAME_MEM_CTRL with each PIC_RUN command at from
prepare_encode/decode.

> This code is in the start_streaming path rather than the prepare_run
> path. Does each context switch stop & restart streaming?

No, see above.

regards
Philipp
