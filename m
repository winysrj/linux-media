Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55923 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaAGVXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 16:23:38 -0500
Message-ID: <52CC7055.70503@gmail.com>
Date: Tue, 07 Jan 2014 22:23:33 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/6] exynos4-is: Add clock provider for the external
 clocks
References: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com> <1382033211-32329-5-git-send-email-s.nawrocki@samsung.com> <20140102175856.36f57ffb@samsung.com>
In-Reply-To: <20140102175856.36f57ffb@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2014 08:58 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Oct 2013 20:06:49 +0200
> Sylwester Nawrocki<s.nawrocki@samsung.com>  escreveu:
>
>> This patch adds clock provider to expose the sclk_cam0/1 clocks
>> for external image sensor devices.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>> Changes since v2:
>>   - use 'camera' DT node drirectly as clock provider node, rather than
>>    creating additional clock-controller child node.
>> ---
>>   .../devicetree/bindings/media/samsung-fimc.txt     |   15 ++-
>>   drivers/media/platform/exynos4-is/media-dev.c      |  108 ++++++++++++++++++++
>>   drivers/media/platform/exynos4-is/media-dev.h      |   18 +++-
>>   3 files changed, 137 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> index 96312f6..968e065 100644
>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> @@ -32,6 +32,15 @@ way around.
>>
>>   The 'camera' node must include at least one 'fimc' child node.
>>
>> +Optional properties:
>> +
>> +- #clock-cells: from the common clock bindings (../clock/clock-bindings.txt),
>> +  must be 1. A clock provider is associated with the camera node and it should
>> +  be referenced by external sensors that use clocks provided by the SoC on
>> +  CAM_*_CLKOUT pins. The second cell of the clock specifier is a clock's index.
>> +  The indexes are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks respectively.
>> +
>> +
>>   'fimc' device nodes
>>   -------------------
>>
>> @@ -114,7 +123,7 @@ Example:
>>   			vddio-supply =<...>;
>>
>>   			clock-frequency =<24000000>;
>> -			clocks =<...>;
>> +			clocks =<&camera 1>;
>>   			clock-names = "mclk";
>>
>>   			port {
>> @@ -135,7 +144,7 @@ Example:
>>   			vddio-supply =<...>;
>>
>>   			clock-frequency =<24000000>;
>> -			clocks =<...>;
>> +			clocks =<&camera 0>;
>>   			clock-names = "mclk";
>>
>>   			port {
>> @@ -151,8 +160,8 @@ Example:
>>   		compatible = "samsung,fimc", "simple-bus";
>>   		#address-cells =<1>;
>>   		#size-cells =<1>;
>> +		#clock-cells =<1>;
>>   		status = "okay";
>> -
>>   		pinctrl-names = "default";
>>   		pinctrl-0 =<&cam_port_a_clk_active>;
>
> I didn't see the above on the patch series you sent me on your git pull
> request. Where is it?

Mauro, I've moved it into a separate patch, since it is more appropriate
as that's a change in the DT binding [1].

My plan was to send it through the devicetree tree with your Ack, but
I forgot to resend the whole series. Sorry about that.

Moreover I did this split because you are requiring an explicit ACK
from a DT maintainer for anything that is related to devicetree.
I believe it is physically impossible to have every single patch
acked by a DT maintainer. Subsystem maintainers should handle minor
stuff, otherwise we won't be able to have _anything_ merged upstream.

Pinging the DT maintainers for every single patch seems a bit silly and
I'm already fed up with it. I find this whole process frustrating and very
long times to get things merged really discourage to develop anything in
mainline.

[...]
>> +static const char *cam_clk_p_names[] = { "sclk_cam0", "sclk_cam1" };
>> +
>> +static void fimc_md_unregister_clk_provider(struct fimc_md *fmd)
>> +{
>> +	struct cam_clk_provider *cp =&fmd->clk_provider;
>> +	unsigned int i;
>> +
>> +	if (cp->of_node)
>> +		of_clk_del_provider(cp->of_node);
>> +
>> +	for (i = 0; i<  ARRAY_SIZE(cp->clks); i++)
>> +		if (!IS_ERR(cp->clks[i]))
>> +			clk_unregister(cp->clks[i]);
>
> Huh? Why to initialize an array with an error code??? Does it make sense to
> have one of the clocks with an error and the others ok, and to store the
> error code? The code below doesn't seem to allow that.

If fimc_md_unregister_clk_provider() fails at any point
fimc_md_register_clk_provider() can be called to undo what has been
registered successfully. That's the point of storing the error codes.
The error paths in probe() are already complex enough.

> Just initialize cp->clks with zero and test it with:
>
> 	if (cp->clks[i])
> 		clk_unregister(cp->clks[i]);

I'm afraid this is incorrect, clock pointers should be treated as
opaque cookies and tested only with IS_ERR(). Clk users should not
assume NULL clk pointer indicate an invalid clock.

> That makes it easier to understand and review.

Maybe it is easier to understand but it is a wrong API usage. And
I believe it should never be suggested in reviews.

>> +}
>> +
>> +static int fimc_md_register_clk_provider(struct fimc_md *fmd)
>> +{
>> +	struct cam_clk_provider *cp =&fmd->clk_provider;
>> +	struct device *dev =&fmd->pdev->dev;
>> +	int i, ret;
>> +
>> +	for (i = 0; i<  ARRAY_SIZE(cp->clks); i++)
>> +		cp->clks[i] = ERR_PTR(-EINVAL);
>
> That looks weird for me, due to several reasons:
>
> 1) ARRAY_SIZE(cp->clks) is equal to FIMC_MAX_CAMCLKS. Why are you using
> different syntaxes on the first loop and on the next one? Just to loose
> more time from reviewers to double check what number is bigger?

The loop limit argument is valid, I can correct that so the code is
easier to follow.

> 2) Why don't you just do:
>
> 	memset(cp->clks, ARRAY_SIZE(cp->clks), 0).
>
> or initialize struct fimc_md with kzalloc()?

Because it isn't correct. struct fimc_md is already allocated with
kzalloc(), I would certainly consider the above simpler code if it
were valid.

>> +
>> +	for (i = 0; i<  FIMC_MAX_CAMCLKS; i++) {
>> +		struct cam_clk *camclk =&cp->camclk[i];
>> +		struct clk_init_data init;
>> +		char clk_name[16];
>> +		struct clk *clk;
>> +
>> +		snprintf(clk_name, sizeof(clk_name), "cam_clkout%d", i);
>> +
>> +		init.name = clk_name;
>> +		init.ops =&cam_clk_ops;
>> +		init.flags = CLK_SET_RATE_PARENT;
>> +		init.parent_names =&cam_clk_p_names[i];
>> +		init.num_parents = 1;
>> +		camclk->hw.init =&init;
>> +		camclk->fmd = fmd;
>> +
>> +		clk = clk_register(dev,&camclk->hw);
>> +		if (IS_ERR(clk)) {
>> +			dev_err(dev, "failed to register clock: %s (%ld)\n",
>> +						clk_name, PTR_ERR(clk));
>> +			ret = PTR_ERR(clk);
>> +			goto err;
>> +		}
>> +		cp->clks[i] = clk;
>> +	}
>> +
>> +	cp->clk_data.clks = cp->clks;
>> +	cp->clk_data.clk_num = i;
>> +	cp->of_node = dev->of_node;
>> +
>> +	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
>> +				&cp->clk_data);
>> +	if (!ret)
>> +		return 0;
>> +err:
>> +	fimc_md_unregister_clk_provider(fmd);
>> +	return ret;
>> +}
>> +#else
>> +#define fimc_md_register_clk_provider(fmd) (0)
>> +#define fimc_md_unregister_clk_provider(fmd) (0)
>> +#endif

--
Regards,
Sylwester

[1] 
http://git.linuxtv.org/snawrocki/samsung.git/shortlog/refs/heads/v3.14-exynos4-is-dt
