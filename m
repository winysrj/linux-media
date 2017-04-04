Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37112 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752879AbdDDJ3W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 05:29:22 -0400
Date: Tue, 4 Apr 2017 12:29:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/2] media: Add a driver for the ov5645 camera sensor.
Message-ID: <20170404092917.GA3288@valkosipuli.retiisi.org.uk>
References: <1491228172-28548-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491228172-28548-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Apr 03, 2017 at 05:02:52PM +0300, Todor Tomov wrote:
...
> +power_down:
> +	ov5645_s_power(&ov5645->sd, false);
> +free_entity:
> +	media_entity_cleanup(&ov5645->sd.entity);
> +free_ctrl:
> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
> +	mutex_destroy(&ov5645->power_lock);
> +
> +	return ret;
> +}
> +
> +
> +static int ov5645_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov5645 *ov5645 = to_ov5645(sd);
> +
> +	v4l2_async_unregister_subdev(&ov5645->sd);
> +	media_entity_cleanup(&ov5645->sd.entity);
> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
> +	mutex_destroy(&ov5645->power_lock);
> +
> +	return 0;
> +}
> +

An extra newline here and above the function above.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +
> +static const struct i2c_device_id ov5645_id[] = {
> +	{ "ov5645", 0 },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, ov5645_id);
> +
> +static const struct of_device_id ov5645_of_match[] = {
> +	{ .compatible = "ovti,ov5645" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ov5645_of_match);
> +
> +static struct i2c_driver ov5645_i2c_driver = {
> +	.driver = {
> +		.of_match_table = of_match_ptr(ov5645_of_match),
> +		.name  = "ov5645",
> +	},
> +	.probe  = ov5645_probe,
> +	.remove = ov5645_remove,
> +	.id_table = ov5645_id,
> +};
> +
> +module_i2c_driver(ov5645_i2c_driver);
> +
> +MODULE_DESCRIPTION("Omnivision OV5645 Camera Driver");
> +MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
> +MODULE_LICENSE("GPL v2");

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
