Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37411 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbZLCTb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 14:31:27 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 3 Dec 2009 13:31:31 -0600
Subject: RE: [PATCH 2/2] DaVinci - vpfe capture - converting ccdc to
 platform driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40155B775B6@dlee06.ent.ti.com>
References: <1259691333-32164-1-git-send-email-m-karicheri2@ti.com>
 <1259691333-32164-2-git-send-email-m-karicheri2@ti.com>
 <19F8576C6E063C45BE387C64729E7394043716AE12@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394043716AE12@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> -	/*
>> -	 * setup Mux configuration for vpfe input and register
>> -	 * vpfe capture platform device
>> -	 */
>> -	davinci_cfg_reg(DM355_VIN_PCLK);
>> -	davinci_cfg_reg(DM355_VIN_CAM_WEN);
>> -	davinci_cfg_reg(DM355_VIN_CAM_VD);
>> -	davinci_cfg_reg(DM355_VIN_CAM_HD);
>> -	davinci_cfg_reg(DM355_VIN_YIN_EN);
>> -	davinci_cfg_reg(DM355_VIN_CINL_EN);
>> -	davinci_cfg_reg(DM355_VIN_CINH_EN);
>[Hiremath, Vaibhav] Why have you removed mux configuration from here and
>moved to CCDC driver? Any specific reason?
>
Good catch. I wanted to do this clean up, but missed it. Actually platform data should have a function setup_pinmux() to set up the pin mux for the
ccdc input. This function will be defined in the platform file and will be
called during probe()

Murali
>> +	platform_device_register(&dm355_ccdc_dev);
>>  	platform_device_register(&vpfe_capture_dev);
>>
>>  	return 0;
>> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-
>> davinci/dm644x.c
>> index 2cd0081..982be1f 100644
>> --- a/arch/arm/mach-davinci/dm644x.c
>> +++ b/arch/arm/mach-davinci/dm644x.c
>> @@ -612,6 +612,11 @@ static struct resource vpfe_resources[] = {
>>  		.end            = IRQ_VDINT1,
>>  		.flags          = IORESOURCE_IRQ,
>>  	},
>> +};
>> +
>> +static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
>> +static struct resource dm644x_ccdc_resource[] = {
>> +	/* CCDC Base address */
>>  	{
>>  		.start          = 0x01c70400,
>>  		.end            = 0x01c70400 + 0xff,
>> @@ -619,7 +624,17 @@ static struct resource vpfe_resources[] = {
>>  	},
>>  };
>>
>> -static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
>> +static struct platform_device dm644x_ccdc_dev = {
>> +	.name           = "dm644x_ccdc",
>> +	.id             = -1,
>> +	.num_resources  = ARRAY_SIZE(dm644x_ccdc_resource),
>> +	.resource       = dm644x_ccdc_resource,
>> +	.dev = {
>> +		.dma_mask               = &vpfe_capture_dma_mask,
>> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
>> +	},
>> +};
>> +
>>  static struct platform_device vpfe_capture_dev = {
>>  	.name		= CAPTURE_DRV_NAME,
>>  	.id		= -1,
>> @@ -772,6 +787,7 @@ static int __init dm644x_init_devices(void)
>>  	platform_device_register(&dm644x_edma_device);
>>  	platform_device_register(&dm644x_emac_device);
>>  	platform_device_register(&dm644x_vpss_device);
>> +	platform_device_register(&dm644x_ccdc_dev);
>>  	platform_device_register(&vpfe_capture_dev);
>>
>>  	return 0;
>> --
>> 1.6.0.4

