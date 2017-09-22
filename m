Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53399 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdIVIoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 04:44:16 -0400
Date: Fri, 22 Sep 2017 10:44:13 +0200
From: Mylene JOSSERAND <mylene.josserand@free-electrons.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: maxime.ripard@free-electrons.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20170922104413.5d7d64e7@dell-desktop.home>
In-Reply-To: <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
        <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Yong,

Thank you for these drivers!

I tested it with an OV5640 camera on an Nanopi M1 plus (Allwinner H3)
and I noticed that I got a frame correctly displayed only on a half of
the frame's size.

It is related to your "sun6i_csi_set_window" function (see
below).

> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> and CSI1 is used for parallel interface. This is not documented in
> datasheet but by testing and guess.
> 
> This patch implement a v4l2 framework driver for it.
> 
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
> 
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  drivers/media/platform/Kconfig                   |   1 +
>  drivers/media/platform/Makefile                  |   2 +
>  drivers/media/platform/sun6i-csi/Kconfig         |   9 +
>  drivers/media/platform/sun6i-csi/Makefile        |   3 +
>  drivers/media/platform/sun6i-csi/sun6i_csi.c     | 545
> +++++++++++++++ drivers/media/platform/sun6i-csi/sun6i_csi.h     |
> 203 ++++++ drivers/media/platform/sun6i-csi/sun6i_csi_v3s.c | 827
> +++++++++++++++++++++++
> drivers/media/platform/sun6i-csi/sun6i_csi_v3s.h | 206 ++++++
> drivers/media/platform/sun6i-csi/sun6i_video.c   | 663
> ++++++++++++++++++ drivers/media/platform/sun6i-csi/sun6i_video.h
> |  61 ++ 10 files changed, 2520 insertions(+) create mode 100644
> drivers/media/platform/sun6i-csi/Kconfig create mode 100644
> drivers/media/platform/sun6i-csi/Makefile create mode 100644
> drivers/media/platform/sun6i-csi/sun6i_csi.c create mode 100644
> drivers/media/platform/sun6i-csi/sun6i_csi.h create mode 100644
> drivers/media/platform/sun6i-csi/sun6i_csi_v3s.c create mode 100644
> drivers/media/platform/sun6i-csi/sun6i_csi_v3s.h create mode 100644
> drivers/media/platform/sun6i-csi/sun6i_video.c create mode 100644
> drivers/media/platform/sun6i-csi/sun6i_video.h
> 
> diff --git a/drivers/media/platform/Kconfig
> b/drivers/media/platform/Kconfig index 0c741d1..8371a87 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -143,6 +143,7 @@ source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
>  source "drivers/media/platform/rcar-vin/Kconfig"
>  source "drivers/media/platform/atmel/Kconfig"
> +source "drivers/media/platform/sun6i-csi/Kconfig"
>  

<snip>

