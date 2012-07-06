Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46335 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2GFGng (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 02:43:36 -0400
Date: Fri, 6 Jul 2012 08:43:32 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de
Subject: Re: media: i.MX27: Fix emma-prp clocks in mx2_camera.c
Message-ID: <20120706064332.GA30009@pengutronix.de>
References: <1341556309-2934-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341556309-2934-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Fri, Jul 06, 2012 at 08:31:49AM +0200, Javier Martin wrote:
> This driver wasn't converted to the new clock changes
> (clk_prepare_enable/clk_disable_unprepare). Also naming
> of emma-prp related clocks for the i.MX27 was not correct.

Thanks for fixing this. Sorry for breaking this in the first place.

> @@ -1668,12 +1658,26 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  		goto exit;
>  	}
>  
> -	pcdev->clk_csi = clk_get(&pdev->dev, NULL);
> +	pcdev->clk_csi = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(pcdev->clk_csi)) {
>  		dev_err(&pdev->dev, "Could not get csi clock\n");
>  		err = PTR_ERR(pcdev->clk_csi);
>  		goto exit_kfree;
>  	}
> +	pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "ipg");
> +	if (IS_ERR(pcdev->clk_emma_ipg)) {
> +		err = PTR_ERR(pcdev->clk_emma_ipg);
> +		goto exit_kfree;
> +	}
> +	pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(pcdev->clk_emma_ahb)) {
> +		err = PTR_ERR(pcdev->clk_emma_ahb);
> +		goto exit_kfree;
> +	}

So we have three clocks involved here, a csi ahb clock and two emma
clocks. Can we rename the clocks to:

	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
	clk_register_clkdev(clk[emma_ahb_gate], "emma-ahb", "mx2-camera.0");
	clk_register_clkdev(clk[emma_ipg_gate], "emma-ipg", "mx2-camera.0");

The rationale is that the csi_ahb_gate really is a ahb clock related to
the csi whereas the emma clocks are normally for the emma device, but
the csi driver happens to use parts of the emma.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
