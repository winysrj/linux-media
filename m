Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58961 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbcFPBeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 21:34:17 -0400
Subject: Re: [PATCH 35/38] media: adv7180: add power pin control
To: Lars-Peter Clausen <lars@metafoo.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	<linux-media@vger.kernel.org>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1465944574-15745-36-git-send-email-steve_longerbeam@mentor.com>
 <57617CDE.905@metafoo.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <57620216.9040502@mentor.com>
Date: Wed, 15 Jun 2016 18:34:14 -0700
MIME-Version: 1.0
In-Reply-To: <57617CDE.905@metafoo.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

On 06/15/2016 09:05 AM, Lars-Peter Clausen wrote:
> On 06/15/2016 12:49 AM, Steve Longerbeam wrote:
>> +		usleep_range(5000, 5001);
> That's kind of not how usleep_range() (the emphasis is on range) is supposed
> to be used. You typically dont care too much about the upper limit here so
> something like maybe 10000 is more appropriate.

Good point, I fixed this as well as all other instances of
usleep_range() in the patch set.

>
>> +static int adv7180_of_parse(struct adv7180_state *state)
>> +{
>> +	struct i2c_client *client = state->client;
>> +	struct device_node *np = client->dev.of_node;
>> +	int ret;
>> +
>> +	ret = of_get_named_gpio(np, "pwdn-gpio", 0);
>> +
>> +	if (gpio_is_valid(ret)) {
>> +		state->pwdn_gpio = ret;
>> +		ret = devm_gpio_request_one(&client->dev,
>> +					    state->pwdn_gpio,
>> +					    GPIOF_OUT_INIT_HIGH,
>> +					    "adv7180_pwdn");
>
> This should use the new GPIO descriptor API. That will also make the code
> devicetree independent. Otherwise patch looks OK.

Thanks for the heads-up. I converted to gpiod here, and in all other
patches in the set that were using the deprecated API. Also took the
time to review the active low/high flags in the device tree, and made
sure they are correct and are using the explicit flags GPIO_ACTIVE_*.

The changes are in a new branch mx6-media-staging-v2.1 in my fork
on github (git@github.com:slongerbeam/mediatree.git).

Retested on SabreSD and SabreAuto, still working as before.

Steve

