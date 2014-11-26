Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaKZIFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 03:05:32 -0500
Message-ID: <547589A9.5060802@redhat.com>
Date: Wed, 26 Nov 2014 09:04:57 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 3/9] clk: sunxi: Add prcm mod0 clock driver
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com> <1416749895-25013-4-git-send-email-hdegoede@redhat.com> <20141125165744.GA17789@x1>
In-Reply-To: <20141125165744.GA17789@x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/25/2014 05:57 PM, Lee Jones wrote:
> On Sun, 23 Nov 2014, Hans de Goede wrote:
>
>> Add a driver for mod0 clocks found in the prcm. Currently there is only
>> one mod0 clocks in the prcm, the ir clock.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>>   drivers/clk/sunxi/Makefile                        |  2 +-
>>   drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 +++++++++++++++++++++++
>>   drivers/mfd/sun6i-prcm.c                          | 14 +++++
>>   4 files changed, 79 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
>
> [...]
>
>> diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
>> index 283ab8d..ff1254f 100644
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
> I'm not overly keen on these magic numbers (and yes, I'm well aware
> that I SoB'ed the patch which started them off).
>
> It's not a show stopper, although I'd prefer if they were fixed with a
> subsequent patch.

These are offsets of the relevant registers inside the prcm register block,
if not done this way, then how should they be done ?

Regards,

Hans
