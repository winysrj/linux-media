Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39215 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab2IXLwh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:52:37 -0400
Message-ID: <5060496E.6090304@iki.fi>
Date: Mon, 24 Sep 2012 14:52:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 1/3] fc2580: define const as UL to silence a warning
References: <1348486638-31169-1-git-send-email-gennarone@gmail.com> <1348486638-31169-2-git-send-email-gennarone@gmail.com>
In-Reply-To: <1348486638-31169-2-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2012 02:37 PM, Gianluca Gennari wrote:
> fc2580.c: In function 'fc2580_set_params':
> fc2580.c:150: warning: this decimal constant is unsigned only in ISO C90
>
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/tuners/fc2580.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
> index afc0491..036e94b 100644
> --- a/drivers/media/tuners/fc2580.c
> +++ b/drivers/media/tuners/fc2580.c
> @@ -147,7 +147,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
>   	f_vco = c->frequency;
>   	f_vco *= fc2580_pll_lut[i].div;
>
> -	if (f_vco >= 2600000000)
> +	if (f_vco >= 2600000000UL)
>   		tmp_val = 0x0e | fc2580_pll_lut[i].band;
>   	else
>   		tmp_val = 0x06 | fc2580_pll_lut[i].band;
>


-- 
http://palosaari.fi/
