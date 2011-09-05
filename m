Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:62862 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1IEIzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 04:55:52 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] at91: add Atmel ISI and ov2640 support on m10/g45 board.
Date: Mon, 5 Sep 2011 16:55:16 +0800
Message-ID: <4C79549CB6F772498162A641D92D532802A0995F@penmb01.corp.atmel.com>
In-Reply-To: <20110902182137.GL20128@game.jcrosoft.org>
References: <1314960609-23396-1-git-send-email-josh.wu@atmel.com> <20110902182137.GL20128@game.jcrosoft.org>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	<g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/03/2011 2:22 AM Jean-Christophe PLAGNIOL-VILLARD wrote: 

>>  
>>  #include <asm/setup.h>
>>  #include <asm/mach-types.h>
>> @@ -194,6 +197,95 @@ static void __init ek_add_device_nand(void)
>>  	at91_add_device_nand(&ek_nand_data);
>>  }
>>  
>> +/*
>> + *  ISI
>> + */
>> +#if defined(CONFIG_VIDEO_ATMEL_ISI) || defined(CONFIG_VIDEO_ATMEL_ISI_MODULE)
>> +static struct isi_platform_data __initdata isi_data = {
>> +	.frate		= ISI_CFG1_FRATE_CAPTURE_ALL,
>> +	.has_emb_sync	= 0,
>> +	.emb_crc_sync = 0,
>> +	.hsync_act_low = 0,
>> +	.vsync_act_low = 0,
>> +	.pclk_act_falling = 0,
>> +	/* to use codec and preview path simultaneously */
>> +	.isi_full_mode = 1,
>> +	.data_width_flags = ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10,
>> +};
>> +
>> +static void __init isi_set_clk(void)
>> +{
>> +	struct clk *pck1;
>> +	struct clk *plla;
>> +
>> +	pck1 = clk_get(NULL, "pck1");
>> +	plla = clk_get(NULL, "plla");
>> +
>> +	clk_set_parent(pck1, plla);
>> +	clk_set_rate(pck1, 25000000);
>> +	clk_enable(pck1);

> you must not enable the clock always

> you must enable it just when you need it

> and manage the clock at the board level really so so

I see, I will move such clock code to atmel_isi.c driver and add clock name, clock frequence to isi_platform_data structure in next version.

Thanks.
Best Regards,
Josh Wu

> Best Regards,
> J.
