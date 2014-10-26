Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33259 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaJZMPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 08:15:47 -0400
Message-ID: <544CE5F1.3040601@iki.fi>
Date: Sun, 26 Oct 2014 14:15:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH] dvb:tc90522: bugfix of always-false expression
References: <1414325129-16570-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414325129-16570-1-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/26/2014 02:05 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
>
> Reported by David Binderman

^^ See Documentation/SubmittingPatches

Antti

> ---
>   drivers/media/dvb-frontends/tc90522.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
> index d9905fb..bca81ef 100644
> --- a/drivers/media/dvb-frontends/tc90522.c
> +++ b/drivers/media/dvb-frontends/tc90522.c
> @@ -363,7 +363,7 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
>   		u8 v;
>
>   		c->isdbt_partial_reception = val[0] & 0x01;
> -		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x01;
> +		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x40;
>
>   		/* layer A */
>   		v = (val[2] & 0x78) >> 3;
>

-- 
http://palosaari.fi/
