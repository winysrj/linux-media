Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:32942 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTT6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 14:58:22 -0500
Received: by mail-la0-f46.google.com with SMTP id gd6so3106952lab.33
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 11:58:21 -0800 (PST)
Date: Thu, 20 Nov 2014 21:58:19 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: CrazyCat <crazycat69@narod.ru>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] si2168: TS clock inversion control.
In-Reply-To: <2586479.jPeNbxzlMS@computer>
Message-ID: <alpine.DEB.2.10.1411202157400.1388@dl160.lan>
References: <2586479.jPeNbxzlMS@computer>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

On Fri, 14 Nov 2014, CrazyCat wrote:

> TS clock polarity control implemented.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> ---
> drivers/media/dvb-frontends/si2168.c      | 7 +++++--
> drivers/media/dvb-frontends/si2168.h      | 4 ++++
> drivers/media/dvb-frontends/si2168_priv.h | 1 +
> 3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7bac748..16a347a 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -308,14 +308,16 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
> 	if (ret)
> 		goto err;
>
> -	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x18", 6);
> +	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x08", 6);
> +	cmd.args[5] |= s->ts_clock_inv ? 0x00 : 0x10;
> 	cmd.wlen = 6;
> 	cmd.rlen = 4;
> 	ret = si2168_cmd_execute(s, &cmd);
> 	if (ret)
> 		goto err;
>
> -	memcpy(cmd.args, "\x14\x00\x08\x10\xd7\x15", 6);
> +	memcpy(cmd.args, "\x14\x00\x08\x10\xd7\x05", 6);
> +	cmd.args[5] |= s->ts_clock_inv ? 0x00 : 0x10;
> 	cmd.wlen = 6;
> 	cmd.rlen = 4;
> 	ret = si2168_cmd_execute(s, &cmd);
> @@ -669,6 +671,7 @@ static int si2168_probe(struct i2c_client *client,
> 	*config->i2c_adapter = s->adapter;
> 	*config->fe = &s->fe;
> 	s->ts_mode = config->ts_mode;
> +	s->ts_clock_inv = config->ts_clock_inv;
> 	s->fw_loaded = false;
>
> 	i2c_set_clientdata(client, s);
> diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
> index e086d67..87bc121 100644
> --- a/drivers/media/dvb-frontends/si2168.h
> +++ b/drivers/media/dvb-frontends/si2168.h
> @@ -37,6 +37,10 @@ struct si2168_config {
>
> 	/* TS mode */
> 	u8 ts_mode;
> +
> +	/* TS clock inverted */
> +	bool ts_clock_inv;
> +
> };
>
> #define SI2168_TS_PARALLEL	0x06
> diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
> index 132df67..66ed675 100644
> --- a/drivers/media/dvb-frontends/si2168_priv.h
> +++ b/drivers/media/dvb-frontends/si2168_priv.h
> @@ -36,6 +36,7 @@ struct si2168 {
> 	fe_delivery_system_t delivery_system;
> 	fe_status_t fe_status;
> 	u8 ts_mode;
> +	bool ts_clock_inv;
> 	bool active;
> 	bool fw_loaded;
> };
> -- 
> 1.9.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
