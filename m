Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34763 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbdGSJPh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:15:37 -0400
Received: by mail-wm0-f67.google.com with SMTP id p204so2757535wmg.1
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 02:15:37 -0700 (PDT)
Subject: Re: [PATCH] [media] coda: disable BWB for all codecs on CODA 960
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de
References: <20170302101952.16917-1-p.zabel@pengutronix.de>
 <594ed2a7-df43-4fb4-b12c-5b215b618087@gmail.com>
 <1500451764.2364.17.camel@pengutronix.de>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <be0903ff-307d-bcd0-5193-118a6f995bcb@gmail.com>
Date: Wed, 19 Jul 2017 10:15:34 +0100
MIME-Version: 1.0
In-Reply-To: <1500451764.2364.17.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/07/17 09:09, Philipp Zabel wrote:
> Hi Ian,
> 
> On Wed, 2017-07-19 at 08:16 +0100, Ian Arkver wrote:
>> Hi Philipp,
>>
>> On 02/03/17 10:19, Philipp Zabel wrote:
>>> Side effects are reduced burst lengths when writing out decoded frames
>>> to memory, so there is an "enable_bwb" module parameter to turn it back
>>> on.
>>
>> These side effects are dramatically reducing the VPU throughput during
>> H.264 encode as well. Prior to this patch I was just about managing to
>> capture and stream 1080p25 H.264. After this change it fell to about
>> 19fps. Reverting this patch (or presumably using the module param)
>> restores the frame rate.
>>
>> Can we at least make this decode specific? The VPU library patches do it
>> in vpu_DecOpen. I'd guess disabling the BWB any time prior to stream
>> start would be OK.
> 
> Yes, since ENGR00293425 only talks about decoders, and I haven't seen
> any BWB related hangups during encoding yet, I'm inclined to agree.

I took a look at where ctx->frame_mem_ctrl is used, i.e.
coda_start_encoding and __coda_start_decoding. Is it possible to have
one instance of coda open for encode and one for decode at the same
time? If so, how is the CODA_REG_BIT_FRAME_MEM_CTRL setting
updated between runs, eg. for differing CODA_FRAME_CHROMA_INTERLEAVE?
This code is in the start_streaming path rather than the prepare_run
path. Does each context switch stop & restart streaming?

Regards,
Ian
