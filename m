Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63052 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3C0Rv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 13:51:26 -0400
Message-id: <5153319B.4050806@samsung.com>
Date: Wed, 27 Mar 2013 18:51:23 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Prasanna Kumar <prasanna.ps@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] s5p-mfc: Change MFC clock reference w.r.t Common
 Clock Framework
References: <1364275251-31394-1-git-send-email-prasanna.ps@samsung.com>
 <20130327020102.4014.2171@quantum>
In-reply-to: <20130327020102.4014.2171@quantum>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/27/2013 03:01 AM, Mike Turquette wrote:
> Quoting Prasanna Kumar (2013-03-25 22:20:51)
>> From: Prasanna Kumar <prasanna.ps@samsung.com>
>>
>> According to Common Clock framework , modified the method of getting

Huh ? Could you explain in detail what exactly in this patch is related
to the Common Clock Framework ? I guess you mean the new clocks driver ?

>> clock for MFC Block.
>>
>> Signed-off-by: Prasanna Kumar <prasanna.ps@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
>> index 6aa38a5..b8ac8f6 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
>> @@ -50,7 +50,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
>>                 goto err_p_ip_clk;
>>         }
>>  
>> -       pm->clock = clk_get(&dev->plat_dev->dev, dev->variant->mclk_name);
>> +       pm->clock = clk_get_parent(pm->clock_gate);
> 
> Ok, I'll bite.  Why make this change?  Was there an issue using
> clkdev/clk_get to get the clock you needed?

Yes, this appears a pretty mysterious change to me... I wonder, have
you altered anything at the clock tree definition to make it work ?
What platforms has this change been tested on ? For Exynos4, I've
changed the sclk_mfc clock definition, so it is possible to assign it
to the MFC IP by listing it in the codec DT node clocks property.
I suppose something similar is needed for Exynos5, if this is the
platform you needed that change for.

BTW, I think the mclk_name field should be removed from struct
s5p_mfc_variant, an the driver should use fixed name for the
second clock. Now there is "mfc", "sclk_mfc" used for Exynos4 and
"mfc", "aclk_133" for Exynos5. Drivers are not really supposed to
care about differences like this. Such differences could be easily
handled in the device tree. The DT binding documentation just
needs to specify the meaning of each clock name.

[1] http://www.spinics.net/lists/arm-kernel/msg233521.html

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
