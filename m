Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38941 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab2BVPkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 10:40:07 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id q1MFe6Mg031611
	for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 09:40:06 -0600
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH 4/4] davinci: da850: add build configuration for vpif
 drivers
Date: Wed, 22 Feb 2012 15:40:01 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6317CA28E@DBDE01.ent.ti.com>
References: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
 <1327503934-28186-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1327503934-28186-5-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Wed, Jan 25, 2012 at 20:35:34, Hadli, Manjunath wrote:
> add build configuration for da850/omapl-138 for vpif
> capture and display drivers.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  drivers/media/video/davinci/Kconfig  |   26 +++++++++++++++++++++++++-
>  drivers/media/video/davinci/Makefile |    5 +++++
>  2 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
> index 60a456e..a0b0fb3 100644
> --- a/drivers/media/video/davinci/Kconfig
> +++ b/drivers/media/video/davinci/Kconfig
> @@ -22,9 +22,33 @@ config CAPTURE_DAVINCI_DM646X_EVM
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vpif_capture.
>  
> +config DISPLAY_DAVINCI_DA850_EVM
> +	tristate "DA850/OMAPL138 EVM Video Display"
> +	depends on DA850_UI_SD_VIDEO_PORT && VIDEO_DEV && MACH_DAVINCI_DA850_EVM
> +	select VIDEOBUF_DMA_CONTIG
> +	select VIDEO_DAVINCI_VPIF
> +	select VIDEO_ADV7343
> +	select VIDEO_THS7303

Selecting these helper chips should be conditional on
VIDEO_HELPER_CHIPS_AUTO. This is what I gather looking
at existing Kconfig files like drivers/media/video/em28xx/Kconfig.

This issue exists with existing code too, so that should
be addressed separately.

> +	help
> +	  Support for DA850/OMAP-L138/AM18xx  based display device.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called vpif_display.
> +
> +config CAPTURE_DAVINCI_DA850_EVM
> +	tristate "DA850/OMAPL138 EVM Video Capture"
> +	depends on DA850_UI_SD_VIDEO_PORT && VIDEO_DEV && MACH_DAVINCI_DA850_EVM
> +	select VIDEOBUF_DMA_CONTIG
> +	select VIDEO_DAVINCI_VPIF
> +	help
> +	  Support for DA850/OMAP-L138/AM18xx  based capture device.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called vpif_capture.
> +
>  config VIDEO_DAVINCI_VPIF
>  	tristate "DaVinci VPIF Driver"
> -	depends on DISPLAY_DAVINCI_DM646X_EVM
> +	depends on DISPLAY_DAVINCI_DM646X_EVM || DISPLAY_DAVINCI_DA850_EVM
>  	help
>  	  Support for DaVinci VPIF Driver.
>  
> diff --git a/drivers/media/video/davinci/Makefile b/drivers/media/video/davinci/Makefile
> index ae7dafb..2c7cfb0 100644
> --- a/drivers/media/video/davinci/Makefile
> +++ b/drivers/media/video/davinci/Makefile
> @@ -10,6 +10,11 @@ obj-$(CONFIG_DISPLAY_DAVINCI_DM646X_EVM) += vpif_display.o
>  #DM646x EVM Capture driver
>  obj-$(CONFIG_CAPTURE_DAVINCI_DM646X_EVM) += vpif_capture.o
>  
> +#DA850 EVM Display driver
> +obj-$(CONFIG_DISPLAY_DAVINCI_DA850_EVM) += vpif_display.o
> +#DA850 EVM Capture driver
> +obj-$(CONFIG_CAPTURE_DAVINCI_DA850_EVM) += vpif_capture.o

Repeating these lines in the makefile for every board that
gets VPIF support seems certainly excessive. Instead why not
convert the existing DM646x specific config variables to
generic VPIF display and capture config variables and select
these generic variables when someone chooses DA850 support.

Thanks,
Sekhar

