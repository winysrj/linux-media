Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39162 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbAPO0G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 09:26:06 -0500
Message-ID: <54B91F7B.6050101@iki.fi>
Date: Fri, 16 Jan 2015 16:26:03 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] si2168: add support for 1.7MHz bandwidth
References: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi> <1421411720-2364-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1421411720-2364-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/16/2015 02:35 PM, Olli Salonen wrote:
> This patch is based on Antti's silabs branch.
>
> Add support for 1.7 MHz bandwidth. Supported in all versions of Si2168 according to short data sheets.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

How about tuner driver filters? Having too wide channel filters reduces 
some performance, but it still works. It could be even possible 5MHz is 
smallest filter tuner supports...

regards
Antti

> ---
>   drivers/media/dvb-frontends/si2168.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7fef5ab..ec893ee 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -185,6 +185,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>   		dev_err(&client->dev, "automatic bandwidth not supported");
>   		goto err;
>   	}
> +	else if (c->bandwidth_hz <= 2000000)
> +		bandwidth = 0x02;
>   	else if (c->bandwidth_hz <= 5000000)
>   		bandwidth = 0x05;
>   	else if (c->bandwidth_hz <= 6000000)
>

-- 
http://palosaari.fi/
