Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33483 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdFTKwB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 06:52:01 -0400
Subject: Re: [PATCH v2 5/6] [media] s5p-jpeg: Add support for resolution change
 event
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <25bfed86-d208-4f70-5b55-d3eb56ba9ed5@samsung.com>
Date: Tue, 20 Jun 2017 12:51:55 +0200
MIME-version: 1.0
In-reply-to: <d214a1d2-bce4-ea46-866c-6e35d16f26c9@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170612171431epcas5p19a448035865da056440a819f17875601@epcas5p1.samsung.com>
 <1497287605-20074-6-git-send-email-thierry.escande@collabora.com>
 <dd3fa8e9-48e2-ab1d-4b4e-da63900c08d6@samsung.com>
 <d214a1d2-bce4-ea46-866c-6e35d16f26c9@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

W dniu 19.06.2017 o 15:50, Thierry Escande pisze:
> Hi Andrzej,
> 
> On 16/06/2017 17:38, Andrzej Pietrasiewicz wrote:
>> Hi Thierry,
>>
>> Thank you for the patch.
>>
>> Can you give a use case for resolution change event?
> Unfortunately, the original commit does not mention any clear use case.
> I've asked to the patch author for more information.

Can you please share what you learn about it if the author gets back to you?
Now that we don't know why to apply a patch I guess we should not do it.

> 

<snip>

>>> @@ -2510,43 +2567,18 @@ static void s5p_jpeg_buf_queue(struct
>>> vb2_buffer *vb)
>>>                return;
>>>            }
>>> -        q_data = &ctx->out_q;
>>> -        q_data->w = tmp.w;
>>> -        q_data->h = tmp.h;
>>> -        q_data->sos = tmp.sos;
>>> -        memcpy(q_data->dht.marker, tmp.dht.marker,
>>> -               sizeof(tmp.dht.marker));
>>> -        memcpy(q_data->dht.len, tmp.dht.len, sizeof(tmp.dht.len));
>>> -        q_data->dht.n = tmp.dht.n;
>>> -        memcpy(q_data->dqt.marker, tmp.dqt.marker,
>>> -               sizeof(tmp.dqt.marker));
>>> -        memcpy(q_data->dqt.len, tmp.dqt.len, sizeof(tmp.dqt.len));
>>> -        q_data->dqt.n = tmp.dqt.n;
>>> -        q_data->sof = tmp.sof;
>>> -        q_data->sof_len = tmp.sof_len;
>>> -
>>> -        q_data = &ctx->cap_q;
>>> -        q_data->w = tmp.w;
>>> -        q_data->h = tmp.h;
>>
>>
>> Why is this part removed?
> This has not been removed.
> The &tmp s5p_jpeg_q_data struct was passed to s5p_jpeg_parse_hdr() and
> then copied field-by-field into ctx->out_q (through q_data pointer).
> With this change ctx->out_q is passed to s5p_jpeg_parse_hdr() and this
> avoids the copy.

It seems that changing field-by-field copying to passing a pointer
directly to s5p_jpeg_parse_hdr() is an unrelated change and as such
should be in a separate patch.

Andrzej
