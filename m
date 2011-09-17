Return-path: <linux-media-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42320 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754235Ab1IQUYa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 16:24:30 -0400
Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based
 camera board.
From: Joe Perches <joe@perches.com>
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Sat, 17 Sep 2011 13:24:29 -0700
In-Reply-To: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1316291069.1610.23.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-09-17 at 11:34 +0200, Martin Hostettler wrote:
> Adds board support for an MT9M032 based camera to omap3evm.

All of the logging messages could be
prefixed by the printk subsystem if you
add #define pr_fmt before any #include

> diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
[]
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
[]
> +static int omap3evm_set_mux(enum omap3evmdc_mux mux_id)
[]
> +	switch (mux_id) {
[]
> +	default:
> +		pr_err("omap3evm-camera: Invalid mux id #%d\n", mux_id);

		pr_err("Invalid mux id #%d\n", mux_id);
[]
> +static int __init camera_init(void)
[]
> +	if (gpio_request(nCAM_VD_SEL, "nCAM_VD_SEL") < 0) {
> +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_SEL(%d)\n",
> +		       nCAM_VD_SEL);

		pr_err("Failed to get GPIO nCAM_VD_SEL(%d)\n",
		       nCAM_VD_SEL);
etc.

