Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-017.synserver.de ([212.40.185.17]:1076 "EHLO
	smtp-out-017.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbBCJvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 04:51:50 -0500
Message-ID: <54D09A35.1000500@metafoo.de>
Date: Tue, 03 Feb 2015 10:51:49 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	hans.verkuil@cisco.com, linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org, m.chehab@samsung.com,
	Pablo Anton <pablo.anton@vodalys-labs.com>
Subject: Re: [PATCH] media: i2c: ADV7604: Migrate to regmap
References: <1422785339-2699-1-git-send-email-jean-michel.hautbois@vodalys.com>
In-Reply-To: <1422785339-2699-1-git-send-email-jean-michel.hautbois@vodalys.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2015 11:08 AM, Jean-Michel Hautbois wrote:

Looks mostly good, some things in addition to what Hans already said.

[...]
> -
> -static s32 adv_smbus_write_byte_data(struct adv7604_state *state,
> -				     enum adv7604_page page, u8 command,
> -				     u8 value)
> +static int regmap_read_check(struct adv7604_state *state,
> +			     int client_page, u8 reg)

This should have adv rather than regmap prefix.


[...]
> +static int configure_regmap(struct adv7604_state *state, int region)
> +{
> +	int err;
> +
> +	if (!state->i2c_clients[region])
> +		return -ENODEV;
> +
> +	if (!state->regmap[region]) {

Given that this function is only called once for each regmap this check 
seems unnecessary,

> +
> +		state->regmap[region] =
> +			devm_regmap_init_i2c(state->i2c_clients[region],
> +					     &adv76xx_regmap[region]);
> +
> +		if (IS_ERR(state->regmap[region])) {
> +			err = PTR_ERR(state->regmap[region]);
> +			v4l_err(state->i2c_clients[region],
> +					"Error initializing regmap %d with error %d\n",
> +					region, err);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
[...]
