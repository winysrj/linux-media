Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63445 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKLY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 06:24:26 -0500
Message-id: <50C717E7.10801@samsung.com>
Date: Tue, 11 Dec 2012 12:24:23 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 01/12] s5p-csis: Add device tree support
References: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
 <1355168766-6068-2-git-send-email-s.nawrocki@samsung.com>
 <20121211083658.8AEA23E076D@localhost>
In-reply-to: <20121211083658.8AEA23E076D@localhost>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Grant,

On 12/11/2012 09:36 AM, Grant Likely wrote:
> On Mon, 10 Dec 2012 20:45:55 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
>> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
>> (camera host interface DMA engine and image processor). This patch
>> adds support for instantiating the MIPI-CSIS devices from DT and
>> parsing all SoC and board specific properties from device tree.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  .../bindings/media/soc/samsung-mipi-csis.txt       |   82 +++++++++++
>>  drivers/media/platform/s5p-fimc/mipi-csis.c        |  155 +++++++++++++++-----
>>  drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
>>  3 files changed, 202 insertions(+), 36 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
>> new file mode 100644
>> index 0000000..f57cbdc
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
>> @@ -0,0 +1,82 @@
>> +Samsung S5P/EXYNOS SoC MIPI-CSI2 receiver (MIPI CSIS)
>> +-----------------------------------------------------
>> +
>> +Required properties:
>> +
>> +- compatible	  : "samsung,s5pv210-csis" for S5PV210 SoCs,
>> +		    "samsung,exynos4210-csis" for Exynos4210 and later SoCs;
>> +- reg		  : physical base address and size of the device memory mapped
>> +		    registers;
>> +- interrupts      : should contain MIPI CSIS interrupt; the format of the
>> +		    interrupt specifier depends on the interrupt controller;
>> +- max-data-lanes  : maximum number of data lanes supported (SoC specific);
>> +- vddio-supply    : MIPI CSIS I/O and PLL voltage supply (e.g. 1.8V);
>> +- vddcore-supply  : MIPI CSIS Core voltage supply (e.g. 1.1V).
>> +
>> +Optional properties:
>> +
>> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
>> +		    value when this property is not specified is 166 MHz;
>> +- samsung,csis,wclk : CSI-2 wrapper clock selection. If this property is present
>> +		    external clock from CMU will be used, if not bus clock will
>> +		    be selected.
>> +
>> +The device node should contain one 'port' child node with one child 'endpoint'
>> +node, as outlined in the common media bindings specification. See
>> +Documentation/devicetree/bindings/media/v4l2.txt for details. The following are
>> +properties specific to those nodes. (TODO: update the file path)
>> +
>> +port node
>> +---------
>> +
>> +- reg		  : (required) must be 2 for camera C input (CSIS0) or 3 for
>> +		    camera D input (CSIS1);
> 
> 'reg' has a very specific definition. If you're going to use a reg
> property here, then the parent nodes need to have
> #address-cells=<1>;#size-cells=<0>; properties to define the address
> specifier format.
> 
> However since you're identifying port numbers that aren't really
> addresses I would suggest simply changing this property to something
> like 'port-num'.
> 
> Otherwise the binding looks good.

Thank you for the review. Indeed I should have said about #address-cells,
#size-cells here. I thought using 'reg' was agreed during previous discussions
on the mailing lists (e.g. [1]), so I just carried on with 'reg'.
I should just have addressed the comments from Stephen and Rob, instead of
just resending same version of the documentation. I'll try to take care of
it in the next post. i.e. rename 'link' node to 'endpoint' and 'remote'
phandle to 'remote-endpoint'.

I'm not really sure what advantage 'reg' gives over a new property.
Would it still be OK to have port nodes names followed by indexes with
port-num instead of reg, e.g.

foo {
	port@0 {
		port-num = <0>;
	};

	port@1 {
		port-num = <1>;
	};
};
?


[1] http://www.spinics.net/lists/linux-sh/msg13383.html

--

Thanks,
Sylwester

