Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37074
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750955AbdHMTkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 15:40:49 -0400
Date: Sun, 13 Aug 2017 16:40:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jemma Denson <jdenson@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrick Boettcher <pb@linuxtv.org>
Subject: Re: [PATCH RFC] media: isl6421: add checks for current overflow
Message-ID: <20170813164040.37730317@vento.lan>
In-Reply-To: <24d5b36b-0ed5-f290-15a3-d291b10b6c39@gmail.com>
References: <06047fe2c30107f01f2484c9d72acfb5abeca158.1502625545.git.mchehab@s-opensource.com>
        <24d5b36b-0ed5-f290-15a3-d291b10b6c39@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Aug 2017 19:47:37 +0100
Jemma Denson <jdenson@gmail.com> escreveu:

> Hi Mauro,
> 
> Just tried this on my card - unfortunately the patch as is doesn't work.
> 
> On 13/08/17 13:10, Mauro Carvalho Chehab wrote:
> > This Kaffeine's BZ:
> > 	https://bugs.kde.org/show_bug.cgi?id=374693
> >
> > affects SkyStar S2 PCI DVB-S/S2 rev 3.3 device. It could be due to
> > a Kernel bug.
> >
> > While checking the Isil 6421, comparing with its manual, available at:
> >
> > 	http://www.intersil.com/content/dam/Intersil/documents/isl6/isl6421a.pdf
> >
> > It was noticed that, if the output load is highly capacitive, a different approach
> > is recomended when energizing the LNBf.
> >
> > Also, it is possible to detect if a current overload is happening, by checking an
> > special flag.
> >
> > Add support for it.
> >
> > Compile-tested only.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >   drivers/media/dvb-frontends/isl6421.c | 72 +++++++++++++++++++++++++++++++++--
> >   1 file changed, 68 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/dvb-frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
> > index 838b42771a05..47a7e559cef2 100644
> > --- a/drivers/media/dvb-frontends/isl6421.c
> > +++ b/drivers/media/dvb-frontends/isl6421.c
> > @@ -38,25 +38,43 @@ struct isl6421 {
> >   	u8			override_and;
> >   	struct i2c_adapter	*i2c;
> >   	u8			i2c_addr;
> > +	bool			is_off;
> >   };
> >   
> >   static int isl6421_set_voltage(struct dvb_frontend *fe,
> >   			       enum fe_sec_voltage voltage)
> >   {
> > +	int ret;
> > +	u8 buf;
> > +	bool is_off;
> >   	struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
> > -	struct i2c_msg msg = {	.addr = isl6421->i2c_addr, .flags = 0,
> > -				.buf = &isl6421->config,
> > -				.len = sizeof(isl6421->config) };
> > +	struct i2c_msg msg[2] = {
> > +		{
> > +		  .addr = isl6421->i2c_addr,
> > +		  .flags = 0,
> > +		  .buf = &isl6421->config,
> > +		  .len = 1,
> > +		}, {
> > +		  .addr = isl6421->i2c_addr,
> > +		  .flags = I2C_M_RD,
> > +		  .buf = &buf,
> > +		  .len = 1,
> > +		}
> > +
> > +	};
> >   
> >   	isl6421->config &= ~(ISL6421_VSEL1 | ISL6421_EN1);
> >   
> >   	switch(voltage) {
> >   	case SEC_VOLTAGE_OFF:
> > +		is_off = true;
> >   		break;
> >   	case SEC_VOLTAGE_13:
> > +		is_off = false;
> >   		isl6421->config |= ISL6421_EN1;
> >   		break;
> >   	case SEC_VOLTAGE_18:
> > +		is_off = false;
> >   		isl6421->config |= (ISL6421_EN1 | ISL6421_VSEL1);
> >   		break;
> >   	default:
> > @@ -66,7 +84,51 @@ static int isl6421_set_voltage(struct dvb_frontend *fe,
> >   	isl6421->config |= isl6421->override_or;
> >   	isl6421->config &= isl6421->override_and;
> >   
> > -	return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
> > +	/*
> > +	 * If LNBf were not powered on, disable dynamic current limit, as,
> > +	 * according with datasheet, highly capacitive load on the output may
> > +	 * cause a difficult start-up.
> > +	 */
> > +	if (isl6421->is_off && !is_off)
> > +		isl6421->config |= ISL6421_EN1;
> > +
> > +	ret = i2c_transfer(isl6421->i2c, msg, 2);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (ret != 1)
> > +		return -EIO;  
> 
> This needs to check ret != 2
> 
> > +
> > +	isl6421->is_off = is_off;
> > +
> > +	/* On overflow, the device will try again after 900 ms (typically) */
> > +	if (isl6421->is_off && (buf & ISL6421_OLF1))
> > +		msleep(1000);
> > +
> > +	if (isl6421->is_off && !is_off) {
> > +		isl6421->config &= ~ISL6421_EN1;
> > +
> > +		ret = i2c_transfer(isl6421->i2c, msg, 2);
> > +		if (ret < 0)
> > +			return ret;
> > +		if (ret != 1)
> > +			return -EIO;
> > +	}  
> 
> Same again
> 
> > +
> > +	/* Check if overload flag is active. If so, disable power */
> > +	if (buf & ISL6421_OLF1) {
> > +		isl6421->config &= ~(ISL6421_VSEL1 | ISL6421_EN1);
> > +		ret = i2c_transfer(isl6421->i2c, msg, 1);
> > +		if (ret < 0)
> > +			return ret;
> > +		if (ret != 1)
> > +			return -EIO;
> > +		isl6421->is_off = true;
> > +
> > +		dev_warn(&isl6421->i2c->dev,
> > +			 "Overload current detected. disabling LNBf power\n");
> > +		return -EINVAL;
> > +	}
> > +	return 0;
> >   }
> >   
> >   static int isl6421_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
> > @@ -148,6 +210,8 @@ struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter
> >   		return NULL;
> >   	}
> >   
> > +	isl6421->is_off = true;
> > +
> >   	/* install release callback */
> >   	fe->ops.release_sec = isl6421_release;
> >     
> 
> 
> Once I changed these it worked fine - I can still tune in with this 
> patch even switching from H to V. I've no idea if this fixes the bug 
> logged in kaffeine though as I haven't seen it.

Hi Jemma,

Thanks for testing! Just sent a v2 with the fixes you pointed.
Please reply it with a tested-by.

IMHO, detecting current overflow is a good improvement for the
driver.

I suspect that, in the case of Kaffeine's bug, the issue could also
be due to a very long cabling. So, I'm preparing another patch that
will let the user to optionally ask for a higher voltage (Isil 6421
allows selecting 14V/19V instead of the standard 13V/18V).

Thanks,
Mauro
