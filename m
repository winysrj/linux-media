Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:56152 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbcFOQFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 12:05:53 -0400
Subject: Re: [PATCH 35/38] media: adv7180: add power pin control
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1465944574-15745-36-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <57617CDE.905@metafoo.de>
Date: Wed, 15 Jun 2016 18:05:50 +0200
MIME-Version: 1.0
In-Reply-To: <1465944574-15745-36-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2016 12:49 AM, Steve Longerbeam wrote:
> +		usleep_range(5000, 5001);

That's kind of not how usleep_range() (the emphasis is on range) is supposed
to be used. You typically dont care too much about the upper limit here so
something like maybe 10000 is more appropriate.


> +static int adv7180_of_parse(struct adv7180_state *state)
> +{
> +	struct i2c_client *client = state->client;
> +	struct device_node *np = client->dev.of_node;
> +	int ret;
> +
> +	ret = of_get_named_gpio(np, "pwdn-gpio", 0);
> +
> +	if (gpio_is_valid(ret)) {
> +		state->pwdn_gpio = ret;
> +		ret = devm_gpio_request_one(&client->dev,
> +					    state->pwdn_gpio,
> +					    GPIOF_OUT_INIT_HIGH,
> +					    "adv7180_pwdn");


This should use the new GPIO descriptor API. That will also make the code
devicetree independent. Otherwise patch looks OK.

> +		if (ret < 0) {
> +			v4l_err(client, "request for power pin failed\n");
> +			return ret;
> +		}
> +	} else {
> +		if (ret == -EPROBE_DEFER)
> +			return ret;
> +		/* assume a power-down gpio is not required */
> +		state->pwdn_gpio = -1;
> +	}
> +
> +	return 0;
> +}

