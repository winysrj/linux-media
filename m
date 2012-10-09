Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49059 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2JINkb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 09:40:31 -0400
Date: Tue, 9 Oct 2012 14:34:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fabio Estevam <festevam@gmail.com>
Cc: g.liakhovetski@gmx.de, Fabio Estevam <fabio.estevam@freescale.com>,
	mchehab@infradead.org, javier.martin@vista-silicon.com,
	kernel@pengutronix.de, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, gcembed@gmail.com
Subject: Re: [PATCH v2 2/2] [media]: mx2_camera: Fix regression caused by
	clock conversion
Message-ID: <20121009133446.GE4625@n2100.arm.linux.org.uk>
References: <1349735823-30315-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349735823-30315-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 08, 2012 at 07:37:03PM -0300, Fabio Estevam wrote:
> @@ -460,7 +462,11 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  	if (pcdev->icd)
>  		return -EBUSY;
>  
> -	ret = clk_prepare_enable(pcdev->clk_csi);
> +	ret = clk_prepare_enable(pcdev->clk_csi_ahb);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = clk_prepare_enable(pcdev->clk_csi_per);
>  	if (ret < 0)
>  		return ret;

>From the point of view of error cleanup, this looks buggy to me.  If
the prepare_enable for the per clock fails, what cleans up the ahb clock?
