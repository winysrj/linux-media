Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45912 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750747AbdLRGYB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 01:24:01 -0500
Subject: Re: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
To: Wenyou Yang <wenyou.yang@microchip.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        devicetree@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
 <20171211013146.2497-3-wenyou.yang@microchip.com>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <1641aa67-b05e-47e2-600c-70b77571b450@iki.fi>
Date: Wed, 13 Dec 2017 22:06:29 +0200
MIME-Version: 1.0
In-Reply-To: <20171211013146.2497-3-wenyou.yang@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wenyou,

Wenyou Yang wrote:
...
> +static int ov7740_start_streaming(struct ov7740 *ov7740)
> +{
> +	int ret;
> +
> +	if (ov7740->fmt) {
> +		ret = regmap_multi_reg_write(ov7740->regmap,
> +					     ov7740->fmt->regs,
> +					     ov7740->fmt->reg_num);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (ov7740->frmsize) {
> +		ret = regmap_multi_reg_write(ov7740->regmap,
> +					     ov7740->frmsize->regs,
> +					     ov7740->frmsize->reg_num);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return __v4l2_ctrl_handler_setup(ov7740->subdev.ctrl_handler);

I believe you're still setting the controls after starting streaming.

-- 
Sakari Ailus
sakari.ailus@iki.fi
