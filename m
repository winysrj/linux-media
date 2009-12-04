Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41337 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbZLDXL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 18:11:57 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 4 Dec 2009 17:12:02 -0600
Subject: RE: [PATCH - v0 2/2] DaVinci - vpfe capture - Make clocks
 configurable
Message-ID: <A69FA2915331DC488A831521EAE36FE40155BEBE26@dlee06.ent.ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
 <1259687940-31435-2-git-send-email-m-karicheri2@ti.com>
 <19F8576C6E063C45BE387C64729E7394043716B186@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,

Could you confirm my question below? I need to submit a patch on Monday.

>>Currently we have vpfe_capture.c file (master/bridge driver) which is
>>handling clk_get/put, and platform data is providing the details about it.
>>Ideally we should handle it in respective ccdc driver file, since he has
>>all the knowledge about required number of clocks and its name. This way
>we
>>don't have to maintain/pass clock information in platform data.
>>
>>I would appreciate any comments/thoughts/pointers here.
>>

>Though I agree that this clock could be set by the ccdc driver, I am not
>sure if the same clock is used by an IP on different SOCs. For example take
>the case of ccdc on DM6446 which is also used on OMAP 35xx SOC. Do they use
>vpss master and slave clocks as is done on DM6446? If this is true, then we
>could set the clock inside ccdc driver.
>
>Let me know so that I can re-work the patch and send it to the list.
>
>Murali
>>Thanks,
>>Vaibhav
>>
>>>  };
>>>
>>>  static struct platform_device *davinci_evm_devices[] __initdata = {
>>> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c
>>> b/arch/arm/mach-davinci/board-dm644x-evm.c
>>> index fd0398b..45beb99 100644
>>> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
>>> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
>>> @@ -250,6 +250,8 @@ static struct vpfe_config vpfe_cfg = {
>>>  	.sub_devs = vpfe_sub_devs,
>>>  	.card_name = "DM6446 EVM",
>>>  	.ccdc = "DM6446 CCDC",
>>> +	.num_clocks = 2,
>>> +	.clocks = {"vpss_master", "vpss_slave"},
>>>  };
>>>
>>>  static struct platform_device rtc_dev = {
>>> --
>>> 1.6.0.4

