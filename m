Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:38914 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966550Ab3HHVA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 17:00:57 -0400
Message-ID: <52040704.6090100@wwwdotorg.org>
Date: Thu, 08 Aug 2013 15:00:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Tomasz Figa <t.figa@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Rob Herring <robherring2@gmail.com>,
	Olof Johansson <olof@lixom.net>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Exynos: replace custom MFC reserved memory handling
 with generic code
References: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com> <1375705610-12724-2-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1375705610-12724-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2013 06:26 AM, Marek Szyprowski wrote:
> MFC driver use custom bindings for managing reserved memory. Those bindings
> are not really specific to MFC device and no even well discussed. They can
> be easily replaced with generic, platform independent code for handling
> reserved and contiguous memory.
> 
> Two additional child devices for each memory port (AXI master) are
> introduced to let one assign some properties to each of them. Later one
> can also use them to assign properties related to SYSMMU controllers,
> which can be used to manage the limited dma window provided by those
> memory ports.

> diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt

> +The MFC device is connected to system bus with two memory ports (AXI
> +masters) for better performance. Those memory ports are modelled as
> +separate child devices, so one can assign some properties to them (like
> +memory region for dma buffer allocation or sysmmu controller).
> +
>  Required properties:
>    - compatible : value should be either one among the following
>  	(a) "samsung,mfc-v5" for MFC v5 present in Exynos4 SoCs
>  	(b) "samsung,mfc-v6" for MFC v6 present in Exynos5 SoCs
> +	and additionally "simple-bus" to correctly initialize child
> +	devices for memory ports (AXI masters)

simple-bus is wrong here; the child nodes aren't independent entities
that can be instantiated separately from their parent and without
depending on their parent.

> -  - samsung,mfc-r : Base address of the first memory bank used by MFC
> -		    for DMA contiguous memory allocation and its size.
> -
> -  - samsung,mfc-l : Base address of the second memory bank used by MFC
> -		    for DMA contiguous memory allocation and its size.

These properties shouldn't be removed, but simply marked deprecated. The
driver will need to continue to support them so that old DTs work with
new kernels. The binding must therefore continue to document them so
that the old DT content still makes sense.

> +Two child nodes must be defined for MFC device. Their names must be
> +following: "memport-r" and "memport-l" ("right" and "left"). Required

Node names shouldn't have semantic meaning.

> +properties:
> +  - compatible : value should be "samsung,memport"

There's no need to define compatible properties for things which aren't
separate devices.

> +  - dma-memory-region : optional property with a phandle to respective memory
> +			region (see devicetree/bindings/memory.txt), if no region
> +			is defined, sysmmu controller must be used for managing
> +			limited dma window of each memory port.

What's the benefit of putting this property in a sub-node; surely you
can put the property in the main MFC node yet follow the same conceptual
schema for its content as a dma-memory-region node?
