Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59361 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbdFTOIn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 10:08:43 -0400
Subject: Re: [PATCH v2 5/6] [media] s5p-jpeg: Add support for resolution
 change event
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170612171431epcas5p19a448035865da056440a819f17875601@epcas5p1.samsung.com>
 <1497287605-20074-6-git-send-email-thierry.escande@collabora.com>
 <dd3fa8e9-48e2-ab1d-4b4e-da63900c08d6@samsung.com>
 <d214a1d2-bce4-ea46-866c-6e35d16f26c9@collabora.com>
 <25bfed86-d208-4f70-5b55-d3eb56ba9ed5@samsung.com>
From: Thierry Escande <thierry.escande@collabora.com>
Message-ID: <a6a50052-42cb-e4d7-a387-bea1f852345b@collabora.com>
Date: Tue, 20 Jun 2017 16:08:39 +0200
MIME-Version: 1.0
In-Reply-To: <25bfed86-d208-4f70-5b55-d3eb56ba9ed5@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On 20/06/2017 12:51, Andrzej Pietrasiewicz wrote:
> Hi Thierry,
> 
> W dniu 19.06.2017 o 15:50, Thierry Escande pisze:
>> Hi Andrzej,
>>
>> On 16/06/2017 17:38, Andrzej Pietrasiewicz wrote:
>>> Hi Thierry,
>>>
>>> Thank you for the patch.
>>>
>>> Can you give a use case for resolution change event?
>> Unfortunately, the original commit does not mention any clear use case.
>> I've asked to the patch author for more information.
> 
> Can you please share what you learn about it if the author gets back to 
> you?
> Now that we don't know why to apply a patch I guess we should not do it.
This event is used in Chromium by the V4L2 jpeg decode accelerator to 
allocate output buffer. Please see:
https://cs.chromium.org/chromium/src/media/gpu/v4l2_jpeg_decode_accelerator.cc?rcl=91793c6ef94f05e93d258db8c7f3cad59819c6b8&l=585

I'll add a note in the commit message.

> 
> <snip>
> 
>>>> @@ -2510,43 +2567,18 @@ static void s5p_jpeg_buf_queue(struct
>>>> vb2_buffer *vb)
>>>>                return;
>>>>            }
>>>> -        q_data = &ctx->out_q;
>>>> -        q_data->w = tmp.w;
>>>> -        q_data->h = tmp.h;
>>>> -        q_data->sos = tmp.sos;
>>>> -        memcpy(q_data->dht.marker, tmp.dht.marker,
>>>> -               sizeof(tmp.dht.marker));
>>>> -        memcpy(q_data->dht.len, tmp.dht.len, sizeof(tmp.dht.len));
>>>> -        q_data->dht.n = tmp.dht.n;
>>>> -        memcpy(q_data->dqt.marker, tmp.dqt.marker,
>>>> -               sizeof(tmp.dqt.marker));
>>>> -        memcpy(q_data->dqt.len, tmp.dqt.len, sizeof(tmp.dqt.len));
>>>> -        q_data->dqt.n = tmp.dqt.n;
>>>> -        q_data->sof = tmp.sof;
>>>> -        q_data->sof_len = tmp.sof_len;
>>>> -
>>>> -        q_data = &ctx->cap_q;
>>>> -        q_data->w = tmp.w;
>>>> -        q_data->h = tmp.h;
>>>
>>>
>>> Why is this part removed?
>> This has not been removed.
>> The &tmp s5p_jpeg_q_data struct was passed to s5p_jpeg_parse_hdr() and
>> then copied field-by-field into ctx->out_q (through q_data pointer).
>> With this change ctx->out_q is passed to s5p_jpeg_parse_hdr() and this
>> avoids the copy.
> 
> It seems that changing field-by-field copying to passing a pointer
> directly to s5p_jpeg_parse_hdr() is an unrelated change and as such
> should be in a separate patch.
Will do.

Regards,
  Thierry
