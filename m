Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46037
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751068AbdHPJmf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 05:42:35 -0400
Date: Wed, 16 Aug 2017 06:42:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jemma Denson <jdenson@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2] media: isl6421: add checks for current overflow
Message-ID: <20170816064226.54002cc7@vela.lan>
In-Reply-To: <bac2323e-6bde-08f8-1143-31a0b1d7176a@gmail.com>
References: <24d5b36b-0ed5-f290-15a3-d291b10b6c39@gmail.com>
        <201c07fc2bed74943f2a74fc5734d9aed3e62f8d.1502652879.git.mchehab@s-opensource.com>
        <bac2323e-6bde-08f8-1143-31a0b1d7176a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Aug 2017 20:51:09 +0100
Jemma Denson <jdenson@gmail.com> escreveu:

> Hi Mauro,
> 
> On 13/08/17 20:35, Mauro Carvalho Chehab wrote:
> 
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
> > index 838b42771a05..b04d56ad4ce8 100644
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
> 
> Checking the datasheet I think we need to be setting DCL high instead. EN1 is
> already set anyway.

Yes, that was the idea. Not sure what happened here :-)

> > +
> > +	ret = i2c_transfer(isl6421->i2c, msg, 2);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (ret != 2)
> > +		return -EIO;
> > +
> > +	isl6421->is_off = is_off;  
> 
> Is this in the right place?

On my first internal versions, this used to be below, but I guess
the best is to place it here, because, if the next i2c_transfer
fail, this would still reflect the current state.

> 
> > +
> > +	/* On overflow, the device will try again after 900 ms (typically) */
> > +	if (isl6421->is_off && (buf & ISL6421_OLF1))
> > +		msleep(1000);  
> 
> 1000ms does only cover one cycle of OFF then ON - the device will keep cycling
> 900ms off then 20ms on until overflow is cleared so it might take longer but
> adding the code to support longer is  probably not worth it. Waiting one cycle
> is better than the current none anyway.

Yes, I know it could wait for more time here, but not sure if it would
be worth doing it. The problem is that 1000ms is already a lot of time,
and if this gets too long, userspace may any giving up of tuning,
anyway.

> > +
> > +	if (isl6421->is_off && !is_off) {
> > +		isl6421->config &= ~ISL6421_EN1;

Again, this should be DCL.

> > +
> > +		ret = i2c_transfer(isl6421->i2c, msg, 2);
> > +		if (ret < 0)
> > +			return ret;
> > +		if (ret != 2)
> > +			return -EIO;
> > +	}  
> 
> Does this if statement ever match? isl6421->is_off and is_off are the same value
> at this point. I presume this is supposed to be re-enabling DCL so would again
> also need that bit instead of EN1. We might also need a little delay before
> turning it on - the datasheet mentions a "chosen amount of time". I've no idea
> what's appropriate here, 200ms?
> 
> A simpler if statement might be just (isl6421->config & ISL6421_DCL), we just
> need to check DCL was set high above.

It used to, on my original version, where I was setting config->is_off only
at the end :-)

Yeah, checking for DCL is a way more reliable.

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
> I've just tested both your v2 patch and changes I'm suggesting above; both work
> fine on my setup. Do you want me to send a v3?

Yeah, sure! I'm currently in travel, returning only on Friday, and I don't
have the hardware to test. So, if you can send it, I'd appreciate :-)

Cheers,
Mauro
