Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46587 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbcLIRnP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 12:43:15 -0500
Subject: Re: [PATCH 2/4] si2168: Si2168-D60 support.
To: CrazyCat <crazycat69@narod.ru>, linux-media@vger.kernel.org
References: <3148066.V8NoLtYRlU@computer>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <d1aec9c2-c42d-5e70-7944-cc54e137e770@iki.fi>
Date: Fri, 9 Dec 2016 19:43:12 +0200
MIME-Version: 1.0
In-Reply-To: <3148066.V8NoLtYRlU@computer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2016 02:17 AM, CrazyCat wrote:
> Support for new demod version.
>
> Signed-off-by: CrazyCat <crazycat69@narod.ru>

Patch is correct. Could you still use your real name?

regards
Antti

> ---
>  drivers/media/dvb-frontends/si2168.c      | 4 ++++
>  drivers/media/dvb-frontends/si2168_priv.h | 2 ++
>  2 files changed, 6 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 20b4a65..28f3bbe 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -674,6 +674,9 @@ static int si2168_probe(struct i2c_client *client,
>  	case SI2168_CHIP_ID_B40:
>  		dev->firmware_name = SI2168_B40_FIRMWARE;
>  		break;
> +	case SI2168_CHIP_ID_D60:
> +		dev->firmware_name = SI2168_D60_FIRMWARE;
> +		break;
>  	default:
>  		dev_dbg(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
>  			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
> @@ -761,3 +764,4 @@ static int si2168_remove(struct i2c_client *client)
>  MODULE_FIRMWARE(SI2168_A20_FIRMWARE);
>  MODULE_FIRMWARE(SI2168_A30_FIRMWARE);
>  MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
> +MODULE_FIRMWARE(SI2168_D60_FIRMWARE);
> diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
> index 7843ccb..4baa95b 100644
> --- a/drivers/media/dvb-frontends/si2168_priv.h
> +++ b/drivers/media/dvb-frontends/si2168_priv.h
> @@ -25,6 +25,7 @@
>  #define SI2168_A20_FIRMWARE "dvb-demod-si2168-a20-01.fw"
>  #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
>  #define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
> +#define SI2168_D60_FIRMWARE "dvb-demod-si2168-d60-01.fw"
>  #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
>
>  /* state struct */
> @@ -37,6 +38,7 @@ struct si2168_dev {
>  	#define SI2168_CHIP_ID_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
>  	#define SI2168_CHIP_ID_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
>  	#define SI2168_CHIP_ID_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
> +	#define SI2168_CHIP_ID_D60 ('D' << 24 | 68 << 16 | '6' << 8 | '0' << 0)
>  	unsigned int chip_id;
>  	unsigned int version;
>  	const char *firmware_name;
>

-- 
http://palosaari.fi/
