Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41999 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaJAT5W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 15:57:22 -0400
Message-ID: <542C5CA0.9020204@iki.fi>
Date: Wed, 01 Oct 2014 22:57:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/5] sp2: fix incorrect struct
References: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi> <1411976660-19329-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411976660-19329-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 09/29/2014 10:44 AM, Olli Salonen wrote:
> Incorrect struct used in the SP2 driver.
>
> Reported-by: Max Nibble <nibble.max@gmail.com>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-frontends/sp2.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
> index 9b684d5..1f4f250 100644
> --- a/drivers/media/dvb-frontends/sp2.c
> +++ b/drivers/media/dvb-frontends/sp2.c
> @@ -407,7 +407,7 @@ err:
>
>   static int sp2_remove(struct i2c_client *client)
>   {
> -	struct si2157 *s = i2c_get_clientdata(client);
> +	struct sp2 *s = i2c_get_clientdata(client);
>
>   	dev_dbg(&client->dev, "\n");
>
>

-- 
http://palosaari.fi/
