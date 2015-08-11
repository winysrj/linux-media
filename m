Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48516 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbbHKWqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 18:46:22 -0400
Subject: Re: [PATCH 2/3] [media] tda10071: use div_s64() when dividing a s64
 integer
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
 <7d0ddc91c854f1f42fd7165e259b3573f53c1d73.1439332733.git.mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55CA7B3B.3020304@iki.fi>
Date: Wed, 12 Aug 2015 01:46:19 +0300
MIME-Version: 1.0
In-Reply-To: <7d0ddc91c854f1f42fd7165e259b3573f53c1d73.1439332733.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2015 01:39 AM, Mauro Carvalho Chehab wrote:
> Otherwise, it will break on 32 bits archs.

Look good!

Antti

>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
> index ee6653124618..119d47596ac8 100644
> --- a/drivers/media/dvb-frontends/tda10071.c
> +++ b/drivers/media/dvb-frontends/tda10071.c
> @@ -527,7 +527,7 @@ static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>   	unsigned int uitmp;
>
>   	if (c->strength.stat[0].scale == FE_SCALE_DECIBEL) {
> -		uitmp = c->strength.stat[0].svalue / 1000 + 256;
> +		uitmp = div_s64(c->strength.stat[0].svalue, 1000) + 256;
>   		uitmp = clamp(uitmp, 181U, 236U); /* -75dBm - -20dBm */
>   		/* scale value to 0x0000-0xffff */
>   		*strength = (uitmp-181) * 0xffff / (236-181);
>

-- 
http://palosaari.fi/
