Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53294 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2KEVLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 16:11:08 -0500
Message-ID: <50982B4E.8000609@iki.fi>
Date: Mon, 05 Nov 2012 23:10:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 56/68] [media] tua9001: fix a warning
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com> <1351370486-29040-57-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-57-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/27/2012 11:41 PM, Mauro Carvalho Chehab wrote:
> drivers/media/tuners/tua9001.c:211:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
>
> Cc: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>   drivers/media/tuners/tua9001.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
> index 3896684..83a6240 100644
> --- a/drivers/media/tuners/tua9001.c
> +++ b/drivers/media/tuners/tua9001.c
> @@ -136,7 +136,7 @@ static int tua9001_set_params(struct dvb_frontend *fe)
>   {
>   	struct tua9001_priv *priv = fe->tuner_priv;
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	int ret, i;
> +	int ret = 0, i;
>   	u16 val;
>   	u32 frequency;
>   	struct reg_val data[2];
>

I cannot see any condition ret could be used as uninitialized. I looked 
myself that warning earlier too.

Anyway, I am fine with it.

Acked-by: Antti Palosaari <crope@iki.fi>

Antti
-- 
http://palosaari.fi/
