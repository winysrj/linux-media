Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaLRIx4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:53:56 -0500
Message-ID: <54929602.8020002@redhat.com>
Date: Thu, 18 Dec 2014 09:53:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 07/13] mfd: sun6i-prcm: Add support for the ir-clk
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com> <1418836704-15689-8-git-send-email-hdegoede@redhat.com> <20141218084129.GT13885@x1>
In-Reply-To: <20141218084129.GT13885@x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 18-12-14 09:41, Lee Jones wrote:
> On Wed, 17 Dec 2014, Hans de Goede wrote:
>
>> Add support for the ir-clk which is part of the sun6i SoC prcm module.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/mfd/sun6i-prcm.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>
> Pretty standard stuff (
>
>> diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
>> index 2f2e9f0..1911731 100644
>> --- a/drivers/mfd/sun6i-prcm.c
>> +++ b/drivers/mfd/sun6i-prcm.c
>> @@ -41,6 +41,14 @@ static const struct resource sun6i_a31_apb0_gates_clk_res[] = {
>>   	},
>>   };
>>
>> +static const struct resource sun6i_a31_ir_clk_res[] = {
>> +	{
>> +		.start = 0x54,
>> +		.end = 0x57,
>> +		.flags = IORESOURCE_MEM,
>> +	},
>> +};
>
> I'm still unkeen on this registers not being defined -- but whateveer!
>
>>   static const struct resource sun6i_a31_apb0_rstc_res[] = {
>>   	{
>>   		.start = 0xb0,
>> @@ -69,6 +77,12 @@ static const struct mfd_cell sun6i_a31_prcm_subdevs[] = {
>>   		.resources = sun6i_a31_apb0_gates_clk_res,
>>   	},
>>   	{
>> +		.name = "sun6i-a31-ir-clk",
>> +		.of_compatible = "allwinner,sun4i-a10-mod0-clk",
>> +		.num_resources = ARRAY_SIZE(sun6i_a31_ir_clk_res),
>> +		.resources = sun6i_a31_ir_clk_res,
>> +	},
>> +	{
>>   		.name = "sun6i-a31-apb0-clock-reset",
>>   		.of_compatible = "allwinner,sun6i-a31-clock-reset",
>>   		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_rstc_res),
>
> This is all pretty standard stuff:
>
> For my own reference:
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
>
> Do you do  you expect this patch to be handled?

I've no preference for how this goes upstream. There are no compile time deps
and runtime the ir will not work (but not explode) until all the bits are
in place.

Regards,

Hans


>
