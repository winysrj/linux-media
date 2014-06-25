Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35536 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbaFYK2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 06:28:12 -0400
Date: Wed, 25 Jun 2014 11:28:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] media: soc_camera: pxa_camera device-tree support
Message-ID: <20140625102801.GA14495@leverpostej>
References: <1403389307-17489-1-git-send-email-robert.jarzmik@free.fr>
 <1403389307-17489-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403389307-17489-2-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 21, 2014 at 11:21:47PM +0100, Robert Jarzmik wrote:
> Add device-tree support to pxa_camera host driver.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 77 +++++++++++++++++++++++++-
>  1 file changed, 75 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index d4df305..8c9de9e 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -34,6 +34,7 @@
>  #include <media/videobuf-dma-sg.h>
>  #include <media/soc_camera.h>
>  #include <media/soc_mediabus.h>
> +#include <media/v4l2-of.h>
>  
>  #include <linux/videodev2.h>
>  
> @@ -1650,6 +1651,64 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
>  	.set_bus_param	= pxa_camera_set_bus_param,
>  };
>  
> +static int pxa_camera_pdata_from_dt(struct device *dev,
> +				    struct pxa_camera_dev *pcdev)
> +{
> +	int err = 0;
> +	struct device_node *np = dev->of_node;
> +	struct v4l2_of_endpoint ep;
> +
> +	err = of_property_read_u32(np, "clock-frequency",
> +				   (u32 *)&pcdev->mclk);

That cast is either unnecessary or this code is broken.

Use a temporary u32 if the types don't match.

Mark.
