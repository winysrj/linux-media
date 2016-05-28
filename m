Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39466 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbcE1KLF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2016 06:11:05 -0400
Subject: Re: ascot2e.c off by one bug
To: Saso Slavicic <saso.linux@astim.si>, linux-media@vger.kernel.org
References: <000f01d1b8c3$54af4080$fe0dc180$@astim.si>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <424b5c9e-2019-76cc-5f2e-e68e43cfd6f8@iki.fi>
Date: Sat, 28 May 2016 13:11:02 +0300
MIME-Version: 1.0
In-Reply-To: <000f01d1b8c3$54af4080$fe0dc180$@astim.si>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to regmap at the same (just a hint...)

On 05/28/2016 12:28 PM, Saso Slavicic wrote:
> Hi,
>
> Tuning a card with Sony ASCOT2E produces the following error:
>
> 	kernel: i2c i2c-9: wr reg=0006: len=11 is too big!
>
> MAX_WRITE_REGSIZE is defined as 10, buf[MAX_WRITE_REGSIZE + 1] buffer is
> used in ascot2e_write_regs().
>
> The problem is that exactly 10 bytes are written in ascot2e_set_params():
>
> 	/* Set BW_OFFSET (0x0F) value from parameter table */
> 	data[9] = ascot2e_sett[tv_system].bw_offset;
> 	ascot2e_write_regs(priv, 0x06, data, 10);
>
> The test in write_regs is as follows:
>
> 	if (len + 1 >= sizeof(buf))
>
> 10 + 1 = 11 and that would be exactly the size of buf. Since 10 bytes +
> buf[0] = reg would seem to fit into buf[], this shouldn't be an error.
>
> The following patch fixes the problem for me, I have tested the card and it
> seems to be working fine.
>
> ---
>  drivers/media/dvb-frontends/ascot2e.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/ascot2e.c
> b/drivers/media/dvb-frontends/ascot2e.c
> --- a/drivers/media/dvb-frontends/ascot2e.c
> +++ b/drivers/media/dvb-frontends/ascot2e.c
> @@ -132,7 +132,7 @@ static int ascot2e_write_regs(struct ascot2e_priv *priv,
>  		}
>  	};
>
> -	if (len + 1 >= sizeof(buf)) {
> +	if (len + 1 > sizeof(buf)) {
>  		dev_warn(&priv->i2c->dev,"wr reg=%04x: len=%d is too
> big!\n",
>  			 reg, len + 1);
>  		return -E2BIG;
>
> Regards,
> Saso Slavicic
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
