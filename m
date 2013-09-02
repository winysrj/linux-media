Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59133 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630Ab3IBQ1F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Sep 2013 12:27:05 -0400
Message-ID: <5224BC2D.2040909@iki.fi>
Date: Mon, 02 Sep 2013 19:26:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org, Jacek Konieczny <jajcus@jajcus.net>,
	Torsten Seyffarth <t.seyffarth@gmx.de>,
	Jan Taegert <jantaegert@gmx.net>,
	Damien CABROL <cabrol.damien@free.fr>
Subject: Re: [PATCH] e4000: fix PLL calc error in 32-bit arch
References: <1378138669-22302-1-git-send-email-crope@iki.fi>
In-Reply-To: <1378138669-22302-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Testers?

Here is tree:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/e4000_fix_3.11

I assume all of you have been running 32-bit arch as that bug is related 
to 32-bit overflow.

regards
Antti


On 09/02/2013 07:17 PM, Antti Palosaari wrote:
> Fix long-lasting error that causes tuning failure to some frequencies
> on 32-bit arch.
>
> Special thanks goes to Damien CABROL who finally find root of the bug.
> Also big thanks to Jacek Konieczny for donating non-working device.
>
> Reported-by: Jacek Konieczny <jajcus@jajcus.net>
> Reported-by: Torsten Seyffarth <t.seyffarth@gmx.de>
> Reported-by: Jan Taegert <jantaegert@gmx.net>
> Reported-by: Damien CABROL <cabrol.damien@free.fr>
> Tested-by: Damien CABROL <cabrol.damien@free.fr>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/tuners/e4000.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> index 1b33ed3..a88f757 100644
> --- a/drivers/media/tuners/e4000.c
> +++ b/drivers/media/tuners/e4000.c
> @@ -232,7 +232,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
>   	 * or more.
>   	 */
>   	f_VCO = c->frequency * e4000_pll_lut[i].mul;
> -	sigma_delta = 0x10000UL * (f_VCO % priv->cfg->clock) / priv->cfg->clock;
> +	sigma_delta = div_u64(0x10000ULL * (f_VCO % priv->cfg->clock), priv->cfg->clock);
>   	buf[0] = f_VCO / priv->cfg->clock;
>   	buf[1] = (sigma_delta >> 0) & 0xff;
>   	buf[2] = (sigma_delta >> 8) & 0xff;
>


-- 
http://palosaari.fi/
