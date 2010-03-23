Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59432 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0CWIsR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 04:48:17 -0400
Date: Tue, 23 Mar 2010 17:47:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <damm@opensource.se>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 1/3 v2] V4L: SuperH Video Output Unit (VOU) driver
Message-ID: <20100323084707.GD30655@linux-sh.org>
References: <Pine.LNX.4.64.1003171103030.4354@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003171103030.4354@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 18, 2010 at 11:28:28AM +0100, Guennadi Liakhovetski wrote:
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 64682bf..be6d016 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -511,6 +511,13 @@ config DISPLAY_DAVINCI_DM646X_EVM
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vpif_display.
>  
> +config VIDEO_SH_VOU
> +	tristate "SuperH VOU video output driver"
> +	depends on VIDEO_DEV && (SUPERH || ARCH_SHMOBILE)
> +	select VIDEOBUF_DMA_CONTIG
> +	help
> +	  Support for the Video Output Unit (VOU) on SuperH SoCs.
> +
I assumed the VOU was only on SH-Mobile, in which case you can just
depend on ARCH_SHMOBILE directly, since we set that for all SH-Mobile
CPUs anyways.

After that's done or proven to be an inaccurate assumption:

Acked-by: Paul Mundt <lethal@linux-sh.org>
