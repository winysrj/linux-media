Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:34761 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab1FBRWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 13:22:12 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 2 Jun 2011 22:51:58 +0530
Subject: RE: [PATCH 1/1] davinci: dm646x: move vpif related code to driver
 core	header from platform
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D2D28E3@dbde02.ent.ti.com>
References: <1305899929-2509-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1305899929-2509-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Fri, May 20, 2011 at 19:28:49, Hadli, Manjunath wrote:
> move vpif related code for capture and display drivers
> from dm646x platform header file to vpif.h as these definitions
> are related to driver code more than the platform or board.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>

Will you be taking this patch through your tree?

If not, with your ack, I can queue it for inclusion
through the ARM tree.

Thanks,
Sekhar

> ---
>  arch/arm/mach-davinci/include/mach/dm646x.h |   53 +-------------------
>  drivers/media/video/davinci/vpif.h          |    1 +
>  drivers/media/video/davinci/vpif_capture.h  |    2 +-
>  drivers/media/video/davinci/vpif_display.h  |    1 +
>  include/media/davinci/vpif.h                |   73 +++++++++++++++++++++++++++
>  5 files changed, 77 insertions(+), 53 deletions(-)
>  create mode 100644 include/media/davinci/vpif.h
> 
> diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
> index 7a27f3f..245a1c0 100644
> --- a/arch/arm/mach-davinci/include/mach/dm646x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm646x.h
> @@ -17,6 +17,7 @@
>  #include <linux/videodev2.h>
>  #include <linux/clk.h>
>  #include <linux/davinci_emac.h>
> +#include <media/davinci/vpif.h>
>  
>  #define DM646X_EMAC_BASE		(0x01C80000)
>  #define DM646X_EMAC_MDIO_BASE		(DM646X_EMAC_BASE + 0x4000)
> @@ -36,58 +37,6 @@ int __init dm646x_init_edma(struct edma_rsv_info *rsv);
>  
>  void dm646x_video_init(void);
>  
> -enum vpif_if_type {
> -	VPIF_IF_BT656,
> -	VPIF_IF_BT1120,
> -	VPIF_IF_RAW_BAYER
> -};
> -
> -struct vpif_interface {
> -	enum vpif_if_type if_type;
> -	unsigned hd_pol:1;
> -	unsigned vd_pol:1;
> -	unsigned fid_pol:1;
> -};
> -
> -struct vpif_subdev_info {
> -	const char *name;
> -	struct i2c_board_info board_info;
> -	u32 input;
> -	u32 output;
> -	unsigned can_route:1;
> -	struct vpif_interface vpif_if;
> -};
> -
> -struct vpif_display_config {
> -	int (*set_clock)(int, int);
> -	struct vpif_subdev_info *subdevinfo;
> -	int subdev_count;
> -	const char **output;
> -	int output_count;
> -	const char *card_name;
> -};
> -
> -struct vpif_input {
> -	struct v4l2_input input;
> -	const char *subdev_name;
> -};
> -
> -#define VPIF_CAPTURE_MAX_CHANNELS	2
> -
> -struct vpif_capture_chan_config {
> -	const struct vpif_input *inputs;
> -	int input_count;
> -};
> -
> -struct vpif_capture_config {
> -	int (*setup_input_channel_mode)(int);
> -	int (*setup_input_path)(int, const char *);
> -	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
> -	struct vpif_subdev_info *subdev_info;
> -	int subdev_count;
> -	const char *card_name;
> -};
> -
>  void dm646x_setup_vpif(struct vpif_display_config *,
>  		       struct vpif_capture_config *);
>  
> diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
> index 10550bd..e76dded 100644
> --- a/drivers/media/video/davinci/vpif.h
> +++ b/drivers/media/video/davinci/vpif.h
> @@ -20,6 +20,7 @@
>  #include <linux/videodev2.h>
>  #include <mach/hardware.h>
>  #include <mach/dm646x.h>
> +#include <media/davinci/vpif.h>
>  
>  /* Maximum channel allowed */
>  #define VPIF_NUM_CHANNELS		(4)
> diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
> index 7a4196d..fa50b6b 100644
> --- a/drivers/media/video/davinci/vpif_capture.h
> +++ b/drivers/media/video/davinci/vpif_capture.h
> @@ -28,7 +28,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/videobuf-core.h>
>  #include <media/videobuf-dma-contig.h>
> -#include <mach/dm646x.h>
> +#include <media/davinci/vpif.h>
>  
>  #include "vpif.h"
>  
> diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
> index b53aaa8..b531a01 100644
> --- a/drivers/media/video/davinci/vpif_display.h
> +++ b/drivers/media/video/davinci/vpif_display.h
> @@ -23,6 +23,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/videobuf-core.h>
>  #include <media/videobuf-dma-contig.h>
> +#include <media/davinci/vpif.h>
>  
>  #include "vpif.h"
>  
> diff --git a/include/media/davinci/vpif.h b/include/media/davinci/vpif.h
> new file mode 100644
> index 0000000..e4a4dc1
> --- /dev/null
> +++ b/include/media/davinci/vpif.h
> @@ -0,0 +1,73 @@
> +/*
> + * Copyright (C) 2011 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation version 2.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#ifndef _VPIF_INC_H
> +#define _VPIF_INC_H
> +
> +#include <linux/i2c.h>
> +
> +#define VPIF_CAPTURE_MAX_CHANNELS	2
> +
> +enum vpif_if_type {
> +	VPIF_IF_BT656,
> +	VPIF_IF_BT1120,
> +	VPIF_IF_RAW_BAYER
> +};
> +
> +struct vpif_interface {
> +	enum vpif_if_type if_type;
> +	unsigned hd_pol:1;
> +	unsigned vd_pol:1;
> +	unsigned fid_pol:1;
> +};
> +
> +struct vpif_subdev_info {
> +	const char *name;
> +	struct i2c_board_info board_info;
> +	u32 input;
> +	u32 output;
> +	unsigned can_route:1;
> +	struct vpif_interface vpif_if;
> +};
> +
> +struct vpif_display_config {
> +	int (*set_clock)(int, int);
> +	struct vpif_subdev_info *subdevinfo;
> +	int subdev_count;
> +	const char **output;
> +	int output_count;
> +	const char *card_name;
> +};
> +
> +struct vpif_input {
> +	struct v4l2_input input;
> +	const char *subdev_name;
> +};
> +
> +struct vpif_capture_chan_config {
> +	const struct vpif_input *inputs;
> +	int input_count;
> +};
> +
> +struct vpif_capture_config {
> +	int (*setup_input_channel_mode)(int);
> +	int (*setup_input_path)(int, const char *);
> +	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
> +	struct vpif_subdev_info *subdev_info;
> +	int subdev_count;
> +	const char *card_name;
> +};
> +#endif /* _VPIF_INC_H */
> -- 
> 1.6.2.4
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

