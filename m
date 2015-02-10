Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61815 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbbBJOHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 09:07:35 -0500
Date: Tue, 10 Feb 2015 14:05:33 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl2832: remove compiler warning
Message-ID: <20150210140533.GA10472@biggie>
References: <20150208224422.GA22749@turing>
 <54D9E414.7040003@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54D9E414.7040003@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 10, 2015 at 12:57:24PM +0200, Antti Palosaari wrote:
> On 02/09/2015 12:44 AM, Luis de Bethencourt wrote:
> >Cleaning the following compiler warning:
> >rtl2832.c:703:12: warning: 'tmp' may be used uninitialized in this function
> >
> >Even though it could never happen since if rtl2832_rd_demod_reg () doesn't set
> >tmp, this line would never run because we go to err. It is still nice to avoid
> >compiler warnings.
> >
> >Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
> >---
> >  drivers/media/dvb-frontends/rtl2832.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> >index 5d2d8f4..ad36d1c 100644
> >--- a/drivers/media/dvb-frontends/rtl2832.c
> >+++ b/drivers/media/dvb-frontends/rtl2832.c
> >@@ -685,7 +685,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
> >  	struct rtl2832_dev *dev = fe->demodulator_priv;
> >  	struct i2c_client *client = dev->client;
> >  	int ret;
> >-	u32 tmp;
> >+	u32 tmp = 0;
> >
> >  	dev_dbg(&client->dev, "\n");
> 
> I looked the code and I cannot see how it could used as uninitialized. Dunno
> how it could be fixed properly.

Hi Antti,

I agree. If rtl2832_rd_demod_reg() in line 696 doesn't set tmp it is because
it has errored out. Which means rtl2832_read_status() itself will goto err
before the check for 'if (tmp == 11)' line that generates the warning.

I mentioned this in my commit message :)

> 
> Also, I think idiom to say compiler that variable could be uninitialized is
> to store its own value. But I am fine with zero initialization too.
> 
> u32 tmp = tmp;
> 
> regards
> Antti
> 
> -- 
> http://palosaari.fi/

If you prefer I use the 'u32 tmp = tmp;' I am happy to change my patch.
You say you are fine with zero initialization too, but I prefer offering
whatever you think is best.

Thanks for taking the time to look at this,
Luis
