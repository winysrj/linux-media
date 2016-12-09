Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52483 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753440AbcLILRl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 06:17:41 -0500
Subject: Re: [PATCH 3/4] si2157: Si2141/2151 tuner support.
To: CrazyCat <crazycat69@narod.ru>, linux-media@vger.kernel.org
References: <2233965.zV8xNtq62S@computer>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <e546df7c-e0b1-0933-2f2c-dca875726749@iki.fi>
Date: Fri, 9 Dec 2016 13:17:37 +0200
MIME-Version: 1.0
In-Reply-To: <2233965.zV8xNtq62S@computer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/09/2016 02:19 AM, CrazyCat wrote:
> Support for new tuner version.
>
> Signed-off-by: CrazyCat <crazycat69@narod.ru>
> ---
>  drivers/media/tuners/si2157.c      | 71 ++++++++++++++++++++++++++++++++++----
>  drivers/media/tuners/si2157_priv.h |  2 ++
>  2 files changed, 67 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 57b2508..69fd21e 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -1,5 +1,5 @@
>  /*
> - * Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver
> + * Silicon Labs Si2141/2146/2147/2148/2151/2157/2158 silicon tuner driver
>   *
>   * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>   *
> @@ -84,7 +84,7 @@ static int si2157_init(struct dvb_frontend *fe)
>  	struct si2157_cmd cmd;
>  	const struct firmware *fw;
>  	const char *fw_name;
> -	unsigned int uitmp, chip_id;
> +	unsigned int uitmp, chip_id, count;
>
>  	dev_dbg(&client->dev, "\n");
>
> @@ -102,14 +102,46 @@ static int si2157_init(struct dvb_frontend *fe)
>  	if (uitmp == dev->if_frequency / 1000)
>  		goto warm;
>
> +	if (dev->chiptype == SI2157_CHIPTYPE_SI2141) {
> +		count = 0;
> +		do {
> +			if (count > 10)
> +				goto err;
> +
> +			/* reset */
> +			memcpy(cmd.args, "\xc0\x05\x00\x00", 4);
> +			cmd.wlen = 4;
> +			cmd.rlen = 1;
> +			ret = si2157_cmd_execute(client, &cmd);
> +			if (ret)
> +				goto err;
> +
> +			memcpy(cmd.args, "\xc0\x00\x0d\x0e\x00\x01\x01\x01\x01\x03", 10);
> +			cmd.wlen = 10;
> +			cmd.rlen = 1;
> +			ret = si2157_cmd_execute(client, &cmd);
> +			if (ret)
> +				goto err;
> +			count++;
> +		} while (cmd.args[0] == 0xfe);
> +		dev_info(&client->dev, "Si2141/2151 reset attempts %d\n", count);
> +	}

Without any comment or description you added this kind of hackish 
looking thing? What it is, why it is needed, what happens without it?

Also, it is just N-times loop with exit condition => you should use 
typical for-looping with break as usual.


