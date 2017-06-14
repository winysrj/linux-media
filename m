Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22481 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdFNMDT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 08:03:19 -0400
Subject: Re: [PATCH 1/9] [media] s5p-jpeg: Reset the Codec before doing a soft
 reset
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <0ce70398-3018-e240-7ea3-f0c053409ea3@samsung.com>
Date: Wed, 14 Jun 2017 14:03:13 +0200
MIME-version: 1.0
In-reply-to: <ace9b515-7dd6-d6c0-ce74-b73b9adc30de@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-2-git-send-email-thierry.escande@collabora.com>
 <359e198e-df2b-ef47-17b9-cefe4b7ff220@gmail.com>
 <4093ab04-710b-2141-ec16-62547fb4e66f@collabora.com>
 <CGME20170613184748epcas2p282dbceadde3367f53a6842a3b40c1a91@epcas2p2.samsung.com>
 <ace9b515-7dd6-d6c0-ce74-b73b9adc30de@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

W dniu 13.06.2017 o 20:46, Jacek Anaszewski pisze:
> Hi Thierry,
> 
> On 06/07/2017 02:34 PM, Thierry Escande wrote:
>> Hi Jacek,
>>
>> On 02/06/2017 21:50, Jacek Anaszewski wrote:
>>> Hi Thierry,
>>>
>>> On 06/02/2017 06:02 PM, Thierry Escande wrote:
>>>> From: Abhilash Kesavan <a.kesavan@samsung.com>
>>>>
>>>> This patch resets the encoding and decoding register bits before doing a
>>>> soft reset.
>>>>
>>>> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
>>>> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
>>>> ---
>>>>    drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>>> b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>>> index a1d823a..9ad8f6d 100644
>>>> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>>> @@ -21,6 +21,10 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
>>>>        unsigned int reg;
>>>>          reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
>>>> +    writel(reg & ~(EXYNOS4_DEC_MODE | EXYNOS4_ENC_MODE),
>>>> +           base + EXYNOS4_JPEG_CNTL_REG);
>>>
>>> Why is it required? It would be nice if commit message explained that.
>>
>> Unfortunately the bug entry in the ChromeOS issue tracker does not
>> mention more information about that and the patch author is no more
>> reachable on that email address.
>>
>> So unless someone else knows the answer I won't be able to give more
>> explanation in the commit message...
> 
> Unfortunately I don't have longer access to the hardware and
> can't test these changes. Have you tested them, or just cherry-picked
> from the bug tracker?
> 

I do have access to the hardware and will look into the series,
however results can be expected next week.

Andrzej
