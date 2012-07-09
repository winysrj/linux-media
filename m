Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50429 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2GIH2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 03:28:17 -0400
Date: Mon, 9 Jul 2012 09:28:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] [v3] i.MX27: Fix emma-prp clocks in mx2_camera.c
Message-ID: <20120709072809.GP30009@pengutronix.de>
References: <1341572162-29126-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341572162-29126-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 06, 2012 at 12:56:02PM +0200, Javier Martin wrote:
> This driver wasn't converted to the new clock changes
> (clk_prepare_enable/clk_disable_unprepare). Also naming
> of emma-prp related clocks for the i.MX27 was not correct.
> ---
> Enable clocks only for i.MX27.
> 

Indeed,

>  
> -	pcdev->clk_csi = clk_get(&pdev->dev, NULL);
> -	if (IS_ERR(pcdev->clk_csi)) {
> -		dev_err(&pdev->dev, "Could not get csi clock\n");
> -		err = PTR_ERR(pcdev->clk_csi);
> -		goto exit_kfree;
> +	if (cpu_is_mx27()) {
> +		pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
> +		if (IS_ERR(pcdev->clk_csi)) {
> +			dev_err(&pdev->dev, "Could not get csi clock\n");
> +			err = PTR_ERR(pcdev->clk_csi);
> +			goto exit_kfree;
> +		}

but why? Now the i.MX25 won't get a clock anymore.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
