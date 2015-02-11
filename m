Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56564 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbbBKNHL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 08:07:11 -0500
Message-ID: <54DB53F9.9070704@iki.fi>
Date: Wed, 11 Feb 2015 15:07:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis de Bethencourt <luis@debethencourt.com>,
	linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, crop@iki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtl2832: remove compiler warning
References: <20150211110851.GA30505@biggie>
In-Reply-To: <20150211110851.GA30505@biggie>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/2015 01:08 PM, Luis de Bethencourt wrote:
> Cleaning up the following compiler warning:
> rtl2832.c:703:12: warning: 'tmp' may be used uninitialized in this function
>
> Even though it could never happen since if rtl2832_rd_demod_reg () doesn't set
> tmp, this line would never run because we go to err. It is still nice to avoid
> compiler warnings.
>
> Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>


Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

> ---
>   drivers/media/dvb-frontends/rtl2832.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index 5d2d8f4..20fa245 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -685,7 +685,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   	struct rtl2832_dev *dev = fe->demodulator_priv;
>   	struct i2c_client *client = dev->client;
>   	int ret;
> -	u32 tmp;
> +	u32 uninitialized_var(tmp);
>
>   	dev_dbg(&client->dev, "\n");
>
>

-- 
http://palosaari.fi/
