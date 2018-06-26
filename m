Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:53223 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935412AbeFZOZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 10:25:20 -0400
Date: Tue, 26 Jun 2018 17:25:15 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v6 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
Message-ID: <20180626142514.l7cww52d3466hio2@kekkonen.localdomain>
References: <20180509143159.20690-1-rui.silva@linaro.org>
 <20180509143159.20690-3-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509143159.20690-3-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 09, 2018 at 03:31:59PM +0100, Rui Miguel Silva wrote:
...
> +static int ov2680_init_cfg(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg)
> +{
> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	mf = v4l2_subdev_get_try_format(sd, cfg, 0);
> +
> +	*mf = sensor->fmt;

The init_cfg callback is intended for initialising the format configuration
(as well as compose and crop where relevant) to the device default values.
The implementation in e.g. drivers/media/i2c/ov7251.c seems abour right,
for instance.

I think this would be relevant in addressing the compile issues without
subdev uAPI, too.

I've postponed the two patches, feel free to send either delta or v7 of
this.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
