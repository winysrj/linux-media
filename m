Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:41013 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3BFXm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 18:42:27 -0500
Message-ID: <5112EA60.6090209@wwwdotorg.org>
Date: Wed, 06 Feb 2013 16:42:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 05/10] s5p-fimc: Add device tree based sensors registration
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-6-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1359745771-23684-6-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2013 12:09 PM, Sylwester Nawrocki wrote:
> The sensor (I2C and/or SPI client) devices are instantiated by their
> corresponding control bus drivers. Since the I2C client's master clock
> is often provided by a video bus receiver (host interface) or other
> than I2C/SPI controller device, the drivers of those client devices
> are not accessing hardware in their driver's probe() callback. Instead,
> after enabling clock, the host driver calls back into a sub-device
> when it wants to activate them. This pattern is used by some in-tree
> drivers and this patch also uses it for DT case. This patch is intended
> as a first step for adding device tree support to the S5P/Exynos SoC
> camera drivers. The second one is adding support for asynchronous
> sub-devices registration and clock control from sub-device driver
> level. The bindings shall not change when asynchronous probing support
> is added.

> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt

> +The sensor device nodes should be added as their control bus controller

I think "as" should be "to"?

> +(e.g. I2C0) child nodes and linked to a port node in the csis or parallel-ports
> +node, using common the common video interfaces bindings, i.e. port/endpoint
> +node pairs. The implementation of this binding requires clock-frequency
> +property to be present in the sensor device nodes.
