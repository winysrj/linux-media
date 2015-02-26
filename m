Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56391 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbbBZLvW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 06:51:22 -0500
Message-ID: <54EF08B5.8030602@iki.fi>
Date: Thu, 26 Feb 2015 13:51:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Yannick Guerrini <yguerrini@tomshardware.fr>
CC: mchehab@osg.samsung.com, trivial@kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] si2168: tda10071: m88ds3103: Fix trivial typos
References: <1424945586-8232-1-git-send-email-yguerrini@tomshardware.fr>
In-Reply-To: <1424945586-8232-1-git-send-email-yguerrini@tomshardware.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2015 12:13 PM, Yannick Guerrini wrote:
> Change 'firmare' to 'firmware'
>
> Signed-off-by: Yannick Guerrini <yguerrini@tomshardware.fr>

Acked-by: Antti Palosaari <crope@iki.fi>

Antti

> ---
>   drivers/media/dvb-frontends/m88ds3103.c     | 2 +-
>   drivers/media/dvb-frontends/si2168_priv.h   | 2 +-
>   drivers/media/dvb-frontends/tda10071_priv.h | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
> index ba4ee0b..d3d928e 100644
> --- a/drivers/media/dvb-frontends/m88ds3103.c
> +++ b/drivers/media/dvb-frontends/m88ds3103.c
> @@ -630,7 +630,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
>   	/* request the firmware, this will block and timeout */
>   	ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
>   	if (ret) {
> -		dev_err(&priv->i2c->dev, "%s: firmare file '%s' not found\n",
> +		dev_err(&priv->i2c->dev, "%s: firmware file '%s' not found\n",
>   				KBUILD_MODNAME, fw_file);
>   		goto err;
>   	}
> diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
> index aadd136..d7efce8 100644
> --- a/drivers/media/dvb-frontends/si2168_priv.h
> +++ b/drivers/media/dvb-frontends/si2168_priv.h
> @@ -40,7 +40,7 @@ struct si2168_dev {
>   	bool ts_clock_inv;
>   };
>
> -/* firmare command struct */
> +/* firmware command struct */
>   #define SI2168_ARGLEN      30
>   struct si2168_cmd {
>   	u8 args[SI2168_ARGLEN];
> diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
> index 4204861..03f839c 100644
> --- a/drivers/media/dvb-frontends/tda10071_priv.h
> +++ b/drivers/media/dvb-frontends/tda10071_priv.h
> @@ -99,7 +99,7 @@ struct tda10071_reg_val_mask {
>   #define CMD_BER_CONTROL         0x3e
>   #define CMD_BER_UPDATE_COUNTERS 0x3f
>
> -/* firmare command struct */
> +/* firmware command struct */
>   #define TDA10071_ARGLEN      30
>   struct tda10071_cmd {
>   	u8 args[TDA10071_ARGLEN];
>

-- 
http://palosaari.fi/
