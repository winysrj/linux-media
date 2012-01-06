Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33768 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2AFKFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 05:05:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 12/17] omap3isp: Add lane configuration to platform data
Date: Fri, 6 Jan 2012 11:06:04 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-12-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1324412889-17961-12-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061106.04553.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 20 December 2011 21:28:04 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Add lane configuration (order of clock and data lane) to platform data on
> both CCP2 and CSI-2.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispcsiphy.h |   15 ++-------------
>  include/media/omap3isp.h                 |   15 +++++++++++++++
>  2 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispcsiphy.h
> b/drivers/media/video/omap3isp/ispcsiphy.h index 9596dc6..e93a661 100644
> --- a/drivers/media/video/omap3isp/ispcsiphy.h
> +++ b/drivers/media/video/omap3isp/ispcsiphy.h
> @@ -27,22 +27,11 @@
>  #ifndef OMAP3_ISP_CSI_PHY_H
>  #define OMAP3_ISP_CSI_PHY_H
> 
> +#include <media/omap3isp.h>
> +
>  struct isp_csi2_device;
>  struct regulator;
> 
> -struct csiphy_lane {
> -	u8 pos;
> -	u8 pol;
> -};
> -
> -#define ISP_CSIPHY2_NUM_DATA_LANES	2
> -#define ISP_CSIPHY1_NUM_DATA_LANES	1
> -
> -struct isp_csiphy_lanes_cfg {
> -	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
> -	struct csiphy_lane clk;
> -};
> -
>  struct isp_csiphy_dphy_cfg {
>  	u8 ths_term;
>  	u8 ths_settle;
> diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
> index e917b1d..8fe0bdf 100644
> --- a/include/media/omap3isp.h
> +++ b/include/media/omap3isp.h
> @@ -86,6 +86,19 @@ enum {
>  	ISP_CCP2_MODE_CCP2 = 1,
>  };
> 
> +struct csiphy_lane {
> +	u8 pos;
> +	u8 pol;
> +};
> +
> +#define ISP_CSIPHY2_NUM_DATA_LANES	2
> +#define ISP_CSIPHY1_NUM_DATA_LANES	1
> +
> +struct isp_csiphy_lanes_cfg {
> +	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
> +	struct csiphy_lane clk;
> +};

Could you please document the two structures using kerneldoc ?

> +
>  /**
>   * struct isp_ccp2_platform_data - CCP2 interface platform data
>   * @strobe_clk_pol: Strobe/clock polarity
> @@ -105,6 +118,7 @@ struct isp_ccp2_platform_data {
>  	unsigned int ccp2_mode:1;
>  	unsigned int phy_layer:1;
>  	unsigned int vpclk_div:2;
> +	struct isp_csiphy_lanes_cfg *lanecfg;

Lane configuration is mandatory, what about embedding struct 
isp_csiphy_lanes_cfg inside struct isp_ccp2_platform instead of having a 
pointer ?

>  };
> 
>  /**
> @@ -115,6 +129,7 @@ struct isp_ccp2_platform_data {
>  struct isp_csi2_platform_data {
>  	unsigned crc:1;
>  	unsigned vpclk_div:2;
> +	struct isp_csiphy_lanes_cfg *lanecfg;

Same here.

>  };
> 
>  struct isp_subdev_i2c_board_info {

-- 
Regards,

Laurent Pinchart
