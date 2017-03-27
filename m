Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34799 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752536AbdC0Ltb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 07:49:31 -0400
Received: by mail-wr0-f180.google.com with SMTP id l43so52730627wre.1
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 04:49:30 -0700 (PDT)
Subject: Re: [PATCH v7 5/9] media: venus: vdec: add video decoder files
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
 <1489423058-12492-6-git-send-email-stanimir.varbanov@linaro.org>
 <52b39f43-6f70-0cf6-abaf-4bb5bd2b3d86@xs4all.nl>
 <be41ccbd-3ff1-bcae-c423-1acc68f35694@mm-sol.com>
 <6ea4524d-9794-a9b5-8327-367152c92493@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <7ae41d9d-d5fb-367c-ea08-c9a1bc818ffe@linaro.org>
Date: Mon, 27 Mar 2017 14:49:21 +0300
MIME-Version: 1.0
In-Reply-To: <6ea4524d-9794-a9b5-8327-367152c92493@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/27/2017 11:45 AM, Hans Verkuil wrote:
> On 25/03/17 23:30, Stanimir Varbanov wrote:
>> Thanks for the comments!

<snip>

>>>> +static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>>>> +              u32 tag, u32 bytesused, u32 data_offset, u32 flags,
>>>> +              u64 timestamp_us)
>>>> +{
>>>> +    struct vb2_v4l2_buffer *vbuf;
>>>> +    struct vb2_buffer *vb;
>>>> +    unsigned int type;
>>>> +
>>>> +    if (buf_type == HFI_BUFFER_INPUT)
>>>> +        type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>>>> +    else
>>>> +        type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>>>> +
>>>> +    vbuf = helper_find_buf(inst, type, tag);
>>>> +    if (!vbuf)
>>>> +        return;
>>>> +
>>>> +    vbuf->flags = flags;
>>>> +
>>>> +    if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>>>> +        vb = &vbuf->vb2_buf;
>>>> +        vb->planes[0].bytesused =
>>>> +            max_t(unsigned int, inst->output_buf_size, bytesused);
>>>> +        vb->planes[0].data_offset = data_offset;
>>>> +        vb->timestamp = timestamp_us * NSEC_PER_USEC;
>>>> +        vbuf->sequence = inst->sequence++;
>>>
>>> timestamp and sequence are only set for CAPTURE, not OUTPUT. Is that correct?
>>
>> Correct. I can add sequence for the OUTPUT queue too, but I have no idea how that sequence is used by userspace.
> 
> You set V4L2_BUF_FLAG_TIMESTAMP_COPY, so you have to copy the timestamp from the output buffer
> to the capture buffer, if that makes sense for this codec. If not, then you shouldn't use that

The timestamp_us is filled by firmware and it is the timestamp of the
output buffer which is used to produce the uncompressed capture buffer.
So I think V4L2_BUF_FLAG_TIMESTAMP_COPY is correctly used here.

> V4L2_BUF_FLAG and just generate new timestamps whenever a capture buffer is ready.
> 
> For sequence numbering just give the output queue its own sequence counter.

OK will do.

-- 
regards,
Stan
