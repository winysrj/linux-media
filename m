Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:15039 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932232AbbDMKRq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 06:17:46 -0400
Message-ID: <552B97AD.8080509@atmel.com>
Date: Mon, 13 Apr 2015 18:17:17 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] media: atmel-isi: remove the useless code which
 disable isi
References: <1428570108-4961-1-git-send-email-josh.wu@atmel.com> <1428570108-4961-2-git-send-email-josh.wu@atmel.com> <2109629.IWfKzc1IIn@avalon>
In-Reply-To: <2109629.IWfKzc1IIn@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 4/12/2015 9:10 PM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Thursday 09 April 2015 17:01:46 Josh Wu wrote:
>> To program ISI control register, the pixel clock should be enabled.
> That's an awful hardware design :-(

yes, But I need to live with this.

>
>> So without pixel clock (from sensor) enabled, disable ISI controller is
>> not make sense. So this patch remove those code.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>
>> Changes in v2:
>> - this file is new added.
>>
>>   drivers/media/platform/soc_camera/atmel-isi.c | 5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>> b/drivers/media/platform/soc_camera/atmel-isi.c index c125b1d..31254b4
>> 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -131,8 +131,6 @@ static int configure_geometry(struct atmel_isi *isi, u32
>> width, return -EINVAL;
>>   	}
>>
>> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> -
>>   	cfg2 = isi_readl(isi, ISI_CFG2);
> Can the configuration registers be accessed when the pixel clock is disabled ?

yes, it can be accessed. The CFG1, CFG2 are not impacted.

So far as I know only the ISI_CR is impacted, we can 
disable/enable/reset ISI by set ISI_CR.
Since ISI_CR register will work with pixel clock, so you need to poll 
the ISI_SR to verify your control of ISI is effective.

Best Regards,
Josh Wu

>
>>   	/* Set YCC swap mode */
>>   	cfg2 &= ~ISI_CFG2_YCC_SWAP_MODE_MASK;
>> @@ -843,7 +841,6 @@ static int isi_camera_set_bus_param(struct
>> soc_camera_device *icd)
>>
>>   	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
>>
>> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>>   	isi_writel(isi, ISI_CFG1, cfg1);
>>
>>   	return 0;
>> @@ -1022,8 +1019,6 @@ static int atmel_isi_probe(struct platform_device
>> *pdev) if (isi->pdata.data_width_flags & ISI_DATAWIDTH_10)
>>   		isi->width_flags |= 1 << 9;
>>
>> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> -
>>   	irq = platform_get_irq(pdev, 0);
>>   	if (IS_ERR_VALUE(irq)) {
>>   		ret = irq;

