Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f50.google.com ([209.85.160.50]:33804 "EHLO
        mail-pl0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbeFUEaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 00:30:04 -0400
Received: by mail-pl0-f50.google.com with SMTP id g20-v6so954447plq.1
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2018 21:30:04 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced
 scanning
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        linux-media@vger.kernel.org, kernel@pengutronix.de
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
 <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
 <1528708771.3818.7.camel@pengutronix.de>
 <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
 <2aff8f80-aa79-6718-6183-6e49088ae498@redhat.com>
 <f6e7eaa3-355e-a5d9-1be5-e5db08a99897@gmail.com> <m3h8m5yaeh.fsf@t19.piap.pl>
 <798b8ad7-2fce-8408-b1c4-c2954f524d23@gmail.com> <m336xoxxcd.fsf@t19.piap.pl>
 <20db0ee3-1202-67fd-84b9-d6e0255dec06@gmail.com>
 <1529484851.4008.1.camel@pengutronix.de>
Message-ID: <26996359-69a2-9465-e7ab-4807de27b8bb@gmail.com>
Date: Wed, 20 Jun 2018 21:30:01 -0700
MIME-Version: 1.0
In-Reply-To: <1529484851.4008.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/20/2018 01:54 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Tue, 2018-06-19 at 18:30 -0700, Steve Longerbeam wrote:
>> I've found some time to diagnose the behavior of interweave with B/T line
>> swapping (to support interlaced-bt) with planar formats.
>>
>> There are a couple problems (one known and one unknown):
>>
>> 1. This requires 32 pixel alignment to meet the IDMAC 8-byte alignment
>>       of the planar U/V buffer offsets, and 32 pixel alignment precludes
>>       capturing raw NTSC/PAL at 720 pixel line stride.
> What needs to be aligned to multiples of 32 pixels?
>
> I thought 8 pixel width alignment should be good enough for NV12/NV16,
> for which luma and chroma strides are equal to the width in pixels, and
> 16 pixel alignment for YUV420/YVU420/YUV422P, where chroma stride is
> half the width in pixels.

I see where the problem is now. I was basing my mistaken 32 pixel
alignment from a read of the U_OFFSET/V_OFFSET macros in
ipu-cpmem.c:

u_offset = pix->width * pix->height + pix->width * y / 4 + x / 2

But you can probably see the bug now. This does not produce
a correct offset for odd values of y. It should read:

u_offset = pix->width * pix->height + pix->width * (y / 2) / 2 + x / 2

With that fix, interweave line swap with planar 4:2:0 is working now.
That includes YUV420, YVU420, and NV12.

NV16 is also working after programming SLUV with double
the chroma line stride.

>> 2. Even with 32 pixel aligned frames, for example by using the prpenc scaler
>>       to generate 704 pixel strides from 720, the colors are still wrong when
>>       capturing interlaced-bt.
> As a side note, we can't properly scale seq-tb/bt direct input from the
> CSI vertically with the IC, as the bottom line of the first field will
> be blended with the top line of the second field...
>
>>   I thought for sure this must be because we
>> also
>>       need to double the SLUV line strides in addition to doubling SLY
>> line stride.
>>       But I tried this and the results are that it works only for YUV
>> 4:2:2. For 4:2:0
>>       it causes system hard lockups. (Aside note: interweave without line
>> swap
>>       apparently has never worked for 4:2:2, even when doubling SLUV, so it's
>>       quite bizarre to me why 4:2:2 interweave _with_ line swap _does_ work
>>       after doubling SLUV).
> When you say 4:2:2 you only mean YUV422P, not NV16 or YUYV/UYVY ?

Correct, I meant planar YUV422P.


>
>> For these reasons I think we should disallow interlaced-bt with planar
>> formats.
> Does that include NV12/NV16? Capturing to NV12 could be desirable if at
> all possible, because the result can be encoded by the CODA. The other
> formats are bandwidth inefficient anyway.

Never mind, I found the bug described above in the U_OFFSET/V_OFFSET
macros.

In summary, at this point all planar formats are working with interlaced
bt and tb, except for YUV422P.

Steve
