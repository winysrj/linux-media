Return-path: <mchehab@localhost>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64065 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab1GGNea (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 09:34:30 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNY00B6ATPHY8@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Jul 2011 14:34:29 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNY00IX3TPF13@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Jul 2011 14:34:28 +0100 (BST)
Date: Thu, 07 Jul 2011 15:34:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/3] s5p-csis: Handle all available power supplies
In-reply-to: <201107062347.01766.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <4E15B5E3.7050204@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1309972421-29690-1-git-send-email-s.nawrocki@samsung.com>
 <1309972421-29690-2-git-send-email-s.nawrocki@samsung.com>
 <201107062347.01766.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Laurent,

On 07/06/2011 11:47 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Wednesday 06 July 2011 19:13:39 Sylwester Nawrocki wrote:
>> On the SoCs this driver is intended to support the are three
>> separate pins to supply the MIPI-CSIS subsystem: 1.1V or 1.2V,
>> 1.8V and power supply for an internal PLL.
>> This patch adds support for two separate voltage supplies
>> to cover properly board configurations where PMIC requires
>> to configure independently each external supply of the MIPI-CSI
>> device. The 1.8V and PLL supply are assigned a single "vdd18"
>> regulator supply as it seems more reasonable than creating
>> separate regulator supplies for them.
>>
>> Reported-by: HeungJun Kim <riverful.kim@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/s5p-fimc/mipi-csis.c |   42
>> +++++++++++++++++------------ 1 files changed, 25 insertions(+), 17
>> deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c
>> b/drivers/media/video/s5p-fimc/mipi-csis.c index ef056d6..4a529b4 100644
>> --- a/drivers/media/video/s5p-fimc/mipi-csis.c
>> +++ b/drivers/media/video/s5p-fimc/mipi-csis.c
>> @@ -81,6 +81,12 @@ static char *csi_clock_name[] = {
>>  };
>>  #define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
>>
>> +static const char * const csis_supply_name[] = {
>> +	"vdd11", /* 1.1V or 1.2V (s5pc100) MIPI CSI suppply */
>> +	"vdd18", /* VDD 1.8V and MIPI CSI PLL supply */
>> +};
>> +#define CSIS_NUM_SUPPLIES ARRAY_SIZE(csis_supply_name)
>> +
>>  enum {
>>  	ST_POWERED	= 1,
>>  	ST_STREAMING	= 2,
>> @@ -109,9 +115,9 @@ struct csis_state {
>>  	struct platform_device *pdev;
>>  	struct resource *regs_res;
>>  	void __iomem *regs;
>> +	struct regulator_bulk_data supply[CSIS_NUM_SUPPLIES];
> 
> I would have called this supplies, but that's nitpicking. Otherwise the patch 
> looks good to me.

No problem, I have already renamed it. It seems to make more sense like this.
Thanks for the review!


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
