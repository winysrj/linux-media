Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61943 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbbBOWqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 17:46:36 -0500
Date: Sun, 15 Feb 2015 22:46:33 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: mchehab@osg.samsung.com
Cc: crop@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] rtl2832: remove compiler warning
Message-ID: <20150215224633.GA3015@turing>
References: <20150211110851.GA30505@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150211110851.GA30505@biggie>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 11, 2015 at 11:08:51AM +0000, Luis de Bethencourt wrote:
> Cleaning up the following compiler warning:
> rtl2832.c:703:12: warning: 'tmp' may be used uninitialized in this function
> 
> Even though it could never happen since if rtl2832_rd_demod_reg () doesn't set
> tmp, this line would never run because we go to err. It is still nice to avoid
> compiler warnings.
> 
> Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
> ---
>  drivers/media/dvb-frontends/rtl2832.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index 5d2d8f4..20fa245 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -685,7 +685,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
>  	struct rtl2832_dev *dev = fe->demodulator_priv;
>  	struct i2c_client *client = dev->client;
>  	int ret;
> -	u32 tmp;
> +	u32 uninitialized_var(tmp);
>  
>  	dev_dbg(&client->dev, "\n");
>  
> -- 
> 2.1.3
> 

Hi Mauro,

The warning is still happening. Just a reminder in case you want to apply this
patch.

Thanks,
Luis
