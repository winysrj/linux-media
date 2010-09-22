Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:60749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752212Ab0IVJMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 05:12:37 -0400
Date: Wed, 22 Sep 2010 11:12:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 3/6] SoC Camera: add driver for OV6650 sensor
In-Reply-To: <201009110325.08504.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1009221006270.32562@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110325.08504.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Ok, just a couple more comments, all looking quite good so far, if we get 
a new version soon enough, we still might manage it for 2.6.37

On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:

[snip]

> +/* write a register */
> +static int ov6650_reg_write(struct i2c_client *client, u8 reg, u8 val)
> +{
> +	int ret;
> +	unsigned char data[2] = { reg, val };
> +	struct i2c_msg msg = {
> +		.addr	= client->addr,
> +		.flags	= 0,
> +		.len	= 2,
> +		.buf	= data,
> +	};
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	msleep_interruptible(1);

Why do you want _interruptible here? Firstly it's just 1ms, secondly - 
why?...

> +
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Failed writing register 0x%02x!\n", reg);
> +		return ret;
> +	}
> +	return 0;
> +}

...

> +/* set the format we will capture in */
> +static int ov6650_s_fmt(struct v4l2_subdev *sd,
> +			struct v4l2_mbus_framefmt *mf)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct soc_camera_device *icd	= client->dev.platform_data;
> +	struct soc_camera_sense *sense = icd->sense;
> +	struct ov6650 *priv = to_ov6650(client);
> +	enum v4l2_mbus_pixelcode code = mf->code;
> +	unsigned long pclk;
> +	u8 coma_set = 0, coma_mask = 0, coml_set = 0, coml_mask = 0;
> +	u8 clkrc, clkrc_div;
> +	int ret;
> +
> +	/* select color matrix configuration for given color encoding */
> +	switch (code) {
> +	case V4L2_MBUS_FMT_GREY8_1X8:
> +		dev_dbg(&client->dev, "pixel format GREY8_1X8\n");
> +		coma_set |= COMA_BW;
> +		coma_mask |= COMA_RGB | COMA_WORD_SWAP | COMA_BYTE_SWAP;
> +		break;
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		dev_dbg(&client->dev, "pixel format YUYV8_2X8_LE\n");
> +		coma_set |= COMA_WORD_SWAP;
> +		coma_mask |= COMA_RGB | COMA_BW | COMA_BYTE_SWAP;
> +		break;
> +	case V4L2_MBUS_FMT_YVYU8_2X8:
> +		dev_dbg(&client->dev, "pixel format YVYU8_2X8_LE (untested)\n");
> +		coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP |
> +				COMA_BYTE_SWAP;
> +		break;
> +	case V4L2_MBUS_FMT_UYVY8_2X8:
> +		dev_dbg(&client->dev, "pixel format YUYV8_2X8_BE\n");
> +		if (mf->width == W_CIF) {
> +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW;
> +		} else {
> +			coma_set |= COMA_BYTE_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> +		}
> +		break;
> +	case V4L2_MBUS_FMT_VYUY8_2X8:
> +		dev_dbg(&client->dev, "pixel format YVYU8_2X8_BE (untested)\n");
> +		if (mf->width == W_CIF) {
> +			coma_set |= COMA_BYTE_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> +		} else {
> +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW;
> +		}
> +		break;
> +	case V4L2_MBUS_FMT_SBGGR8_1X8:
> +		dev_dbg(&client->dev, "pixel format SBGGR8_1X8 (untested)\n");
> +		coma_set |= COMA_RAW_RGB | COMA_RGB;
> +		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
> +		break;
> +	default:
> +		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
> +		return -EINVAL;
> +	}
> +	priv->code = code;
> +
> +	if ((code == V4L2_MBUS_FMT_GREY8_1X8) ||
> +			(code == V4L2_MBUS_FMT_SBGGR8_1X8)) {

Superfluous parenthesis

> +		coml_mask |= COML_ONE_CHANNEL;
> +		priv->pclk_max = 4000000;
> +	} else {
> +		coml_set |= COML_ONE_CHANNEL;
> +		priv->pclk_max = 8000000;
> +	}

