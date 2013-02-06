Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:53656 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFXke (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 18:40:34 -0500
Message-ID: <5112E9EF.8090908@wwwdotorg.org>
Date: Wed, 06 Feb 2013 16:40:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2013 12:09 PM, Sylwester Nawrocki wrote:
> This patch adds support for FIMC devices instantiated from devicetree
> for S5PV210 and Exynos4 SoCs. The FIMC IP features include colorspace
> conversion and scaling (mem-to-mem) and parallel/MIPI CSI2 bus video
> capture interface.
> 
> Multiple SoC revisions specific parameters are defined statically in
> the driver and are used for both dt and non-dt. The driver's static
> data is selected based on the compatible property. Previously the
> platform device name was used to match driver data and a specific
> SoC/IP version.
> 
> Aliases are used to determine an index of the IP which is essential
> for linking FIMC IP with other entities, like MIPI-CSIS (the MIPI
> CSI-2 bus frontend) or FIMC-LITE and FIMC-IS ISP.

> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt

> +Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
> +----------------------------------------------
> +
> +The Exynos Camera subsystem comprises of multiple sub-devices that are
> +represented by separate platform devices. Some of the IPs come in different

"platform devices" is a rather Linux-centric term, and DT bindings
should be OS-agnostic. Perhaps use "device tree nodes" here?

> +variants across the SoC revisions (FIMC) and some remain mostly unchanged
> +(MIPI CSIS, FIMC-LITE).
> +
> +All those sub-subdevices are defined as parent nodes of the common device

s/parent nodes/child node/ I think?

> +For every fimc node a numbered alias should be present in the aliases node.
> +Aliases are of the form fimc<n>, where <n> is an integer (0...N) specifying
> +the IP's instance index.

Why? Isn't it up to the DT author whether they care if each fimc node is
assigned a specific identification v.s. whether identification is
assigned automatically?

> +Optional properties
> +
> + - clock-frequency - maximum FIMC local clock (LCLK) frequency

Again, I'd expect a clocks property here instead.
