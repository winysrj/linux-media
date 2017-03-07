Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:44021 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755412AbdCGSCq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 13:02:46 -0500
Subject: Re: [PATCH v3 4/6] drm: bridge: dw-hdmi: Switch to V4L bus format and
 encodings
To: Neil Armstrong <narmstrong@baylibre.com>,
        <dri-devel@lists.freedesktop.org>,
        <laurent.pinchart+renesas@ideasonboard.com>,
        <architt@codeaurora.org>, <mchehab@kernel.org>
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
 <1488904944-14285-5-git-send-email-narmstrong@baylibre.com>
CC: <Jose.Abreu@synopsys.com>, <kieran.bingham@ideasonboard.com>,
        <linux-amlogic@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <hans.verkuil@cisco.com>,
        <sakari.ailus@linux.intel.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <977cfb29-af7a-2e28-7a7f-396d9ccf3eb8@synopsys.com>
Date: Tue, 7 Mar 2017 17:35:46 +0000
MIME-Version: 1.0
In-Reply-To: <1488904944-14285-5-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,


On 07-03-2017 16:42, Neil Armstrong wrote:
> Some display pipelines can only provide non-RBG input pixels to the HDMI TX
> Controller, this patch takes the pixel format from the plat_data if provided.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 322 +++++++++++++++++++++---------
>  include/drm/bridge/dw_hdmi.h              |  63 ++++++
>  2 files changed, 290 insertions(+), 95 deletions(-)
>
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> index 1ed8bc1..348311c 100644
> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> @@ -30,17 +30,14 @@
>  #include <drm/drm_encoder_slave.h>
>  #include <drm/bridge/dw_hdmi.h>
>  
> +#include <uapi/linux/media-bus-format.h>
> +#include <uapi/linux/videodev2.h>
> +
>  #include "dw-hdmi.h"
>  #include "dw-hdmi-audio.h"
>  
>  #define HDMI_EDID_LEN		512
>  
> -#define RGB			0
> -#define YCBCR444		1
> -#define YCBCR422_16BITS		2
> -#define YCBCR422_8BITS		3
> -#define XVYCC444		4
> -
>  enum hdmi_datamap {
>  	RGB444_8B = 0x01,
>  	RGB444_10B = 0x03,
> @@ -94,10 +91,10 @@ struct hdmi_vmode {
>  };
>  
>  struct hdmi_data_info {
> -	unsigned int enc_in_format;
> -	unsigned int enc_out_format;
> -	unsigned int enc_color_depth;
> -	unsigned int colorimetry;
> +	unsigned int enc_in_bus_format;
> +	unsigned int enc_out_bus_format;
> +	unsigned int enc_in_encoding;
> +	unsigned int enc_out_encoding;
>  	unsigned int pix_repet_factor;
>  	unsigned int hdcp_enable;
>  	struct hdmi_vmode video_mode;
> @@ -557,6 +554,92 @@ void dw_hdmi_audio_disable(struct dw_hdmi *hdmi)
>  }
>  EXPORT_SYMBOL_GPL(dw_hdmi_audio_disable);
>  
> +static bool hdmi_bus_fmt_is_rgb(unsigned int bus_format)
> +{
> +	switch (bus_format) {
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +	case MEDIA_BUS_FMT_RGB101010_1X30:
> +	case MEDIA_BUS_FMT_RGB121212_1X36:
> +	case MEDIA_BUS_FMT_RGB161616_1X48:
> +		return true;
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool hdmi_bus_fmt_is_yuv444(unsigned int bus_format)
> +{
> +	switch (bus_format) {
> +	case MEDIA_BUS_FMT_YUV8_1X24:
> +	case MEDIA_BUS_FMT_YUV10_1X30:
> +	case MEDIA_BUS_FMT_YUV12_1X36:
> +	case MEDIA_BUS_FMT_YUV16_1X48:
> +		return true;
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool hdmi_bus_fmt_is_yuv422(unsigned int bus_format)
> +{
> +	switch (bus_format) {
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +	case MEDIA_BUS_FMT_UYVY10_1X20:
> +	case MEDIA_BUS_FMT_UYVY12_1X24:
> +		return true;
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool hdmi_bus_fmt_is_yuv420(unsigned int bus_format)
> +{
> +	switch (bus_format) {
> +	case MEDIA_BUS_FMT_UYVY8_1_1X24:
> +	case MEDIA_BUS_FMT_UYVY10_1_1X30:
> +	case MEDIA_BUS_FMT_UYVY12_1_1X36:
> +	case MEDIA_BUS_FMT_UYVY16_1_1X48:
> +		return true;
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static int hdmi_bus_fmt_color_depth(unsigned int bus_format)
> +{
> +	switch (bus_format) {
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +	case MEDIA_BUS_FMT_YUV8_1X24:
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +	case MEDIA_BUS_FMT_UYVY8_1_1X24:
> +		return 8;
> +
> +	case MEDIA_BUS_FMT_RGB101010_1X30:
> +	case MEDIA_BUS_FMT_YUV10_1X30:
> +	case MEDIA_BUS_FMT_UYVY10_1X20:
> +	case MEDIA_BUS_FMT_UYVY10_1_1X30:
> +		return 10;
> +
> +	case MEDIA_BUS_FMT_RGB121212_1X36:
> +	case MEDIA_BUS_FMT_YUV12_1X36:
> +	case MEDIA_BUS_FMT_UYVY12_1X24:
> +	case MEDIA_BUS_FMT_UYVY12_1_1X36:
> +		return 12;
> +
> +	case MEDIA_BUS_FMT_RGB161616_1X48:
> +	case MEDIA_BUS_FMT_YUV16_1X48:
> +	case MEDIA_BUS_FMT_UYVY16_1_1X48:
> +		return 16;
> +
> +	default:
> +		return 0;

Maybe fallback to 8bpp in case of error as this is the most
common supported.

> +	}
> +}
> +
>  /*
>   * this submodule is responsible for the video data synchronization.
>   * for example, for RGB 4:4:4 input, the data map is defined as
> @@ -569,37 +652,45 @@ static void hdmi_video_sample(struct dw_hdmi *hdmi)
>  	int color_format = 0;
>  	u8 val;
>  
> -	if (hdmi->hdmi_data.enc_in_format == RGB) {
> -		if (hdmi->hdmi_data.enc_color_depth == 8)
> -			color_format = 0x01;
> -		else if (hdmi->hdmi_data.enc_color_depth == 10)
> -			color_format = 0x03;
> -		else if (hdmi->hdmi_data.enc_color_depth == 12)
> -			color_format = 0x05;
> -		else if (hdmi->hdmi_data.enc_color_depth == 16)
> -			color_format = 0x07;
> -		else
> -			return;
> -	} else if (hdmi->hdmi_data.enc_in_format == YCBCR444) {
> -		if (hdmi->hdmi_data.enc_color_depth == 8)
> -			color_format = 0x09;
> -		else if (hdmi->hdmi_data.enc_color_depth == 10)
> -			color_format = 0x0B;
> -		else if (hdmi->hdmi_data.enc_color_depth == 12)
> -			color_format = 0x0D;
> -		else if (hdmi->hdmi_data.enc_color_depth == 16)
> -			color_format = 0x0F;
> -		else
> -			return;
> -	} else if (hdmi->hdmi_data.enc_in_format == YCBCR422_8BITS) {
> -		if (hdmi->hdmi_data.enc_color_depth == 8)
> -			color_format = 0x16;
> -		else if (hdmi->hdmi_data.enc_color_depth == 10)
> -			color_format = 0x14;
> -		else if (hdmi->hdmi_data.enc_color_depth == 12)
> -			color_format = 0x12;
> -		else
> -			return;
> +	switch (hdmi->hdmi_data.enc_in_bus_format) {
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +		color_format = 0x01;
> +		break;
> +	case MEDIA_BUS_FMT_RGB101010_1X30:
> +		color_format = 0x03;
> +		break;
> +	case MEDIA_BUS_FMT_RGB121212_1X36:
> +		color_format = 0x05;
> +		break;
> +	case MEDIA_BUS_FMT_RGB161616_1X48:
> +		color_format = 0x07;
> +		break;
> +
> +	case MEDIA_BUS_FMT_YUV8_1X24:
> +		color_format = 0x09;
> +		break;
> +	case MEDIA_BUS_FMT_YUV10_1X30:
> +		color_format = 0x0B;
> +		break;
> +	case MEDIA_BUS_FMT_YUV12_1X36:
> +		color_format = 0x0D;
> +		break;
> +	case MEDIA_BUS_FMT_YUV16_1X48:
> +		color_format = 0x0F;
> +		break;

You should add here the 4:2.0 formats. I mean, 4:2:0 8 bits is
0x09, 4:2:0 10 bits is 0x0B, 4:2:0 12 bits is 0x0D and 4:2:0 16
bits is 0x0F.

Best regards,
Jose Miguel Abreu

> +
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +		color_format = 0x16;
> +		break;
> +	case MEDIA_BUS_FMT_UYVY10_1X20:
> +		color_format = 0x14;
> +		break;
> +	case MEDIA_BUS_FMT_UYVY12_1X24:
> +		color_format = 0x12;
> +		break;
> +
> +	default:
> +		return;
>  	}
>  
>  	val = HDMI_TX_INVID0_INTERNAL_DE_GENERATOR_DISABLE |
> @@ -622,26 +713,30 @@ static void hdmi_video_sample(struct dw_hdmi *hdmi)
>  
>  static int is_color_space_conversion(struct dw_hdmi *hdmi)
>  {
> -	return hdmi->hdmi_data.enc_in_format != hdmi->hdmi_data.enc_out_format;
> +	return hdmi->hdmi_data.enc_in_bus_format != hdmi->hdmi_data.enc_out_bus_format;
>  }
>  
>  static int is_color_space_decimation(struct dw_hdmi *hdmi)
>  {
> -	if (hdmi->hdmi_data.enc_out_format != YCBCR422_8BITS)
> +	if (!hdmi_bus_fmt_is_yuv422(hdmi->hdmi_data.enc_out_bus_format))
>  		return 0;
> -	if (hdmi->hdmi_data.enc_in_format == RGB ||
> -	    hdmi->hdmi_data.enc_in_format == YCBCR444)
> +
> +	if (hdmi_bus_fmt_is_rgb(hdmi->hdmi_data.enc_in_bus_format) ||
> +	    hdmi_bus_fmt_is_yuv444(hdmi->hdmi_data.enc_in_bus_format))
>  		return 1;
> +
>  	return 0;
>  }
>  
>  static int is_color_space_interpolation(struct dw_hdmi *hdmi)
>  {
> -	if (hdmi->hdmi_data.enc_in_format != YCBCR422_8BITS)
> +	if (!hdmi_bus_fmt_is_yuv422(hdmi->hdmi_data.enc_in_bus_format))
>  		return 0;
> -	if (hdmi->hdmi_data.enc_out_format == RGB ||
> -	    hdmi->hdmi_data.enc_out_format == YCBCR444)
> +
> +	if (hdmi_bus_fmt_is_rgb(hdmi->hdmi_data.enc_out_bus_format) ||
> +	    hdmi_bus_fmt_is_yuv444(hdmi->hdmi_data.enc_out_bus_format))
>  		return 1;
> +
>  	return 0;
>  }
>  
> @@ -652,15 +747,16 @@ static void dw_hdmi_update_csc_coeffs(struct dw_hdmi *hdmi)
>  	u32 csc_scale = 1;
>  
>  	if (is_color_space_conversion(hdmi)) {
> -		if (hdmi->hdmi_data.enc_out_format == RGB) {
> -			if (hdmi->hdmi_data.colorimetry ==
> -					HDMI_COLORIMETRY_ITU_601)
> +		if (hdmi_bus_fmt_is_rgb(hdmi->hdmi_data.enc_out_bus_format)) {
> +			if (hdmi->hdmi_data.enc_out_encoding ==
> +						V4L2_YCBCR_ENC_601)
>  				csc_coeff = &csc_coeff_rgb_out_eitu601;
>  			else
>  				csc_coeff = &csc_coeff_rgb_out_eitu709;
> -		} else if (hdmi->hdmi_data.enc_in_format == RGB) {
> -			if (hdmi->hdmi_data.colorimetry ==
> -					HDMI_COLORIMETRY_ITU_601)
> +		} else if (hdmi_bus_fmt_is_rgb(
> +					hdmi->hdmi_data.enc_in_bus_format)) {
> +			if (hdmi->hdmi_data.enc_out_encoding ==
> +						V4L2_YCBCR_ENC_601)
>  				csc_coeff = &csc_coeff_rgb_in_eitu601;
>  			else
>  				csc_coeff = &csc_coeff_rgb_in_eitu709;
> @@ -698,16 +794,23 @@ static void hdmi_video_csc(struct dw_hdmi *hdmi)
>  	else if (is_color_space_decimation(hdmi))
>  		decimation = HDMI_CSC_CFG_DECMODE_CHROMA_INT_FORMULA3;
>  
> -	if (hdmi->hdmi_data.enc_color_depth == 8)
> +	switch (hdmi_bus_fmt_color_depth(hdmi->hdmi_data.enc_out_bus_format)) {
> +	case 8:
>  		color_depth = HDMI_CSC_SCALE_CSC_COLORDE_PTH_24BPP;
> -	else if (hdmi->hdmi_data.enc_color_depth == 10)
> +		break;
> +	case 10:
>  		color_depth = HDMI_CSC_SCALE_CSC_COLORDE_PTH_30BPP;
> -	else if (hdmi->hdmi_data.enc_color_depth == 12)
> +		break;
> +	case 12:
>  		color_depth = HDMI_CSC_SCALE_CSC_COLORDE_PTH_36BPP;
> -	else if (hdmi->hdmi_data.enc_color_depth == 16)
> +		break;
> +	case 16:
>  		color_depth = HDMI_CSC_SCALE_CSC_COLORDE_PTH_48BPP;
> -	else
> +		break;
> +
> +	default:
>  		return;
> +	}
>  
>  	/* Configure the CSC registers */
>  	hdmi_writeb(hdmi, interpolation | decimation, HDMI_CSC_CFG);
> @@ -730,32 +833,43 @@ static void hdmi_video_packetize(struct dw_hdmi *hdmi)
>  	struct hdmi_data_info *hdmi_data = &hdmi->hdmi_data;
>  	u8 val, vp_conf;
>  
> -	if (hdmi_data->enc_out_format == RGB ||
> -	    hdmi_data->enc_out_format == YCBCR444) {
> -		if (!hdmi_data->enc_color_depth) {
> -			output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_BYPASS;
> -		} else if (hdmi_data->enc_color_depth == 8) {
> +	if (hdmi_bus_fmt_is_rgb(hdmi->hdmi_data.enc_out_bus_format) ||
> +	    hdmi_bus_fmt_is_yuv444(hdmi->hdmi_data.enc_out_bus_format)) {
> +		switch (hdmi_bus_fmt_color_depth(
> +					hdmi->hdmi_data.enc_out_bus_format)) {
> +		case 8:
>  			color_depth = 4;
>  			output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_BYPASS;
> -		} else if (hdmi_data->enc_color_depth == 10) {
> +			break;
> +		case 10:
>  			color_depth = 5;
> -		} else if (hdmi_data->enc_color_depth == 12) {
> +			break;
> +		case 12:
>  			color_depth = 6;
> -		} else if (hdmi_data->enc_color_depth == 16) {
> +			break;
> +		case 16:
>  			color_depth = 7;
> -		} else {
> -			return;
> +			break;
> +		default:
> +			output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_BYPASS;
>  		}
> -	} else if (hdmi_data->enc_out_format == YCBCR422_8BITS) {
> -		if (!hdmi_data->enc_color_depth ||
> -		    hdmi_data->enc_color_depth == 8)
> +	} else if (hdmi_bus_fmt_is_yuv422(hdmi->hdmi_data.enc_out_bus_format)) {
> +		switch (hdmi_bus_fmt_color_depth(
> +					hdmi->hdmi_data.enc_out_bus_format)) {
> +		case 0:
> +		case 8:
>  			remap_size = HDMI_VP_REMAP_YCC422_16bit;
> -		else if (hdmi_data->enc_color_depth == 10)
> +			break;
> +		case 10:
>  			remap_size = HDMI_VP_REMAP_YCC422_20bit;
> -		else if (hdmi_data->enc_color_depth == 12)
> +			break;
> +		case 12:
>  			remap_size = HDMI_VP_REMAP_YCC422_24bit;
> -		else
> +			break;
> +
> +		default:
>  			return;
> +		}
>  		output_select = HDMI_VP_CONF_OUTPUT_SELECTOR_YCC422;
>  	} else {
>  		return;
> @@ -1138,28 +1252,35 @@ static void hdmi_config_AVI(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
>  	/* Initialise info frame from DRM mode */
>  	drm_hdmi_avi_infoframe_from_display_mode(&frame, mode);
>  
> -	if (hdmi->hdmi_data.enc_out_format == YCBCR444)
> +	if (hdmi_bus_fmt_is_yuv444(hdmi->hdmi_data.enc_out_bus_format))
>  		frame.colorspace = HDMI_COLORSPACE_YUV444;
> -	else if (hdmi->hdmi_data.enc_out_format == YCBCR422_8BITS)
> +	else if (hdmi_bus_fmt_is_yuv422(hdmi->hdmi_data.enc_out_bus_format))
>  		frame.colorspace = HDMI_COLORSPACE_YUV422;
>  	else
>  		frame.colorspace = HDMI_COLORSPACE_RGB;
>  
>  	/* Set up colorimetry */
> -	if (hdmi->hdmi_data.enc_out_format == XVYCC444) {
> -		frame.colorimetry = HDMI_COLORIMETRY_EXTENDED;
> -		if (hdmi->hdmi_data.colorimetry == HDMI_COLORIMETRY_ITU_601)
> -			frame.extended_colorimetry =
> +	switch (hdmi->hdmi_data.enc_out_encoding) {
> +	case V4L2_YCBCR_ENC_601:
> +		if (hdmi->hdmi_data.enc_in_encoding == V4L2_YCBCR_ENC_XV601)
> +			frame.colorimetry = HDMI_COLORIMETRY_EXTENDED;
> +		else
> +			frame.colorimetry = HDMI_COLORIMETRY_ITU_601;
> +		frame.extended_colorimetry =
>  				HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
> -		else /*hdmi->hdmi_data.colorimetry == HDMI_COLORIMETRY_ITU_709*/
> -			frame.extended_colorimetry =
> +	case V4L2_YCBCR_ENC_709:
> +		if (hdmi->hdmi_data.enc_in_encoding == V4L2_YCBCR_ENC_XV709)
> +			frame.colorimetry = HDMI_COLORIMETRY_EXTENDED;
> +		else
> +			frame.colorimetry = HDMI_COLORIMETRY_ITU_709;
> +		frame.extended_colorimetry =
>  				HDMI_EXTENDED_COLORIMETRY_XV_YCC_709;
> -	} else if (hdmi->hdmi_data.enc_out_format != RGB) {
> -		frame.colorimetry = hdmi->hdmi_data.colorimetry;
> -		frame.extended_colorimetry = HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
> -	} else { /* Carries no data */
> -		frame.colorimetry = HDMI_COLORIMETRY_NONE;
> -		frame.extended_colorimetry = HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
> +		break;
> +	default: /* Carries no data */
> +		frame.colorimetry = HDMI_COLORIMETRY_ITU_601;
> +		frame.extended_colorimetry =
> +				HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
> +		break;
>  	}
>  
>  	frame.scan_mode = HDMI_SCAN_MODE_NONE;
> @@ -1436,19 +1557,30 @@ static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
>  	    (hdmi->vic == 21) || (hdmi->vic == 22) ||
>  	    (hdmi->vic == 2) || (hdmi->vic == 3) ||
>  	    (hdmi->vic == 17) || (hdmi->vic == 18))
> -		hdmi->hdmi_data.colorimetry = HDMI_COLORIMETRY_ITU_601;
> +		hdmi->hdmi_data.enc_out_encoding = V4L2_YCBCR_ENC_601;
>  	else
> -		hdmi->hdmi_data.colorimetry = HDMI_COLORIMETRY_ITU_709;
> +		hdmi->hdmi_data.enc_out_encoding = V4L2_YCBCR_ENC_709;
>  
>  	hdmi->hdmi_data.video_mode.mpixelrepetitionoutput = 0;
>  	hdmi->hdmi_data.video_mode.mpixelrepetitioninput = 0;
>  
> -	/* TODO: Get input format from IPU (via FB driver interface) */
> -	hdmi->hdmi_data.enc_in_format = RGB;
> +	/* TOFIX: Get input format from plat data or fallback to RGB888 */
> +	if (hdmi->plat_data->input_bus_format >= 0)
> +		hdmi->hdmi_data.enc_in_bus_format =
> +			hdmi->plat_data->input_bus_format;
> +	else
> +		hdmi->hdmi_data.enc_in_bus_format = MEDIA_BUS_FMT_RGB888_1X24;
> +
> +	/* TOFIX: Get input encoding from plat data or fallback to none */
> +	if (hdmi->plat_data->input_bus_encoding >= 0)
> +		hdmi->hdmi_data.enc_in_encoding =
> +			hdmi->plat_data->input_bus_encoding;
> +	else
> +		hdmi->hdmi_data.enc_in_encoding = V4L2_YCBCR_ENC_DEFAULT;
>  
> -	hdmi->hdmi_data.enc_out_format = RGB;
> +	/* TOFIX: Default to RGB888 output format */
> +	hdmi->hdmi_data.enc_out_bus_format = MEDIA_BUS_FMT_RGB888_1X24;
>  
> -	hdmi->hdmi_data.enc_color_depth = 8;
>  	hdmi->hdmi_data.pix_repet_factor = 0;
>  	hdmi->hdmi_data.hdcp_enable = 0;
>  	hdmi->hdmi_data.video_mode.mdataenablepolarity = true;
> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
> index bcceee8..c3b8da9 100644
> --- a/include/drm/bridge/dw_hdmi.h
> +++ b/include/drm/bridge/dw_hdmi.h
> @@ -14,6 +14,67 @@
>  
>  struct dw_hdmi;
>  
> +/**
> + * DOC: Supported input formats and encodings
> + *
> + * Depending on the Hardware configuration of the Controller IP, it supports
> + * a subset of the following input formats and encodings on it's internal
> + * 48bit bus.
> + *
> + * +----------------------+---------------------------------+------------------------------+ 
> + * + Format Name          + Format Code                     + Encodings                    +
> + * +----------------------+---------------------------------+------------------------------+
> + * + RGB 4:4:4 8bit       + ``MEDIA_BUS_FMT_RGB888_1X24``   + ``V4L2_YCBCR_ENC_DEFAULT``   +
> + * +----------------------+---------------------------------+------------------------------+
> + * + RGB 4:4:4 10bits     + ``MEDIA_BUS_FMT_RGB101010_1X30``+ ``V4L2_YCBCR_ENC_DEFAULT``   +
> + * +----------------------+---------------------------------+------------------------------+
> + * + RGB 4:4:4 12bits     + ``MEDIA_BUS_FMT_RGB121212_1X36``+ ``V4L2_YCBCR_ENC_DEFAULT``   +
> + * +----------------------+---------------------------------+------------------------------+
> + * + RGB 4:4:4 16bits     + ``MEDIA_BUS_FMT_RGB161616_1X48``+ ``V4L2_YCBCR_ENC_DEFAULT``   +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:4:4 8bit     + ``MEDIA_BUS_FMT_YUV8_1X24``     + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV601``  +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV709``  +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:4:4 10bits   + ``MEDIA_BUS_FMT_YUV10_1X30``    + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV601``  +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV709``  +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:4:4 12bits   + ``MEDIA_BUS_FMT_YUV12_1X36``    + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV601``  +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV709``  +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:4:4 16bits   + ``MEDIA_BUS_FMT_YUV16_1X48``    + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV601``  +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_XV709``  +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:2:2 8bit     + ``MEDIA_BUS_FMT_UYVY8_1X16``    + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:2:2 10bits   + ``MEDIA_BUS_FMT_UYVY10_1X20``   + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:2:2 12bits   + ``MEDIA_BUS_FMT_UYVY12_1X24``   + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:2:0 8bit     + ``MEDIA_BUS_FMT_UYVY8_1_1X24``  + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:2:0 10bits   + ``MEDIA_BUS_FMT_UYVY10_1_1X30`` + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:2:0 12bits   + ``MEDIA_BUS_FMT_UYVY12_1_1X36`` + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +----------------------+---------------------------------+------------------------------+
> + * + YCbCr 4:2:0 16bits   + ``MEDIA_BUS_FMT_UYVY16_1_1X48`` + ``V4L2_YCBCR_ENC_601``       +
> + * +                      +                                 + or ``V4L2_YCBCR_ENC_709``    +
> + * +----------------------+---------------------------------+------------------------------+
> + */
> +
>  enum {
>  	DW_HDMI_RES_8,
>  	DW_HDMI_RES_10,
> @@ -62,6 +123,8 @@ struct dw_hdmi_plat_data {
>  	struct regmap *regm;
>  	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
>  					   struct drm_display_mode *mode);
> +	unsigned long input_bus_format;
> +	unsigned long input_bus_encoding;
>  
>  	/* Vendor PHY support */
>  	const struct dw_hdmi_phy_ops *phy_ops;
