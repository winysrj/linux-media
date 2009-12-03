Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53709 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZLCPzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 10:55:23 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 3 Dec 2009 09:55:27 -0600
Subject: RE: [PATCH - v0 2/2] DaVinci - vpfe capture - Make clocks
 configurable
Message-ID: <A69FA2915331DC488A831521EAE36FE40155B773C5@dlee06.ent.ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
 <1259687940-31435-2-git-send-email-m-karicheri2@ti.com>
 <19F8576C6E063C45BE387C64729E7394043716B186@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394043716B186@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>I was talking to Sekhar about this and actually he made some good points
>about this implementation.
>
>If we consider specific IP, then the required clocks would remain always be
>the same. There might be some devices which may not be using some clocks
>(so as that specific feature).
>
>Actually we are trying to create one more wrapper for clock configuration.
>Just to illustrate I am putting some other generic drivers examples -
>
>Omap-hsmmc.c -
>
>This driver requires 2 clocks, interface and functional. The devices which
>would be using this driver have to define clock with names "ick" and "fck".
>
>VPFE-Capture (Considering only current implementation) -
>
>Currently we have vpfe_capture.c file (master/bridge driver) which is
>handling clk_get/put, and platform data is providing the details about it.
>Ideally we should handle it in respective ccdc driver file, since he has
>all the knowledge about required number of clocks and its name. This way we
>don't have to maintain/pass clock information in platform data.
>
>I would appreciate any comments/thoughts/pointers here.
>
Though I agree that this clock could be set by the ccdc driver, I am not sure if the same clock is used by an IP on different SOCs. For example take
the case of ccdc on DM6446 which is also used on OMAP 35xx SOC. Do they use
vpss master and slave clocks as is done on DM6446? If this is true, then we
could set the clock inside ccdc driver. 

Let me know so that I can re-work the patch and send it to the list.

Murali
>Thanks,
>Vaibhav
>
>>  };
>>
>>  static struct platform_device *davinci_evm_devices[] __initdata = {
>> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c
>> b/arch/arm/mach-davinci/board-dm644x-evm.c
>> index fd0398b..45beb99 100644
>> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
>> @@ -250,6 +250,8 @@ static struct vpfe_config vpfe_cfg = {
>>  	.sub_devs = vpfe_sub_devs,
>>  	.card_name = "DM6446 EVM",
>>  	.ccdc = "DM6446 CCDC",
>> +	.num_clocks = 2,
>> +	.clocks = {"vpss_master", "vpss_slave"},
>>  };
>>
>>  static struct platform_device rtc_dev = {
>> --
>> 1.6.0.4

