Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:49431 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab3BFXgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 18:36:43 -0500
Message-ID: <5112E907.4080100@wwwdotorg.org>
Date: Wed, 06 Feb 2013 16:36:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/10] s5p-csis: Add device tree support
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1359745771-23684-2-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2013 12:09 PM, Sylwester Nawrocki wrote:
> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
> device. This patch support for binding the driver to the MIPI-CSIS
> devices instantiated from device tree and for parsing all SoC and
> board specific properties.

> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt

> +Optional properties:
> +
> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
> +		    value when this property is not specified is 166 MHz;

Shouldn't this be a "clocks" property, so that the driver can call
clk_get(), clk_prepare_enable(), clk_get_rate(), etc. on it?

Other than that this binding seems fine to me at a quick glance.
