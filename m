Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37273 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbaG3Mi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 08:38:57 -0400
Message-ID: <53D8E7C1.7010101@ti.com>
Date: Wed, 30 Jul 2014 15:40:33 +0300
From: Tero Kristo <t-kristo@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
CC: Tony Lindgren <tony@atomide.com>, <linux-media@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: set 'ti,set-rate-parent' for dpll4_m5x2 clock
References: <1405418556-7030-1-git-send-email-stefan@herbrechtsmeier.net> <3350943.lsAUHoxgP5@avalon>
In-Reply-To: <3350943.lsAUHoxgP5@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2014 03:29 AM, Laurent Pinchart wrote:
> Hi Stefan,
>
> Thank you for the patch.
>
> On Tuesday 15 July 2014 12:02:35 Stefan Herbrechtsmeier wrote:
>> Set 'ti,set-rate-parent' property for the dpll4_m5x2_ck clock, which
>> is used for the ISP functional clock. This fixes the OMAP3 ISP driver's
>> clock rate configuration on OMAP34xx, which needs the rate to be
>> propagated properly to the divider node (dpll4_m5_ck).
>>
>> Signed-off-by: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Tero Kristo <t-kristo@ti.com>
>> Cc: <linux-media@vger.kernel.org>
>> Cc: <linux-omap@vger.kernel.org>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Tero, could you please process it for v3.17 if time still permits ?

This is too late for 3.17 merge window as I was on holiday last few 
weeks. Queued for 3.17-rc early fixes though.

-Tero

>
>> ---
>>   arch/arm/boot/dts/omap3xxx-clocks.dtsi | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/boot/dts/omap3xxx-clocks.dtsi
>> b/arch/arm/boot/dts/omap3xxx-clocks.dtsi index e47ff69..5c37500 100644
>> --- a/arch/arm/boot/dts/omap3xxx-clocks.dtsi
>> +++ b/arch/arm/boot/dts/omap3xxx-clocks.dtsi
>> @@ -467,6 +467,7 @@
>>   		ti,bit-shift = <0x1e>;
>>   		reg = <0x0d00>;
>>   		ti,set-bit-to-disable;
>> +		ti,set-rate-parent;
>>   	};
>>
>>   	dpll4_m6_ck: dpll4_m6_ck {
>