> +static void sun6i_csi_set_format(struct sun6i_csi_dev *sdev)
> +{
> +	struct sun6i_csi *csi = &sdev->csi;
> +	u32 cfg;
> +	u32 val;
> +
> +	regmap_read(sdev->regmap, CSI_CH_CFG_REG, &cfg);
> +
> +	cfg &= ~(CSI_CH_CFG_INPUT_FMT_MASK |
> +		 CSI_CH_CFG_OUTPUT_FMT_MASK | CSI_CH_CFG_VFLIP_EN |
> +		 CSI_CH_CFG_HFLIP_EN | CSI_CH_CFG_FIELD_SEL_MASK |
> +		 CSI_CH_CFG_INPUT_SEQ_MASK);
> +
> +	val = get_csi_input_format(csi->config.code,
> csi->config.pixelformat);
> +	cfg |= CSI_CH_CFG_INPUT_FMT(val);
> +
> +	val = get_csi_output_format(csi->config.code,
> csi->config.field);
> +	cfg |= CSI_CH_CFG_OUTPUT_FMT(val);
> +
> +	val = get_csi_input_seq(csi->config.code,
> csi->config.pixelformat);
> +	cfg |= CSI_CH_CFG_INPUT_SEQ(val);
> +
> +	if (csi->config.field == V4L2_FIELD_TOP)
> +		cfg |= CSI_CH_CFG_FIELD_SEL_FIELD0;
> +	else if (csi->config.field == V4L2_FIELD_BOTTOM)
> +		cfg |= CSI_CH_CFG_FIELD_SEL_FIELD1;
> +	else
> +		cfg |= CSI_CH_CFG_FIELD_SEL_BOTH;
> +
> +	regmap_write(sdev->regmap, CSI_CH_CFG_REG, cfg);
> +}
> +
> +static void sun6i_csi_set_window(struct sun6i_csi_dev *sdev)
> +{
> +	struct sun6i_csi_config *config = &sdev->csi.config;
> +	u32 bytesperline_y;
> +	u32 bytesperline_c;
> +	int *planar_offset = sdev->planar_offset;
> +
> +	regmap_write(sdev->regmap, CSI_CH_HSIZE_REG,
> +		     CSI_CH_HSIZE_HOR_LEN(config->width) |
> +		     CSI_CH_HSIZE_HOR_START(0));
> +	regmap_write(sdev->regmap, CSI_CH_VSIZE_REG,
> +		     CSI_CH_VSIZE_VER_LEN(config->height) |
> +		     CSI_CH_VSIZE_VER_START(0));

In my case, the HOR_LEN and VER_LEN were not correctly configured.

They were configured to width and height (640 * 480) but as I was
using a YUYV format, the pixel's size is 2 bytes so the
horizontal/vertical lines' lengths were divided by 2.

Currently, I fixed that by getting the number of bytes per pixel with
"v4l2_pixformat_get_bpp()":

+       int bytes_pixel;
+
+       bytes_pixel = v4l2_pixformat_get_bpp(config->pixelformat) / 8;
 
        regmap_write(sdev->regmap, CSI_CH_HSIZE_REG,
-                    CSI_CH_HSIZE_HOR_LEN(config->width) |
+                    CSI_CH_HSIZE_HOR_LEN(config->width * bytes_pixel) |
                     CSI_CH_HSIZE_HOR_START(0));
        regmap_write(sdev->regmap, CSI_CH_VSIZE_REG,
-                    CSI_CH_VSIZE_VER_LEN(config->height) |
+                    CSI_CH_VSIZE_VER_LEN(config->height * bytes_pixel)
  | CSI_CH_VSIZE_VER_START(0));

There is certainly a nicer way to handle that.

> +
> +	planar_offset[0] = 0;
> +	switch(config->pixelformat) {
> +	case V4L2_PIX_FMT_HM12:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		bytesperline_y = config->width;
> +		bytesperline_c = config->width;
> +		planar_offset[1] = bytesperline_y * config->height;
> +		planar_offset[2] = -1;
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		bytesperline_y = config->width;
> +		bytesperline_c = config->width / 2;
> +		planar_offset[1] = bytesperline_y * config->height;
> +		planar_offset[2] = planar_offset[1] +
> +				bytesperline_c * config->height / 2;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		bytesperline_y = config->width;
> +		bytesperline_c = config->width / 2;
> +		planar_offset[1] = bytesperline_y * config->height;
> +		planar_offset[2] = planar_offset[1] +
> +				bytesperline_c * config->height;
> +		break;
> +	default: /* raw */
> +		bytesperline_y =
> (v4l2_pixformat_get_bpp(config->pixelformat) *
> +				  config->width) / 8;
> +		bytesperline_c = 0;
> +		planar_offset[1] = -1;
> +		planar_offset[2] = -1;
> +		break;
> +	}
> +
> +	regmap_write(sdev->regmap, CSI_CH_BUF_LEN_REG,
> +		     CSI_CH_BUF_LEN_BUF_LEN_C(bytesperline_c) |
> +		     CSI_CH_BUF_LEN_BUF_LEN_Y(bytesperline_y));
> +}
> +
> +static int get_supported_pixformats(struct sun6i_csi *csi,
> +				    const u32 **pixformats)
> +{
> +	if (pixformats != NULL)
> +		*pixformats = supported_pixformats;
> +
> +	return ARRAY_SIZE(supported_pixformats);
> +}
> +
> +static bool is_format_support(struct sun6i_csi *csi, u32 pixformat,
> +			      u32 mbus_code)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +
> +	return __is_format_support(sdev, pixformat, mbus_code);
> +}
> +
> +static int set_power(struct sun6i_csi *csi, bool enable)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +	struct regmap *regmap = sdev->regmap;
> +	int ret;
> +
> +	if (!enable) {
> +		regmap_update_bits(regmap, CSI_EN_REG,
> CSI_EN_CSI_EN, 0); +
> +		clk_disable_unprepare(sdev->clk_ram);
> +		clk_disable_unprepare(sdev->clk_mod);
> +		clk_disable_unprepare(sdev->clk_ahb);
> +		reset_control_assert(sdev->rstc_ahb);
> +		return 0;
> +	}
> +
> +	ret = clk_prepare_enable(sdev->clk_ahb);
> +	if (ret) {
> +		dev_err(sdev->dev, "Enable ahb clk err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(sdev->clk_mod);
> +	if (ret) {
> +		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(sdev->clk_ram);
> +	if (ret) {
> +		dev_err(sdev->dev, "Enable clk_dram_csi clk err
> %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (!IS_ERR_OR_NULL(sdev->rstc_ahb)) {
> +		ret = reset_control_deassert(sdev->rstc_ahb);
> +		if (ret) {
> +			dev_err(sdev->dev, "reset err %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN,
> CSI_EN_CSI_EN); +
> +	return 0;
> +}

<snip>

Thank you in advance!

Best regards,

-- 
Mylène Josserand, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
