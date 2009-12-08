Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55103 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965973AbZLHUJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 15:09:46 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Tue, 8 Dec 2009 14:09:50 -0600
Subject: RE: [PATCH - v0 2/2] DaVinci - vpfe capture - Make clocks
 configurable
Message-ID: <A69FA2915331DC488A831521EAE36FE40155C8010D@dlee06.ent.ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
 <1259687940-31435-2-git-send-email-m-karicheri2@ti.com>
 <19F8576C6E063C45BE387C64729E7394043716B186@dbde02.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE40155B773C5@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E739404372105B5@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404372105B5@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,

I have posted a re-worked patch with clocks configuration moved
to ccdc. From your response below, I understand the clocks
are being called differently on different SoCs even though they
use the same IP. So IMO, it is better to customize it on a SoC 
by defining the clock names in the respective platform file as
done by my original patch. This will avoid confusion since we need to
keep the name in sync with hardware signal names.

-Murali
>[Hiremath, Vaibhav] Murali,
>
>They might be using different naming conventions but the number of clocks
>will always remain the same. If not, then they are not same IP and most
>probably will not use same driver.
>
>Just to clarify more on your Q, AM3517 also uses 2 clocks
>
>- vpfe_ck (functional clock)
>- vpfe_pck (external clock, pixel clock)
>

>Whereas you are referring them as master and slave clock.
>
>Thanks,
>Vaibhav
>
>
>> Murali
>> >Thanks,
>> >Vaibhav
>> >
>> >>  };
>> >>
>> >>  static struct platform_device *davinci_evm_devices[] __initdata
>> = {
>> >> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c
>> >> b/arch/arm/mach-davinci/board-dm644x-evm.c
>> >> index fd0398b..45beb99 100644
>> >> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
>> >> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
>> >> @@ -250,6 +250,8 @@ static struct vpfe_config vpfe_cfg = {
>> >>  	.sub_devs = vpfe_sub_devs,
>> >>  	.card_name = "DM6446 EVM",
>> >>  	.ccdc = "DM6446 CCDC",
>> >> +	.num_clocks = 2,
>> >> +	.clocks = {"vpss_master", "vpss_slave"},
>> >>  };
>> >>
>> >>  static struct platform_device rtc_dev = {
>> >> --
>> >> 1.6.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