coml_mask and coml_set are only set here and only used once below, so, 
dropping initialisation to 0 in variable definitions and just doing

+	if (code == V4L2_MBUS_FMT_GREY8_1X8 ||
+			code == V4L2_MBUS_FMT_SBGGR8_1X8) {
+		coml_mask = COML_ONE_CHANNEL;
+		coml_set = 0;
+		priv->pclk_max = 4000000;
+	} else {
+		coml_mask = 0;
+		coml_set = COML_ONE_CHANNEL;
+		priv->pclk_max = 8000000;
+	}

would work too.

> +
> +	if (code == V4L2_MBUS_FMT_SBGGR8_1X8)
> +		priv->colorspace = V4L2_COLORSPACE_SRGB;
> +	else
> +		priv->colorspace = V4L2_COLORSPACE_JPEG;
> +
> +	/*
> +	 * Select register configuration for given resolution.
> +	 * To be replaced with a common function that does it, once available.
> +	 */
> +	ov6650_res_roundup(&mf->width, &mf->height);
> +
> +	switch (mf->width) {
> +	case W_QCIF:
> +		dev_dbg(&client->dev, "resolution QCIF\n");
> +		priv->qcif = 1;
> +		coma_set |= COMA_QCIF;
> +		priv->pclk_max /= 2;
> +		break;
> +	case W_CIF:
> +		dev_dbg(&client->dev, "resolution CIF\n");
> +		priv->qcif = 0;
> +		coma_mask |= COMA_QCIF;
> +		break;
> +	default:
> +		dev_err(&client->dev, "unspported resolution!\n");
> +		return -EINVAL;
> +	}
> +
> +	priv->rect.left	  = DEF_HSTRT << !priv->qcif;
> +	priv->rect.top	  = DEF_VSTRT << !priv->qcif;
> +	priv->rect.width  = mf->width;
> +	priv->rect.height = mf->height;

Sorry, don't understand. The sensor can do both - cropping per HSTRT, 
HSTOP, VSTRT and VSTOP and scaling per COMA_CIF / COMA_QCIF, right? But 
which of them is stored in your priv->rect? Is this the input window 
(cropping) or the output one (scaling)? You overwrite it in .s_fmt and 
.s_crop...

> +
> +	if (priv->timeperframe.numerator && priv->timeperframe.denominator)
> +		pclk = priv->pclk_max * priv->timeperframe.denominator /
> +				(FRAME_RATE_MAX * priv->timeperframe.numerator);
> +	else
> +		pclk = priv->pclk_max;
> +
> +	if (sense) {
> +		if (sense->master_clock == 8000000) {
> +			dev_dbg(&client->dev, "8MHz input clock\n");
> +			clkrc = CLKRC_6MHz;
> +		} else if (sense->master_clock == 12000000) {
> +			dev_dbg(&client->dev, "12MHz input clock\n");
> +			clkrc = CLKRC_12MHz;
> +		} else if (sense->master_clock == 16000000) {
> +			dev_dbg(&client->dev, "16MHz input clock\n");
> +			clkrc = CLKRC_16MHz;
> +		} else if (sense->master_clock == 24000000) {
> +			dev_dbg(&client->dev, "24MHz input clock\n");
> +			clkrc = CLKRC_24MHz;
> +		} else {
> +			dev_err(&client->dev,
> +				"unspported input clock, check platform data\n");
> +			return -EINVAL;
> +		}
> +		priv->pclk_limit = sense->pixel_clock_max;
> +		if (priv->pclk_limit && (priv->pclk_limit < pclk))

Don't think the compiler would complain without the internal parenthesis 
here?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
