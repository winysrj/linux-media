Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57197 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab1EQXId (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 19:08:33 -0400
Date: Wed, 18 May 2011 00:08:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, beagleboard@googlegroups.com,
	carlighting@yahoo.co.nz, g.liakhovetski@gmx.de,
	linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor
	(LI-5M03 module).
Message-ID: <20110517230821.GA5913@n2100.arm.linux.org.uk>
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com> <1305624528-5595-3-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305624528-5595-3-git-send-email-javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 17, 2011 at 11:28:48AM +0200, Javier Martin wrote:
> +#include "devices.h"
> +#include "../../../drivers/media/video/omap3isp/isp.h"
> +#include "../../../drivers/media/video/omap3isp/ispreg.h"

This suggests that there's something very wrong with what's going on;
it suggests that you're trying to access driver internals which should
be handled via some better means.  And it looks like it's this:

> @@ -654,6 +715,62 @@ static void __init beagle_opp_init(void)
>  	return;
>  }
>  
> +extern struct platform_device omap3isp_device;
> +
> +static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
> +{
> +	struct isp_device *isp = platform_get_drvdata(&omap3isp_device);
> +	int ret;
> +
> +	ret = isp->platform_cb.set_xclk(isp, hz, MT9P031_XCLK);
> +	return 0;
> +}

That really needs fixing in a different way.
