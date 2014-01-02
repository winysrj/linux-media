Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:24038 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABTUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 14:20:43 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYS004LQGEIF010@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jan 2014 14:20:42 -0500 (EST)
Date: Thu, 02 Jan 2014 17:20:31 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3 11/24] tvp5150: make read operations atomic
Message-id: <20140102172031.325d89fb@samsung.com>
In-reply-to: <52C463D8.7020406@googlemail.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
 <1388232976-20061-12-git-send-email-mchehab@redhat.com>
 <52C463D8.7020406@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 01 Jan 2014 19:52:08 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 28.12.2013 13:16, schrieb Mauro Carvalho Chehab:
> > From: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >
> > Instead of using two I2C operations between write and read,
> > use just one i2c_transfer. That allows I2C mutexes to not
> > let any other I2C transfer between the two.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/i2c/tvp5150.c | 22 ++++++++++------------
> >  1 file changed, 10 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > index 89c0b13463b7..d6ba457fcf67 100644
> > --- a/drivers/media/i2c/tvp5150.c
> > +++ b/drivers/media/i2c/tvp5150.c
> > @@ -58,21 +58,19 @@ static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
> >  	struct i2c_client *c = v4l2_get_subdevdata(sd);
> >  	unsigned char buffer[1];
> >  	int rc;
> > +	struct i2c_msg msg[] = {
> > +		{ .addr = c->addr, .flags = 0,
> > +		  .buf = &addr, .len = 1 },
> I would use        .buf = buffer        here, too.

Why? The address needed is already at addr, and it is also an unsigned char.

Using buffer would require an extra data copy.

> 
> > +		{ .addr = c->addr, .flags = I2C_M_RD,
> > +		  .buf = buffer, .len = 1 }
> > +	};
> >  
> >  	buffer[0] = addr;
> >  
> > -	rc = i2c_master_send(c, buffer, 1);
> > -	if (rc < 0) {
> > -		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
> > -		return rc;
> > -	}
> > -
> > -	msleep(10);
> That's the critical change.

I don't think so. I'm not sure why I added this at the first place on the
original patch with where I added this driver, but it is very doubtful
that a msleep() is needed here.

This code is really old (from the time I added support for WinTV USB 2).

I suspect I added the sleep there just because the I2C logs, during the
driver development phase, to be an exact mimic on what it was got via
USB dumps.

> 
> > -
> > -	rc = i2c_master_recv(c, buffer, 1);
> > -	if (rc < 0) {
> > -		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
> > -		return rc;
> > +	rc = i2c_transfer(c->adapter, msg, 2);
> > +	if (rc < 0 || rc != 2) {
> > +		v4l2_err(sd, "i2c i/o error: rc == %d (should be 2)\n", rc);
> > +		return rc < 0 ? rc : -EIO;
> >  	}
> >  
> >  	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n", addr, buffer[0]);
> Looks good and works without problems with my HVR-900 and WinTV 2
> devices (both em28xx).
> 


-- 

Cheers,
Mauro
