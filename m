Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38125 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbERIgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 04:36:46 -0400
Received: by wicnf17 with SMTP id nf17so60585369wic.1
        for <linux-media@vger.kernel.org>; Mon, 18 May 2015 01:36:45 -0700 (PDT)
Message-ID: <5559A49A.2030105@gmail.com>
Date: Mon, 18 May 2015 09:36:42 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] m88ds3103: do not return error from get_frontend()
 when not ready
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On 18/05/15 06:08, Antti Palosaari wrote:
> Do not return error from get_frontend() when status is queried, but
> device is not ready. dvbv5-zap has habit to call that IOCTL before
> device is tuned and it also refuses to use DVBv5 statistic after
> that...

In the driver I'm working on I noticed that in dvb5-zap too. I also saw 
a timing issue if holding fe_status in the priv struct - fe_status will 
remain at FE_HAS_LOCK until read_status() spins around again and this 
can cause get_frontend to proceed when it probably shouldn't. The end 
result is this early call to get_frontend() overwrites the property 
cache before zap has sent it through to set_frontend() and tuning then 
fails.

Do we need to be fixing these issues at a driver level?


Jemma.


>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb-frontends/m88ds3103.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
> index d3d928e..03dceb5 100644
> --- a/drivers/media/dvb-frontends/m88ds3103.c
> +++ b/drivers/media/dvb-frontends/m88ds3103.c
> @@ -742,7 +742,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
>   	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
>   
>   	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
> -		ret = -EAGAIN;
> +		ret = 0;
>   		goto err;
>   	}
>   

