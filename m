Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49481 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab2IXLzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 07:55:24 -0400
Message-ID: <50604A17.5060108@iki.fi>
Date: Mon, 24 Sep 2012 14:55:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 2/3] fc2580: silence uninitialized variable warning
References: <1348486638-31169-1-git-send-email-gennarone@gmail.com> <1348486638-31169-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1348486638-31169-3-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2012 02:37 PM, Gianluca Gennari wrote:
> fc2580.c: In function 'fc2580_set_params':
> fc2580.c:118: warning: 'ret' may be used uninitialized in this function
>
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
> ---
>   drivers/media/tuners/fc2580.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
> index 036e94b..3ad68e9 100644
> --- a/drivers/media/tuners/fc2580.c
> +++ b/drivers/media/tuners/fc2580.c
> @@ -115,7 +115,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
>   {
>   	struct fc2580_priv *priv = fe->tuner_priv;
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	int ret, i;
> +	int ret=0, i;

Nack. This is Codingstyle violation. See rules around line 206 from 
Documentation/CodingStyle

That replace warning with Codingstyle mistake. Change it to meet 
CodingStyle and resend.


>   	unsigned int r_val, n_val, k_val, k_val_reg, f_ref;
>   	u8 tmp_val, r18_val;
>   	u64 f_vco;
>

Antti
-- 
http://palosaari.fi/
