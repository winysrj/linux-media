Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48088 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbaGMROd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jul 2014 13:14:33 -0400
Message-ID: <53C2BE77.8090003@iki.fi>
Date: Sun, 13 Jul 2014 20:14:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] si2168: Small typo fix (SI2157 -> SI2168)
References: <1405259542-32529-1-git-send-email-olli.salonen@iki.fi> <1405259542-32529-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1405259542-32529-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied!
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=silabs

Antti


On 07/13/2014 04:52 PM, Olli Salonen wrote:
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-frontends/si2168_priv.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
> index 53f7f06..97f9d87 100644
> --- a/drivers/media/dvb-frontends/si2168_priv.h
> +++ b/drivers/media/dvb-frontends/si2168_priv.h
> @@ -36,9 +36,9 @@ struct si2168 {
>   };
>
>   /* firmare command struct */
> -#define SI2157_ARGLEN      30
> +#define SI2168_ARGLEN      30
>   struct si2168_cmd {
> -	u8 args[SI2157_ARGLEN];
> +	u8 args[SI2168_ARGLEN];
>   	unsigned wlen;
>   	unsigned rlen;
>   };
>

-- 
http://palosaari.fi/
