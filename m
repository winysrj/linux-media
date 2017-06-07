Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39417 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdFGMeg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 08:34:36 -0400
Subject: Re: [PATCH 1/9] [media] s5p-jpeg: Reset the Codec before doing a soft
 reset
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-2-git-send-email-thierry.escande@collabora.com>
 <359e198e-df2b-ef47-17b9-cefe4b7ff220@gmail.com>
From: Thierry Escande <thierry.escande@collabora.com>
Message-ID: <4093ab04-710b-2141-ec16-62547fb4e66f@collabora.com>
Date: Wed, 7 Jun 2017 14:34:31 +0200
MIME-Version: 1.0
In-Reply-To: <359e198e-df2b-ef47-17b9-cefe4b7ff220@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 02/06/2017 21:50, Jacek Anaszewski wrote:
> Hi Thierry,
> 
> On 06/02/2017 06:02 PM, Thierry Escande wrote:
>> From: Abhilash Kesavan <a.kesavan@samsung.com>
>>
>> This patch resets the encoding and decoding register bits before doing a
>> soft reset.
>>
>> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
>> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
>> ---
>>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>> index a1d823a..9ad8f6d 100644
>> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>> @@ -21,6 +21,10 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
>>   	unsigned int reg;
>>   
>>   	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
>> +	writel(reg & ~(EXYNOS4_DEC_MODE | EXYNOS4_ENC_MODE),
>> +	       base + EXYNOS4_JPEG_CNTL_REG);
> 
> Why is it required? It would be nice if commit message explained that.

Unfortunately the bug entry in the ChromeOS issue tracker does not 
mention more information about that and the patch author is no more 
reachable on that email address.

So unless someone else knows the answer I won't be able to give more 
explanation in the commit message...

Regards,
  Thierry
