Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:33590 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726260AbeHBJUo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Aug 2018 05:20:44 -0400
Subject: Re: [PATCH 3/3] media: add Rockchip VPU driver
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>
References: <20180705172819.5588-1-ezequiel@collabora.com>
 <20180705172819.5588-4-ezequiel@collabora.com>
 <3ea4cbc3-d7df-5860-46ec-9302b19bd713@xs4all.nl>
 <901b48718fa525b6bb8f868bb8cf93f1a3e78413.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2d8ab5c1-d932-9fee-d2bd-b31d285eb802@xs4all.nl>
Date: Thu, 2 Aug 2018 09:30:47 +0200
MIME-Version: 1.0
In-Reply-To: <901b48718fa525b6bb8f868bb8cf93f1a3e78413.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2018 07:13 PM, Ezequiel Garcia wrote:
> Hi Hans,
> 
> Thanks a lot for the review.
> 
> On Wed, 2018-07-18 at 11:58 +0200, Hans Verkuil wrote:
>>>
>>> +
>>> +static int
>>> +queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
>>> +{
>>> +	struct rockchip_vpu_ctx *ctx = priv;
>>> +	int ret;
>>> +
>>> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>>> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>>
>> Any reason for setting USERPTR?
>>
>>> +	src_vq->drv_priv = ctx;
>>> +	src_vq->ops = &rockchip_vpu_enc_queue_ops;
>>> +	src_vq->mem_ops = &vb2_dma_contig_memops;
>>
>> It isn't really useful in combination with dma_contig.
>>
> 
> Right! I think I just missed it.
> 
>>>
>>> +
>>> +fallback:
>>> +	/* Default to full frame for incorrect settings. */
>>> +	ctx->src_crop.width = fmt->width;
>>> +	ctx->src_crop.height = fmt->height;
>>> +	return 0;
>>> +}
>>
>> Replace crop by the selection API. The old crop API is no longer allowed
>> in new drivers.
> 
> I have a question about the selection API. There is a comment that says
> MPLANE types shouldn't be used:
> 
> /**
>  * struct v4l2_selection - selection info
>  * @type:       buffer type (do not use *_MPLANE types)
> 
> What is the meaning of that?

Easiest is to look in v4l2-ioctl.c. Search for g_selection. You'll see that
if the user passes in an _MPLANE buftype it is replaced by the regular non-mplane
buftype. So drivers only see that type.

It used to be that applications also had to be specific about what buftype to
pass to G/S_SELECTION, but these days either type can be passed in.

> 
> [..]
>>
>> I skipped the review of the colorspace handling. I'll see if I can come back
>> to that later today. I'm not sure if it is correct, but to be honest I doubt
>> that there is any JPEG encoder that does this right anyway.
>>
> 
> And I'd say it's probably wrong, since we let the user change the colorspace,
> but we do not use that for anything.

So strictly speaking a JPEG encoder doesn't care about colorspace, xfer_func and
ycbcr_enc. It might care about quantization. It is my understanding that a JPEG
encoder expects full range Y'CbCr instead of limited range Y'CbCr. Does the HW
support limited range as well? I.e. can it convert from limited to full range
in hardware?

It might also be that it doesn't care so passing a limited range Y'CbCr image will
create a limited range JPEG file and software will have to know that it contains
limited range data when decoding it.

In any case, colorspace, xfer_func and ycbcr_enc can just be passed from the
output to the capture side, just like other codecs. What to do with 'quantization'
depends on the hardware: if it can convert from limited to full range on the fly,
then it should be handled by the driver. If not, then copy it like the other fields.

> 
>> BTW, please show the 'v4l2-compliance -s' output in the cover letter for the
>> next version.
>>
> 
> OK, no problem.
> 
> Thanks!
> Eze
> 

Regards,

	Hans
