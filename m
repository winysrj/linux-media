Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaLTK0F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 05:26:05 -0500
Message-ID: <54954E9F.4020307@redhat.com>
Date: Sat, 20 Dec 2014 11:25:35 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 06/13] clk: sunxi: Make the mod0 clk driver also a
 platform driver
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com> <1418836704-15689-7-git-send-email-hdegoede@redhat.com> <20141219182405.GU4820@lukather>
In-Reply-To: <20141219182405.GU4820@lukather>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 19-12-14 19:24, Maxime Ripard wrote:
> Hi,
>
> On Wed, Dec 17, 2014 at 06:18:17PM +0100, Hans de Goede wrote:
>> With the prcm in sun6i (and some later SoCs) some mod0 clocks are instantiated
>> through the mfd framework, and as such do not work with of_clk_declare, since
>> they do not have registers assigned to them yet at of_clk_declare init time.
>>
>> Silence the error on not finding registers in the of_clk_declare mod0 clk
>> setup method, and also register mod0-clk support as a platform driver to work
>> properly with mfd instantiated mod0 clocks.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/clk/sunxi/clk-mod0.c | 41 ++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 36 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/clk/sunxi/clk-mod0.c b/drivers/clk/sunxi/clk-mod0.c
>> index 658d74f..7ddab6f 100644
>> --- a/drivers/clk/sunxi/clk-mod0.c
>> +++ b/drivers/clk/sunxi/clk-mod0.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/clk-provider.h>
>>   #include <linux/clkdev.h>
>>   #include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>>
>>   #include "clk-factors.h"
>>
>> @@ -67,7 +68,7 @@ static struct clk_factors_config sun4i_a10_mod0_config = {
>>   	.pwidth = 2,
>>   };
>>
>> -static const struct factors_data sun4i_a10_mod0_data __initconst = {
>> +static const struct factors_data sun4i_a10_mod0_data = {
>>   	.enable = 31,
>>   	.mux = 24,
>>   	.muxmask = BIT(1) | BIT(0),
>> @@ -82,17 +83,47 @@ static void __init sun4i_a10_mod0_setup(struct device_node *node)
>>   	void __iomem *reg;
>>
>>   	reg = of_iomap(node, 0);
>> -	if (!reg) {
>> -		pr_err("Could not get registers for mod0-clk: %s\n",
>> -		       node->name);
>> +	if (!reg)
>>   		return;
>> -	}
>
> A comment here would be nice to mention that this is intentional.

Ok, I'll respin this patch adding such a comment.

Regards,

Hans
