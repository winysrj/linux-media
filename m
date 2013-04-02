Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43965 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178Ab3DBNR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 09:17:28 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKM008K9Q8L6O80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Apr 2013 14:17:26 +0100 (BST)
Message-id: <515ADA65.4040100@samsung.com>
Date: Tue, 02 Apr 2013 15:17:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/23] [media] exynos: remove unnecessary header inclusions
References: <1362505353-8873-1-git-send-email-arnd@arndb.de>
 <1362505353-8873-11-git-send-email-arnd@arndb.de>
 <515AD837.1060106@samsung.com>
In-reply-to: <515AD837.1060106@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/02/2013 03:08 PM, Sylwester Nawrocki wrote:
> On 03/05/2013 06:42 PM, Arnd Bergmann wrote:
>> In multiplatform configurations, we cannot include headers
>> provided by only the exynos platform. Fortunately a number
>> of drivers that include those headers do not actually need
>> them, so we can just remove the inclusions.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/media/platform/exynos-gsc/gsc-regs.c | 1 -
>>  drivers/media/platform/s5p-tv/sii9234_drv.c  | 3 ---
> 
> Cc: linux-media@vger.kernel.org

Uhh, now really added it to Cc.

> Thanks Arnd. I have applied this patch to my tree for 3.10.
> 
>>  2 files changed, 4 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
>> index 6f5b5a4..e22d147 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-regs.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
>> @@ -12,7 +12,6 @@
>>  
>>  #include <linux/io.h>
>>  #include <linux/delay.h>
>> -#include <mach/map.h>
>>  
>>  #include "gsc-core.h"
>>  
>> diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
>> index d90d228..39b77d2 100644
>> --- a/drivers/media/platform/s5p-tv/sii9234_drv.c
>> +++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
>> @@ -23,9 +23,6 @@
>>  #include <linux/regulator/machine.h>
>>  #include <linux/slab.h>
>>  
>> -#include <mach/gpio.h>
>> -#include <plat/gpio-cfg.h>
>> -
>>  #include <media/sii9234.h>
>>  #include <media/v4l2-subdev.h>
> 
> --
> 
> Regards,
> Sylwester
