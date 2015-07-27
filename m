Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-193.synserver.de ([212.40.185.193]:1051 "EHLO
	smtp-out-193.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbbG0MpV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 08:45:21 -0400
Message-ID: <55B627DC.2010106@metafoo.de>
Date: Mon, 27 Jul 2015 14:45:16 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] adv7604: Don't shift the I2C address
References: <1437999700-16511-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1437999700-16511-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc Hans and media mailing list

On 07/27/2015 02:21 PM, Mike Looijmans wrote:
> Messages like this are rather confusing:
>    adv7611 5-004c: not an adv7611 on address 0x98
> The driver shifts the I2C address left by one (0x98 = 4c << 1)
> probably to match the datasheet. But in all Linux drivers and
> software, I2C addresses are in 7-bit notation, so it's better
> to stick to that. Remove the "<<1" in a few places where it
> logs the I2C address.
>
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

Looks ok to me.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>



> ---
>   drivers/media/i2c/adv7604.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index aa396c3..b6ebb88 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2791,7 +2791,7 @@ static int adv76xx_probe(struct i2c_client *client,
>   	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>   		return -EIO;
>   	v4l_dbg(1, debug, client, "detecting adv76xx client on address 0x%x\n",
> -			client->addr << 1);
> +			client->addr);
>
>   	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
>   	if (!state) {
> @@ -2870,7 +2870,7 @@ static int adv76xx_probe(struct i2c_client *client,
>   		val = adv_smbus_read_byte_data_check(client, 0xfb, false);
>   		if (val != 0x68) {
>   			v4l2_info(sd, "not an adv7604 on address 0x%x\n",
> -					client->addr << 1);
> +					client->addr);
>   			return -ENODEV;
>   		}
>   	} else {
> @@ -2878,7 +2878,7 @@ static int adv76xx_probe(struct i2c_client *client,
>   		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
>   		if (val != 0x2051) {
>   			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
> -					client->addr << 1);
> +					client->addr);
>   			return -ENODEV;
>   		}
>   	}
> @@ -2973,7 +2973,7 @@ static int adv76xx_probe(struct i2c_client *client,
>   	if (err)
>   		goto err_entity;
>   	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
> -			client->addr << 1, client->adapter->name);
> +			client->addr, client->adapter->name);
>
>   	/* Request IRQ if available. */
>   	if (client->irq) {
>

