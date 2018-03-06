Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18266 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753507AbeCFN5B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 08:57:01 -0500
Date: Tue, 6 Mar 2018 15:56:58 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Todor Tomov <todor.tomov@linaro.org>, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: ov5645: Fix write_reg return code
Message-ID: <20180306135658.dh5vlmsevodrcr7m@paasikivi.fi.intel.com>
References: <1518082920-11309-1-git-send-email-todor.tomov@linaro.org>
 <20180306104010.234737a6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306104010.234737a6@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Mauro,

On Tue, Mar 06, 2018 at 10:40:10AM -0300, Mauro Carvalho Chehab wrote:
> Em Thu,  8 Feb 2018 11:41:59 +0200
> Todor Tomov <todor.tomov@linaro.org> escreveu:
> 
> > I2C transfer functions return number of successful operations (on success).
> > 
> > Do not return the received positive return code but instead return 0 on
> > success. The users of write_reg function already use this logic.
> > 
> > Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> > ---
> >  drivers/media/i2c/ov5645.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> > index d28845f..9755562 100644
> > --- a/drivers/media/i2c/ov5645.c
> > +++ b/drivers/media/i2c/ov5645.c
> > @@ -600,11 +600,13 @@ static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
> >  	regbuf[2] = val;
> >  
> >  	ret = i2c_master_send(ov5645->i2c_client, regbuf, 3);
> > -	if (ret < 0)
> > +	if (ret < 0) {
> >  		dev_err(ov5645->dev, "%s: write reg error %d: reg=%x, val=%x\n",
> >  			__func__, ret, reg, val);
> > +		return ret;
> > +	}
> 
> Actually, if ret < 3, it should return an error too (like -EREMOTEIO 
> or -EIO).

i2c_master_send() always returns a negative error code or the number of
octets written.

But thank you for reminding me about the patch. :-)

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
