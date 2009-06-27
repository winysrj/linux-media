Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:21495 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754372AbZF0Rsk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 13:48:40 -0400
From: David Brownell <david-b@pacbell.net>
To: davinci-linux-open-source@linux.davincidsp.com, m-karicheri2@ti.com
Subject: Re: [PATCH 3/3 - v0] davinci: platform changes to support vpfe camera capture
Date: Sat, 27 Jun 2009 10:42:01 -0700
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com> <200906271419.43942.hverkuil@xs4all.nl>
In-Reply-To: <200906271419.43942.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906271042.01379.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > --- a/arch/arm/mach-davinci/board-dm355-evm.c
> > +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> > @@ -136,10 +136,66 @@ static void dm355evm_mmcsd_gpios(unsigned gpio)
> >       dm355evm_mmc_gpios = gpio;
> >  }
> >  
> > -static struct tvp514x_platform_data tvp5146_pdata = {
> > -     .clk_polarity = 0,
> > -     .hs_polarity = 1,
> > -     .vs_polarity = 1

Clearly this patch is against neither mainline nor the
current DaVinci GIT tree... I suggest reissuing against
mainline, now that it's got most DM355 stuff.


> > +/*
> > + * MSP430 supports RTC, card detection, input from IR remote, and
> > + * a bit more.  It triggers interrupts on GPIO(7) from pressing
> > + * buttons on the IR remote, and for card detect switches.
> > + */
> > +static struct i2c_client *dm355evm_msp;
> > +
> > +static int dm355evm_msp_probe(struct i2c_client *client,
> > +             const struct i2c_device_id *id)
> > +{
> > +     dm355evm_msp = client;
> > +     return 0;
> > +}
> > +
> > +static int dm355evm_msp_remove(struct i2c_client *client)
> > +{
> > +     dm355evm_msp = NULL;
> > +     return 0;
> > +}
> > +
> > +static const struct i2c_device_id dm355evm_msp_ids[] = {
> > +     { "dm355evm_msp", 0, },
> > +     { /* end of list */ },
> > +};

Needless to say:  NAK on all this.  There is already a
drivers/mfd/dm355evm_msp.c managing this device.  You
shouldn't have video code crap all over it.

It currently sets up for TVP5146 based capture iff that
driver is configured (else the external imager); and
exports the NTSC/nPAL switch setting as a GPIO that's
also visible in sysfs.

I suggest the first revision of this VPFE stuff use
the existing setup.  A later patch could add some
support for runtime reconfiguration.

- Dave


> > +
> > +static struct i2c_driver dm355evm_msp_driver = {
> > +     .driver.name    = "dm355evm_msp",
> > +     .id_table       = dm355evm_msp_ids,
> > +     .probe          = dm355evm_msp_probe,
> > +     .remove         = dm355evm_msp_remove,
> > +};
> > +


