Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49714 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab3H2NnC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 09:43:02 -0400
Message-ID: <521F4FB1.1040405@ti.com>
Date: Thu, 29 Aug 2013 19:12:09 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>
CC: <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>, <tomi.valkeinen@ti.com>,
	<linux-omap@vger.kernel.org>, Sricharan R <r.sricharan@ti.com>
Subject: Re: [PATCH v3 5/6] arm: dra7xx: hwmod data: add VPE hwmod data and
 ocp_if info
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1377779572-22624-1-git-send-email-archit@ti.com> <1377779572-22624-6-git-send-email-archit@ti.com> <521F41BE.7080504@ti.com>
In-Reply-To: <521F41BE.7080504@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 August 2013 06:12 PM, Rajendra Nayak wrote:
> Archit,
>
> On Thursday 29 August 2013 06:02 PM, Archit Taneja wrote:
>> Add hwmod data for the VPE IP, this is needed for the IP to be reset during
>> boot, and control the functional clock when the driver needs it via
>> pm_runtime apis. Add the corresponding ocp_if struct and add it DRA7XX's
>> ocp interface list.
>
> You need to swap patches 5/6 and 6/6 to maintain git-bisect.
> Thats needed because after $subject patch, hwmod wouldn't find
> the register iospace and crash, and thats added only in patch 6/6.

That's a good point, I'll take care of this.

Thanks,
Archit

>
> regards,
> Rajendra
>
>>
>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Sricharan R <r.sricharan@ti.com>
>> Signed-off-by: Archit Taneja <archit@ti.com>
>> ---
>>   arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 42 +++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> index f647998b..181365d 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> @@ -1883,6 +1883,39 @@ static struct omap_hwmod dra7xx_wd_timer2_hwmod = {
>>   	},
>>   };
>>
>> +/*
>> + * 'vpe' class
>> + *
>> + */
>> +
>> +static struct omap_hwmod_class_sysconfig dra7xx_vpe_sysc = {
>> +	.sysc_offs	= 0x0010,
>> +	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
>> +	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>> +			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
>> +			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
>> +	.sysc_fields	= &omap_hwmod_sysc_type2,
>> +};
>> +
>> +static struct omap_hwmod_class dra7xx_vpe_hwmod_class = {
>> +	.name	= "vpe",
>> +	.sysc	= &dra7xx_vpe_sysc,
>> +};
>> +
>> +/* vpe */
>> +static struct omap_hwmod dra7xx_vpe_hwmod = {
>> +	.name		= "vpe",
>> +	.class		= &dra7xx_vpe_hwmod_class,
>> +	.clkdm_name	= "vpe_clkdm",
>> +	.main_clk	= "dpll_core_h23x2_ck",
>> +	.prcm = {
>> +		.omap4 = {
>> +			.clkctrl_offs = DRA7XX_CM_VPE_VPE_CLKCTRL_OFFSET,
>> +			.context_offs = DRA7XX_RM_VPE_VPE_CONTEXT_OFFSET,
>> +			.modulemode   = MODULEMODE_HWCTRL,
>> +		},
>> +	},
>> +};
>>
>>   /*
>>    * Interfaces
>> @@ -2636,6 +2669,14 @@ static struct omap_hwmod_ocp_if dra7xx_l4_wkup__wd_timer2 = {
>>   	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>>   };
>>
>> +/* l4_per3 -> vpe */
>> +static struct omap_hwmod_ocp_if dra7xx_l4_per3__vpe = {
>> +	.master		= &dra7xx_l4_per3_hwmod,
>> +	.slave		= &dra7xx_vpe_hwmod,
>> +	.clk		= "l3_iclk_div",
>> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>>   static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>>   	&dra7xx_l3_main_2__l3_instr,
>>   	&dra7xx_l4_cfg__l3_main_1,
>> @@ -2714,6 +2755,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>>   	&dra7xx_l3_main_1__vcp2,
>>   	&dra7xx_l4_per2__vcp2,
>>   	&dra7xx_l4_wkup__wd_timer2,
>> +	&dra7xx_l4_per3__vpe,
>>   	NULL,
>>   };
>>
>>
>
>
>

