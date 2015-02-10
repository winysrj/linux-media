Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53607 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbBJK5a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 05:57:30 -0500
Message-ID: <54D9E414.7040003@iki.fi>
Date: Tue, 10 Feb 2015 12:57:24 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis de Bethencourt <luis@debethencourt.com>,
	linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl2832: remove compiler warning
References: <20150208224422.GA22749@turing>
In-Reply-To: <20150208224422.GA22749@turing>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2015 12:44 AM, Luis de Bethencourt wrote:
> Cleaning the following compiler warning:
> rtl2832.c:703:12: warning: 'tmp' may be used uninitialized in this function
>
> Even though it could never happen since if rtl2832_rd_demod_reg () doesn't set
> tmp, this line would never run because we go to err. It is still nice to avoid
> compiler warnings.
>
> Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
> ---
>   drivers/media/dvb-frontends/rtl2832.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index 5d2d8f4..ad36d1c 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -685,7 +685,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   	struct rtl2832_dev *dev = fe->demodulator_priv;
>   	struct i2c_client *client = dev->client;
>   	int ret;
> -	u32 tmp;
> +	u32 tmp = 0;
>
>   	dev_dbg(&client->dev, "\n");

I looked the code and I cannot see how it could used as uninitialized. 
Dunno how it could be fixed properly.

Also, I think idiom to say compiler that variable could be uninitialized 
is to store its own value. But I am fine with zero initialization too.

u32 tmp = tmp;

regards
Antti

-- 
http://palosaari.fi/
