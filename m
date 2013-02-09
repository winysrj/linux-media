Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40496 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947344Ab3BIAbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 19:31:08 -0500
Message-ID: <511598C7.6040704@gmail.com>
Date: Sat, 09 Feb 2013 01:31:03 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/10] s5p-csis: Add device tree support
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-2-git-send-email-s.nawrocki@samsung.com> <5112E907.4080100@wwwdotorg.org> <51157C36.6030505@gmail.com> <511589E2.9030308@wwwdotorg.org>
In-Reply-To: <511589E2.9030308@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2013 12:27 AM, Stephen Warren wrote:
> On 02/08/2013 03:29 PM, Sylwester Nawrocki wrote:
>> On 02/07/2013 12:36 AM, Stephen Warren wrote:
>>> On 02/01/2013 12:09 PM, Sylwester Nawrocki wrote:
>>>> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
>>>> device. This patch support for binding the driver to the MIPI-CSIS
>>>> devices instantiated from device tree and for parsing all SoC and
>>>> board specific properties.
>>>
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
>>> b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
>>>
>>>> +Optional properties:
>>>> +
>>>> +- clock-frequency : The IP's main (system bus) clock frequency in
>>>> Hz, default
>>>> +            value when this property is not specified is 166 MHz;
>>>
>>> Shouldn't this be a "clocks" property, so that the driver can call
>>> clk_get(), clk_prepare_enable(), clk_get_rate(), etc. on it?
>>
>> Hi Stephen,
>>
>> Thanks for your review!
>>
>> I also use "clocks" and "clock-names" property, but didn't specify
>> it here, because the Exynos SoCs clocks driver is not in the mainline yet.
>
> I'm a bit sympathetic to this, since I've been trying to push Tegra
> towards the common clock framework and describing clock connectivity in
> DT, before adding new drivers that need clocks, specifically to avoid
> this kind of situation.
>
> The problem here is that if this gets merged now, then the clock driver
> comes along later, you'll have to change this binding definition to
> account for it, and DT bindings aren't supposed to be changed...

Yes, I wasn't quite sure if this is a really serious problem or not. There
is already quite a few drivers for the Exynos SoC IPs that have DT support
and their bindings will need to be changed when the new clocks driver
gets upstreamed...

> Do you have any clock driver at all upstream yet? Or, could you add a
> dummy clock driver to satisfy the driver's clkl_get() needs? If you do,
> you can always set up some AUXDATA so that clk_get() works for your
> driver right now, and then remove that once the complete clock driver is
> in place with full device tree support. That's how we've ended up
> handling this for Tegra drivers.

Yes, there is the clocks support upstream, only not using the common clock
API. And I used indeed AUXDATA in v3 of these patches.

The Exynos common clock API based driver was supposed to be merged in v3.9,
but it seems it won't happen. These patches also won't make it to 3.9.
Then hopefully both appear in 3.10 together.

I will add the clock properties to relevant nodes, assuming the new clocks
driver is available.

> Anyway, this is all mainly food-for-thought rather than an objection to
> the patch; I'd leave that to Grant/Rob if applicable.

:-) OK, thanks for the suggestions.

