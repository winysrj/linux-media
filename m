Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43709 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2AIRhh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jan 2012 12:37:37 -0500
Message-ID: <4F0B25DD.1070900@iki.fi>
Date: Mon, 09 Jan 2012 19:37:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] af9013: Fix typo in get_frontend() function
References: <4F033F37.3030301@gmail.com>
In-Reply-To: <4F033F37.3030301@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Seems to be clear bug! Thanks.

Acked-by: Antti Palosaari <crope@iki.fi>


On 01/03/2012 07:47 PM, Gianluca Gennari wrote:
> This patch fixes an obvious typo in the get_frontend() function
> of the af9013 driver, recently rewritten by Antti Palosaari.
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/dvb/frontends/af9013.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/af9013.c
> b/drivers/media/dvb/frontends/af9013.c
> index e6ba3e0..2aedc0b 100644
> --- a/drivers/media/dvb/frontends/af9013.c
> +++ b/drivers/media/dvb/frontends/af9013.c
> @@ -880,16 +880,16 @@ static int af9013_get_frontend(struct dvb_frontend
> *fe)
>
>   	switch ((buf[0]>>  2)&  3) {
>   	case 0:
> -		c->transmission_mode = GUARD_INTERVAL_1_32;
> +		c->guard_interval = GUARD_INTERVAL_1_32;
>   		break;
>   	case 1:
> -		c->transmission_mode = GUARD_INTERVAL_1_16;
> +		c->guard_interval = GUARD_INTERVAL_1_16;
>   		break;
>   	case 2:
> -		c->transmission_mode = GUARD_INTERVAL_1_8;
> +		c->guard_interval = GUARD_INTERVAL_1_8;
>   		break;
>   	case 3:
> -		c->transmission_mode = GUARD_INTERVAL_1_4;
> +		c->guard_interval = GUARD_INTERVAL_1_4;
>   		break;
>   	}
>


-- 
http://palosaari.fi/
