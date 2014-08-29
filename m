Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-167.synserver.de ([212.40.185.167]:1288 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaH2QT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 12:19:57 -0400
Message-ID: <5400A106.6060004@metafoo.de>
Date: Fri, 29 Aug 2014 17:49:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-i2c@vger.kernel.org
CC: w.sang@pengutronix.de, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, mark.rutland@arm.com
Subject: Re: [PATCH v2 2/2] adv7604: Use DT parsing in dummy creation
References: <1409325303-15906-1-git-send-email-jean-michel.hautbois@vodalys.com> <1409325303-15906-2-git-send-email-jean-michel.hautbois@vodalys.com>
In-Reply-To: <1409325303-15906-2-git-send-email-jean-michel.hautbois@vodalys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2014 05:15 PM, Jean-Michel Hautbois wrote:
> This patch uses DT in order to parse addresses for dummy devices of adv7604.
> The ADV7604 has thirteen 256-byte maps that can be accessed via the main
> I²C ports. Each map has it own I²C address and acts
> as a standard slave device on the I²C bus.
>
> If nothing is defined, it uses default addresses.
> The main prupose is using two adv76xx on the same i2c bus.

Ideally this patch is split up in two patches. One patch adding support for 
i2c_new_secondary_device() and one patch adding support for DT for the adv7604.

[...]
> +static const char const *adv7604_secondary_names[] = {
> +	"main", /* ADV7604_PAGE_IO */

How about [ADV7604_PAGE_IO] = "main", instead of having the comment, this 
makes things more explicit.

> +	"avlink", /* ADV7604_PAGE_AVLINK */
> +	"cec", /* ADV7604_PAGE_CEC */
> +	"infoframe", /* ADV7604_PAGE_INFOFRAME */
> +	"esdp", /* ADV7604_PAGE_ESDP */
> +	"dpp", /* ADV7604_PAGE_DPP */
> +	"afe", /* ADV7604_PAGE_AFE */
> +	"rep", /* ADV7604_PAGE_REP */
> +	"edid", /* ADV7604_PAGE_EDID */
> +	"hdmi", /* ADV7604_PAGE_HDMI */
> +	"test", /* ADV7604_PAGE_TEST */
> +	"cp", /* ADV7604_PAGE_CP */
> +	"vdp" /* ADV7604_PAGE_VDP */
> +};
> +
>   /* ----------------------------------------------------------------------- */
>
>   static inline struct adv7604_state *to_state(struct v4l2_subdev *sd)
> @@ -2528,13 +2544,31 @@ static void adv7604_unregister_clients(struct adv7604_state *state)
>   }
>
>   static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
> -							u8 addr, u8 io_reg)
> +						unsigned int i)
>   {
>   	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct adv7604_platform_data *pdata = client->dev.platform_data;
> +	unsigned int io_reg = 0xf2 + i;
> +	unsigned int default_addr = io_read(sd, io_reg) >> 1;
> +	struct i2c_client *new_client;
> +
> +	if (IS_ENABLED(CONFIG_OF)) {

No CONFIG_OF. i2c_new_secondary_device() is supposed to be the generic 
method of instantiating the secondary i2c_client, regardless of how the 
address is specified. For this driver we still need to keep the old method 
of instantiation via platform data for legacy reasons for now. So what this 
should look like is:


	if (pdata && pdata->i2c_addresses[i])
		new_client = i2c_new_dummy(client->adapter,
			pdata->i2c_addresses[i]);	
	else
		new_client = i2c_new_secondary_device(client,
			adv7604_secondary_names[i], default_addr);


> +		/* Try to find it in DT */
> +		new_client = i2c_new_secondary_device(client,
> +			adv7604_secondary_names[i], default_addr);
> +	} else if (pdata) {
> +		if (pdata->i2c_addresses[i])
> +			new_client = i2c_new_dummy(client->adapter,
> +						pdata->i2c_addresses[i]);
> +		else
> +			new_client = i2c_new_dummy(client->adapter,
> +						default_addr);
> +	}
>
[...]
