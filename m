Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.141]:41196 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbdKXHrd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 02:47:33 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout01.posteo.de (Postfix) with ESMTPS id AA77B20EDD
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 08:47:31 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Nov 2017 08:47:30 +0100
From: Martin Kepplinger <martink@posteo.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: coda: fix comparision of decoded frames' indexes
In-Reply-To: <1511358238.17007.12.camel@pengutronix.de>
References: <20171117143010.501-1-martink@posteo.de>
 <1511358238.17007.12.camel@pengutronix.de>
Message-ID: <cadfd220d63148eab3383167e6ce43a0@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 22.11.2017 14:43 schrieb Philipp Zabel:
> Hi Martin,
> 
> On Fri, 2017-11-17 at 15:30 +0100, Martin Kepplinger wrote:
>> At this point the driver looks the currently decoded frame's index
>> and compares is to VPU-specific state values. Directly before this
>> if and else statements the indexes are read (index for decoded and
>> for displayed frame).
>> 
>> Now what is saved in ctx->display_idx is an older value at this point!
> 
> Yes. The rotator that copies out the decoded frame runs in parallel 
> with
> the decoding of the next frame. So the decoder signals with display_idx
> which decoded frame should be presented next, but it is only copied out
> into the vb2 buffer during the following run. The same happens with the
> VDOA, but manually, in prepare_decode.
> 
> That means that at this point display_idx is the index of the 
> previously
> decoded internal frame that should be presented next, and ctx-
>> display_idx is the index of the internal frame that was just copied
> into the externally visible vb2 buffer.
> 
> The logic reads someting like this:
> 
> 	if (no frame was decoded) {
> 		if (a frame will be copied out next time) {
> 			adapt sequence number offset;
> 		} else if (no frame was copied out this time) {
> 			hold until further input;
> 		}
> 	}
> 
> Basically, it will just wait one more run until it stops the stream,
> assuming that there is really nothing useful in the bitstream
> ringbuffer.
> 
>> During these index checks, the current values apply, so fix this by
>> taking display_idx instead of ctx->display_idx.
> 
> display_idx is already checked later in the same function.
> According to the i.MX6 VPU API document, it can be -2 (never seen) or 
> -3
> during sequence start (if there is frame reordering, depending on
> whether decoder skip is enabled), and I think I've seen -3 as prescan
> failure on i.MX5. -1 means EOS according to that document, that's why 
> we
> always hold in that case.
> 
>> ctx->display_idx is updated later in the same function.
>> 
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>> ---
>> 
>> Please review this thoroughly, but in case I am wrong here, this is
>> at least very strange to read and *should* be accompanied with a
>> comment about what's going on with that index value!
> 
> Maybe it would be less confusing to move this into the display_idx
> checks below, given that we already hold unconditionally
> on display_idx == -1.
> 
>> I don't think it matter that much here because at least playing h264
>> worked before and works with this change, but I've tested it anyways.
> 
> I think this shouldn't happen at all if you feed it a well formed h.264
> stream. But if you have a skip because of broken data while there is
> still no display frame at the beginning of the stream or after an IDR,
> this might be hit.

Right. Let's leave it this way. In case of real changes, one can think 
about
cleanup.

Thanks for clarification and helping to understand this thing! I 
appreciate it.

                                  martin
