Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:44694 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbcGGPfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:35:53 -0400
Subject: Re: [PATCH 03/11] media: adv7180: add power pin control
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-4-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <577E76D7.9090609@metafoo.de>
Date: Thu, 7 Jul 2016 17:35:51 +0200
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-4-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> @@ -1190,6 +1207,20 @@ out_unlock:
>  	return ret;
>  }
>  
> +static int adv7180_of_parse(struct adv7180_state *state)

Since there is nothing of specific in here anymore the name should be
changed, or maybe just inline the code directly in probe.

> +{
> +	struct i2c_client *client = state->client;
> +
> +	state->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",

I'd use "powerdown", vowels don't cost extra ;):

> +						   GPIOD_OUT_HIGH);
> +	if (IS_ERR(state->pwdn_gpio)) {
> +		v4l_err(client, "request for power pin failed\n");

Include the error number in the message.

> +		return PTR_ERR(state->pwdn_gpio);
> +	}
> +
> +	return 0;
> +}

