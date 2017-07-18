Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50204 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751334AbdGRIle (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 04:41:34 -0400
Date: Tue, 18 Jul 2017 11:41:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com, niklas.soderlund@ragnatech.se,
        hans.verkuil@cisco.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Hyungwoo Yang <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v7 2/3] media: i2c: adv748x: add adv748x driver
Message-ID: <20170718084128.e3eaio6ua2qf346g@valkosipuli.retiisi.org.uk>
References: <cover.f44897c9f4c2d4555dfa156cc24a755477e409bf.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
 <af59e8809a954d44b7bc2b0e6c654a2e0fdd5f6c.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af59e8809a954d44b7bc2b0e6c654a2e0fdd5f6c.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

A few more minor matters that you might want to address on top of Hans's
pull request.

On Thu, Jul 06, 2017 at 12:01:16PM +0100, Kieran Bingham wrote:
...
> +static int adv748x_afe_g_input_status(struct v4l2_subdev *sd, u32 *status)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int ret;
> +
> +	mutex_lock(&state->mutex);
> +
> +	ret = adv748x_afe_status(afe, status, NULL);
> +
> +	mutex_unlock(&state->mutex);

A newline here would be nice.

> +	return ret;
> +}

...

> +int adv748x_csi2_set_pixelrate(struct v4l2_subdev *sd, s64 rate)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	ctrl = v4l2_ctrl_find(sd->ctrl_handler, V4L2_CID_PIXEL_RATE);

It'd be much nicer to store the control pointer to your device's own struct
and use it. No need to look it up or check whether it was found.

> +	if (!ctrl)
> +		return -EINVAL;
> +
> +	return v4l2_ctrl_s_ctrl_int64(ctrl, rate);
> +}

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
