Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC5AC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 15:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A61B206BA
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 15:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbfAIPke (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 10:40:34 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42493 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731076AbfAIPke (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 10:40:34 -0500
Received: from [IPv6:2001:420:44c1:2579:f8c4:4546:22d:c704] ([IPv6:2001:420:44c1:2579:f8c4:4546:22d:c704])
        by smtp-cloud9.xs4all.net with ESMTPA
        id hFxngRQeSMWvEhFxrgTVe3; Wed, 09 Jan 2019 16:40:31 +0100
Subject: Re: [PATCH 2/2] media: cedrus: Allow using the current dst buffer as
 reference
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20190109141920.12677-1-paul.kocialkowski@bootlin.com>
 <20190109141920.12677-2-paul.kocialkowski@bootlin.com>
 <9a624f6a-0c38-f2c9-3f2d-2758f9a19299@xs4all.nl>
 <9b8098a9fde4f7645ffe2da263cee038dd823e69.camel@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <29500521-2c7d-aa34-abc9-2da1b110e774@xs4all.nl>
Date:   Wed, 9 Jan 2019 16:40:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <9b8098a9fde4f7645ffe2da263cee038dd823e69.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOvEoN97jNgv+eHZfDRrBJOm6PuX5+vRzdqc0fKg91wtmq1VjwkOkLWpPZKWLp5FXbWkHICn+SO2k/VXSsmfiSxru+ilP7gAcUl60R5IKKXZGFSn74js
 DRQGMrkWOauuJIJvIkqVMIU7jnyv6lx7prlphMYZimwIeME1xlDa9vGZLJZ5AuZd93w0NPbLZc+POFPzp1JDJo8999ZUbXT8sC/5z/XVgOvTcje+u6fLaaKy
 /6sfmYhUZwhsBKXHwE6dYkE6gy+873f1iVUZljuNp530gXBPtbv2cP6nj81z3SD3z12gadukcsqqLTNVc7C9Enn+kvi36/gYaEXr9uRINpUoI+y3LpC6e8F4
 xJCnVX3ahwMttKxUwZUVHwjjsdpA9ESqjVh4dIhZYg4fRSPEevjhUDVFZF9fR6IiH95WNak7He5eQvmHgA2+C9eLAne3xUza1URh/CPnmUMFi+yhS3P6hMi6
 LncU3gbckmPUKabqOE8LYKkV+OTudGMPye2Hp4mOeFx+Qe/nKzjYd/A7LIpqYhheNLYjpHnEB7CzpGsFrCxOujTtei2HcLoVN0eqQv4HXggvp1yBh9v8zpuf
 nAZt+PfHD1EqbR9FzmpowCd7GSHzTNZD7j620GYh0ieHv4Za4tzklB9q1Y0Ja0DLCg8dTLSE6HsuaQWembCC7sbQJcp4pdoguA/EBGR5R9Ygbn1rS1Culd7R
 M3VTn0y0tnoGpTllvUWP8tAXDkZMlktsS/UwrrGQV0uR82Jnvlovo/hr89/K1vNL9KV8C9pih2nFMVVclH9CgQG0K64QIrioauJvssChS8Y7wUzPmyfqqHZI
 rDFPrPUTv7HyAiHfj14=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/09/19 15:42, Paul Kocialkowski wrote:
> Hi,
> 
> On Wed, 2019-01-09 at 15:29 +0100, Hans Verkuil wrote:
>> On 01/09/19 15:19, Paul Kocialkowski wrote:
>>> It was reported that some cases of interleaved video decoding require
>>> using the current destination buffer as a reference. However, this is
>>> no longer possible after the move to vb2_find_timestamp because only
>>> dequeued and done buffers are considered.
>>>
>>> Add a helper in our driver that also considers the current destination
>>> buffer before resorting to vb2_find_timestamp and use it in MPEG-2.
>>
>> This patch looks good, but can you also add checks to handle the case
>> when no buffer with the given timestamp was found? Probably should be done
>> in a third patch.
>>
>> I suspect the driver will crash if an unknown timestamp is passed on to the
>> driver. I would really like to see that corner case fixed.
> 
> You're totally right and I think that more generarlly, the current code
> flow is rather fragile whenever something wrong happens in our setup()
> codec op. I think we should at least have that op return an error code
> and properly deal with it when that occurs.
> 
> I am planning on making a cleanup series to fix that.
> 
> Before using timestamps, reference buffer index validation was done in
> std_validate and now it's fully up to the driver. I wonder if it would
> be feasible to bring something back in there since all stateless
> drivers will face the same issue. The conditions set in
> cedrus_reference_index_find seem generic enough for that, but we should
> check that std_validate is not called too early, when the queue is in a
> different state (and the buffer might not be dequeud or done yet).
> 
> What do you think?

I don't think you can do that. Say you queue a buffer that refers to a
ref frame F, and F is a buffer that's been dequeued. When std_validate is
called, this is fine and valid. Now later (but before the request is
processed) buffer F is queued by the application. Now F is no longer valid.

So when the driver processes the request, it won't be able to find F anymore.

A more interesting question is what you should do if a reference frame isn't
found. And should that be documented in the stateless decoder spec? (Or perhaps
it's there already, I'm not sure).

Regards,

	Hans

> 
> Cheers,
> 
> Paul
> 
>>> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>> ---
>>>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 +++++++++++++
>>>  drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 ++
>>>  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++++----
>>>  3 files changed, 21 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>> index 443fb037e1cf..2c295286766c 100644
>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>>> @@ -22,6 +22,19 @@
>>>  #include "cedrus_dec.h"
>>>  #include "cedrus_hw.h"
>>>  
>>> +int cedrus_reference_index_find(struct vb2_queue *queue,
>>> +				struct vb2_buffer *vb2_buf, u64 timestamp)
>>> +{
>>> +	/*
>>> +	 * Allow using the current capture buffer as reference, which can occur
>>> +	 * for field-coded pictures.
>>> +	 */
>>> +	if (vb2_buf->timestamp == timestamp)
>>> +		return vb2_buf->index;
>>> +	else
>>> +		return vb2_find_timestamp(queue, timestamp, 0);
>>> +}
>>> +
>>>  void cedrus_device_run(void *priv)
>>>  {
>>>  	struct cedrus_ctx *ctx = priv;
>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
>>> index d1ae7903677b..8d0fc248220f 100644
>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
>>> @@ -16,6 +16,8 @@
>>>  #ifndef _CEDRUS_DEC_H_
>>>  #define _CEDRUS_DEC_H_
>>>  
>>> +int cedrus_reference_index_find(struct vb2_queue *queue,
>>> +				struct vb2_buffer *vb2_buf, u64 timestamp);
>>>  void cedrus_device_run(void *priv);
>>>  
>>>  #endif
>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
>>> index cb45fda9aaeb..81c66a8aa1ac 100644
>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
>>> @@ -10,6 +10,7 @@
>>>  #include <media/videobuf2-dma-contig.h>
>>>  
>>>  #include "cedrus.h"
>>> +#include "cedrus_dec.h"
>>>  #include "cedrus_hw.h"
>>>  #include "cedrus_regs.h"
>>>  
>>> @@ -159,8 +160,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>>>  	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
>>>  
>>>  	/* Forward and backward prediction reference buffers. */
>>> -	forward_idx = vb2_find_timestamp(cap_q,
>>> -					 slice_params->forward_ref_ts, 0);
>>> +	forward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
>>> +						  slice_params->forward_ref_ts);
>>>  
>>>  	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
>>>  	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
>>> @@ -168,8 +169,9 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>>>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
>>>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
>>>  
>>> -	backward_idx = vb2_find_timestamp(cap_q,
>>> -					  slice_params->backward_ref_ts, 0);
>>> +	backward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
>>> +						   slice_params->backward_ref_ts);
>>> +
>>>  	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
>>>  	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
>>>  
>>>

