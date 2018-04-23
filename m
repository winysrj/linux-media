Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51774 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbeDWGXj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 02:23:39 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20180423062337euoutp0251f23de08a31a92bf08d85ffd2b027e6~n-H4UNCD90233102331euoutp02h
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 06:23:37 +0000 (GMT)
Subject: Re: [PATCH] media: s5p-jpeg: don't return a value on a void
 function
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-ID: <732007af-de97-084d-8e3f-2c9b7de700f4@samsung.com>
Date: Mon, 23 Apr 2018 08:23:33 +0200
MIME-Version: 1.0
In-Reply-To: <4376a97a-bb22-056b-4a63-8838c0c2d3f8@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
References: <180af45d9964a4d9855066b8f74a8629625acfa2.1524250913.git.mchehab@s-opensource.com>
        <CGME20180420191157epcas1p2daac97ef3159bea632c90da23da8063f@epcas1p2.samsung.com>
        <4376a97a-bb22-056b-4a63-8838c0c2d3f8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

W dniu 20.04.2018 o 21:10, Jacek Anaszewski pisze:
> Hi Mauro,
> 
> Thank you for the patch.
> 
> On 04/20/2018 09:01 PM, Mauro Carvalho Chehab wrote:
>> Building this driver on arm64 gives this warning:
>> 	drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c:430:16: error: return expression in void function
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> ---
>>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
>> index 0974b9a7a584..0861842b2dfc 100644
>> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
>> @@ -425,9 +425,9 @@ unsigned int exynos3250_jpeg_get_int_status(void __iomem *regs)
>>   }
>>   
>>   void exynos3250_jpeg_clear_int_status(void __iomem *regs,
>> -						unsigned int value)
>> +				      unsigned int value)
>>   {
>> -	return writel(value, regs + EXYNOS3250_JPGINTST);
>> +	writel(value, regs + EXYNOS3250_JPGINTST);
>>   }
>>   
>>   unsigned int exynos3250_jpeg_operating(void __iomem *regs)
>>
> 
> Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> 

Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