> +
>  	/* power up */
> -	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
> +	switch (dev->chiptype) {
> +	case SI2157_CHIPTYPE_SI2146:
>  		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
>  		cmd.wlen = 9;
> -	} else {
> +		break;
> +	case SI2157_CHIPTYPE_SI2141:
> +		memcpy(cmd.args, "\xc0\x08\x01\x02\x00\x08\x01", 7);
> +		cmd.wlen = 7;
> +		break;
> +	default:
>  		memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
>  		cmd.wlen = 15;
>  	}
> +
>  	cmd.rlen = 1;
>  	ret = si2157_cmd_execute(client, &cmd);
>  	if (ret)
> @@ -131,6 +163,8 @@ static int si2157_init(struct dvb_frontend *fe)
>  	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
>  	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
>  	#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
> +	#define SI2141_A10 ('A' << 24 | 41 << 16 | '1' << 8 | '0' << 0)
> +	#define SI2151_A10 ('A' << 24 | 51 << 16 | '1' << 8 | '0' << 0)
>
>  	switch (chip_id) {
>  	case SI2158_A20:
> @@ -142,6 +176,10 @@ static int si2157_init(struct dvb_frontend *fe)
>  	case SI2146_A10:
>  		fw_name = NULL;
>  		break;
> +	case SI2141_A10:
> +	case SI2151_A10:
> +		fw_name = SI2141_A10_FIRMWARE;
> +		break;
>  	default:
>  		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
>  				cmd.args[2], cmd.args[1],
> @@ -214,6 +252,23 @@ static int si2157_init(struct dvb_frontend *fe)
>
>  	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
>  			cmd.args[6], cmd.args[7], cmd.args[8]);
> +
> +	if (dev->chiptype == SI2157_CHIPTYPE_SI2141) {
> +		/* set clock */
> +		memcpy(cmd.args, "\xc0\x00\x0d", 3);
> +		cmd.wlen = 3;
> +		cmd.rlen = 1;
> +		ret = si2157_cmd_execute(client, &cmd);
> +		if (ret)
> +			goto err;
> +		/* setup PIN */
> +		memcpy(cmd.args, "\x12\x80\x80\x85\x00\x81\x00", 7);
> +		cmd.wlen = 7;
> +		cmd.rlen = 7;
> +		ret = si2157_cmd_execute(client, &cmd);
> +		if (ret)
> +			goto err;
> +	}

These are also without almost any comment... First one seems to enable 
clock output and second one is GPIO? Tuner clock output is to feed clock 
for demod most likely. You do that same on init. Why?

You should implement kernel gpio and probably kernel common clock in 
order to fix those correctly.



>  warm:
>  	/* init statistics in order signal app which are supported */
>  	c->strength.len = 1;
> @@ -471,7 +526,8 @@ static int si2157_probe(struct i2c_client *client,
>  #endif
>
>  	dev_info(&client->dev, "Silicon Labs %s successfully attached\n",
> -			dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
> +			dev->chiptype == SI2157_CHIPTYPE_SI2141 ?
> +			"Si2141/2151" : dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
>  			"Si2146" : "Si2147/2148/2157/2158");
>
>  	return 0;
> @@ -508,6 +564,8 @@ static int si2157_remove(struct i2c_client *client)
>  static const struct i2c_device_id si2157_id_table[] = {
>  	{"si2157", SI2157_CHIPTYPE_SI2157},
>  	{"si2146", SI2157_CHIPTYPE_SI2146},
> +	{"si2141", SI2157_CHIPTYPE_SI2141},
> +	{"si2151", SI2157_CHIPTYPE_SI2141},
>  	{}
>  };
>  MODULE_DEVICE_TABLE(i2c, si2157_id_table);
> @@ -524,7 +582,8 @@ static int si2157_remove(struct i2c_client *client)
>
>  module_i2c_driver(si2157_driver);
>
> -MODULE_DESCRIPTION("Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver");
> +MODULE_DESCRIPTION("Silicon Labs Si2141/2146/2147/2148/2151/2157/2158 silicon tuner driver");
>  MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>  MODULE_LICENSE("GPL");
>  MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
> +MODULE_FIRMWARE(SI2141_A10_FIRMWARE);
> diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
> index d6b2c7b..e6436f7 100644
> --- a/drivers/media/tuners/si2157_priv.h
> +++ b/drivers/media/tuners/si2157_priv.h
> @@ -42,6 +42,7 @@ struct si2157_dev {
>
>  #define SI2157_CHIPTYPE_SI2157 0
>  #define SI2157_CHIPTYPE_SI2146 1
> +#define SI2157_CHIPTYPE_SI2141 2
>
>  /* firmware command struct */
>  #define SI2157_ARGLEN      30
> @@ -52,5 +53,6 @@ struct si2157_cmd {
>  };
>
>  #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
> +#define SI2141_A10_FIRMWARE "dvb-tuner-si2141-a10-01.fw"
>
>  #endif
>

-- 
http://palosaari.fi/
