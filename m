Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36452 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752337AbdFMSra (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 14:47:30 -0400
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: Re: [PATCH 1/9] [media] s5p-jpeg: Reset the Codec before doing a soft
 reset
To: Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-2-git-send-email-thierry.escande@collabora.com>
 <359e198e-df2b-ef47-17b9-cefe4b7ff220@gmail.com>
 <4093ab04-710b-2141-ec16-62547fb4e66f@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <ace9b515-7dd6-d6c0-ce74-b73b9adc30de@gmail.com>
Date: Tue, 13 Jun 2017 20:46:44 +0200
MIME-Version: 1.0
In-Reply-To: <4093ab04-710b-2141-ec16-62547fb4e66f@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On 06/07/2017 02:34 PM, Thierry Escande wrote:
> Hi Jacek,
> 
> On 02/06/2017 21:50, Jacek Anaszewski wrote:
>> Hi Thierry,
>>
>> On 06/02/2017 06:02 PM, Thierry Escande wrote:
>>> From: Abhilash Kesavan <a.kesavan@samsung.com>
>>>
>>> This patch resets the encoding and decoding register bits before doing a
>>> soft reset.
>>>
>>> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
>>> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
>>> ---
>>>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>> b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>> index a1d823a..9ad8f6d 100644
>>> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>> @@ -21,6 +21,10 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
>>>       unsigned int reg;
>>>         reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
>>> +    writel(reg & ~(EXYNOS4_DEC_MODE | EXYNOS4_ENC_MODE),
>>> +           base + EXYNOS4_JPEG_CNTL_REG);
>>
>> Why is it required? It would be nice if commit message explained that.
> 
> Unfortunately the bug entry in the ChromeOS issue tracker does not
> mention more information about that and the patch author is no more
> reachable on that email address.
> 
> So unless someone else knows the answer I won't be able to give more
> explanation in the commit message...

Unfortunately I don't have longer access to the hardware and
can't test these changes. Have you tested them, or just cherry-picked
from the bug tracker?

-- 
Best regards,
Jacek Anaszewski
