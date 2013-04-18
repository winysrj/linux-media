Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33687 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030364Ab3DRKZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 06:25:04 -0400
Date: Thu, 18 Apr 2013 11:24:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC 06/10] video: ARM CLCD: Add DT & CDF support
Message-ID: <20130418102444.GL14496@n2100.arm.linux.org.uk>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com> <1366211842-21497-7-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366211842-21497-7-git-send-email-pawel.moll@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 17, 2013 at 04:17:18PM +0100, Pawel Moll wrote:
> +#if defined(CONFIG_OF)
> +static int clcdfb_of_get_tft_parallel_panel(struct clcd_panel *panel,
> +		struct display_entity_interface_params *params)
> +{
> +	int r = params->p.tft_parallel.r_bits;
> +	int g = params->p.tft_parallel.g_bits;
> +	int b = params->p.tft_parallel.b_bits;
> +
> +	/* Bypass pixel clock divider, data output on the falling edge */
> +	panel->tim2 = TIM2_BCD | TIM2_IPC;
> +
> +	/* TFT display, vert. comp. interrupt at the start of the back porch */
> +	panel->cntl |= CNTL_LCDTFT | CNTL_LCDVCOMP(1);
> +
> +	if (params->p.tft_parallel.r_b_swapped)
> +		panel->cntl |= CNTL_BGR;

NAK.  Do not set this explicitly.  Note the driver talks about this being
"the old way" - this should not be used with the panel capabilities - and
in fact it will be overwritten.

Instead, you need to encode this into the capabilities by masking the
below with CLCD_CAP_RGB or CLCD_CAP_BGR depending on the ordering.
