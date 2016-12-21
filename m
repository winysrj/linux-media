Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39760 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758962AbcLUNnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 08:43:14 -0500
Date: Wed, 21 Dec 2016 15:42:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161221134235.GH16630@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214122451.GB27011@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for the update.

On Wed, Dec 14, 2016 at 01:24:51PM +0100, Pavel Machek wrote:
...
> +static int et8ek8_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct et8ek8_sensor *sensor =
> +		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		return et8ek8_set_gain(sensor, ctrl->val);
> +
> +	case V4L2_CID_EXPOSURE:
> +	{
> +		int rows;
> +		struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +		rows = ctrl->val;
> +		return et8ek8_i2c_write_reg(client, ET8EK8_REG_16BIT, 0x1243,
> +					    swab16(rows));

Why swab16()? Doesn't the et8ek8_i2c_write_reg() already do the right thing?

16-bit writes aren't used elsewhere... and the register address and value
seem to have different endianness there, it looks like a bug to me in that
function.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
