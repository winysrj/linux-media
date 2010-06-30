Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53311 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0F3HHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 03:07:25 -0400
Date: Wed, 30 Jun 2010 09:07:17 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 1/3] mx2_camera: Add soc_camera support for
	i.MX25/i.MX27
Message-ID: <20100630070717.GA11746@pengutronix.de>
References: <cover.1277096909.git.baruch@tkos.co.il> <03d6e55c39690618e92a91a580ec34549a135c79.1277096909.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03d6e55c39690618e92a91a580ec34549a135c79.1277096909.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 21, 2010 at 08:15:58AM +0300, Baruch Siach wrote:
> This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> Carvalho de Assis modified the original driver to get it working on more recent
> kernels. I modified it further to add support for i.MX25. This driver has been
> tested on i.MX25 and i.MX27 based platforms.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  arch/arm/plat-mxc/include/mach/memory.h  |    4 +-
>  arch/arm/plat-mxc/include/mach/mx2_cam.h |   46 +
>  drivers/media/video/Kconfig              |   13 +
>  drivers/media/video/Makefile             |    1 +
>  drivers/media/video/mx2_camera.c         | 1493 ++++++++++++++++++++++++++++++
>  5 files changed, 1555 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
>  create mode 100644 drivers/media/video/mx2_camera.c
> 
> diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
> index c4b40c3..5803836 100644
> --- a/arch/arm/plat-mxc/include/mach/memory.h
> +++ b/arch/arm/plat-mxc/include/mach/memory.h
> @@ -44,12 +44,12 @@
>   */
>  #define CONSISTENT_DMA_SIZE SZ_8M
>  
> -#elif defined(CONFIG_MX1_VIDEO)
> +#elif defined(CONFIG_MX1_VIDEO) || defined(CONFIG_MX2_VIDEO)
>  /*
>   * Increase size of DMA-consistent memory region.
>   * This is required for i.MX camera driver to capture at least four VGA frames.
>   */
>  #define CONSISTENT_DMA_SIZE SZ_4M
> -#endif /* CONFIG_MX1_VIDEO */
> +#endif /* CONFIG_MX1_VIDEO || CONFIG_MX2_VIDEO */
Why not use CONFIG_VIDEO_MX2 here and get rid of CONFIG_MX2_VIDEO?
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
