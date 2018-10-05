Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:33374 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbeJENz1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 09:55:27 -0400
Subject: Re: s5p_mfc and H.264 frame cropping question
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        snawrocki@kernel.org, nicolas@ndufresne.ca,
        maxime.ripard@free-electrons.com, svarbanov@mm-sol.com
References: <5eebb2ed-8f58-84c3-6589-a2579c0004dd@xs4all.nl>
 <CAAFQd5C3VX4YQ8gqg8GONxn9jVMgTZ4A6ryrpg+aNwiWrVdE2A@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <48187103-d0f2-b134-27f4-dae6781a4f1b@xs4all.nl>
Date: Fri, 5 Oct 2018 08:58:01 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5C3VX4YQ8gqg8GONxn9jVMgTZ4A6ryrpg+aNwiWrVdE2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2018 05:12 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Fri, Oct 5, 2018 at 5:02 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> Hi all,
>>
>> I'm looking at removing the last users of vidioc_g/s_crop from the driver and
>> I came across vidioc_g_crop in drivers/media/platform/s5p-mfc/s5p_mfc_dec.c.
>>
>> What this really does AFAICS is return the H.264 frame crop as read from the
>> bitstream. This has nothing to do with regular cropping/composing but it might be
>> something that could be implemented as a new selection target.
> 
> It has a lot to do, because the output frame buffer may contain (and
> on the hardware I worked with, s5p-mfc and mtk-vcodec, indeed does)
> the whole encoded stream and the frame crop from the bitstream
> specifies the rectangle within it that corresponds to the part that
> should be displayed.

Yes, but is that part actually cropped? Or is the full uncropped image DMAed
to the capture buffer?

To take a practical example: a H.264 stream with a 1920x1088 image and a frame
crop rectangle of 1920x1080. What is the G_FMT width/height for the decoder
capture stream: 1920x1088 or 1920x1080?

If it is 1920x1088, then you have a compose rectangle. If it is 1920x1080 then
you have a crop rectangle.

As far as I can tell from this driver it actually has a compose rectangle
and the use of g_crop is wrong and is there due to historical reasons (the
driver predates the selection API).

> 
>>
>> I'm not really sure what to do with the existing code since it is an abuse of
>> the crop API, but I guess the first step is to decide how this should be handled
>> properly.
>>
>> Are there other decoders that can retrieve this information? Should this be
>> mentioned in the stateful codec API?
> 
> coda [1], mtk-vcodec [2] and venus [3] expose this using the
> V4L2_SEL_TGT_COMPOSE selection target. v1 of the specification defines
> the selection targets in a way, which is compatible with that:
> V4L2_SEL_TGT_COMPOSE defaults to V4L2_SEL_TGT_COMPOSE_DEFAULT, which
> equals to V4L2_SEL_TGT_CROP, which defaults to
> V4L2_SEL_TGT_CROP_DEFAULT, which is defined as follows:
> 
> +      ``V4L2_SEL_TGT_CROP_DEFAULT``
> +          a rectangle covering the part of the frame buffer that contains
> +          meaningful picture data (visible area); width and height will be
> +          equal to visible resolution of the stream

Where do you get that from? That's the crop definition for an output stream,
not a capture stream (assuming we have a codec).

I kind of lost you with "which equals to V4L2_SEL_TGT_CROP".

In any case, this particular driver should implement g_selection for
CAPTURE and implement the COMPOSE targets. That makes sense.

Regards,

	Hans

> 
> AFAIR s5p-mfc was added before the selection API went into active use,
> so there is some user space that relies on the crop API. We should
> make the driver expose proper selection targets and add a comment next
> to the crop API implementation explaining the historical reasons. The
> specification should mention only the selection API.
> 
> [1] https://elixir.bootlin.com/linux/v4.19-rc6/source/drivers/media/platform/coda/coda-common.c#L892
> [2] https://elixir.bootlin.com/linux/v4.19-rc6/source/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c#L740
> [3] https://elixir.bootlin.com/linux/v4.19-rc6/source/drivers/media/platform/qcom/venus/vdec.c#L300
> 
> Best regards,
> Tomasz
> 
