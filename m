Return-path: <linux-media-owner@vger.kernel.org>
Received: from n11.bullet.mail.mud.yahoo.com ([209.191.125.210]:28463 "HELO
	n11.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752886AbZF2Rnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 13:43:41 -0400
From: David Brownell <david-b@pacbell.net>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 3/3 - v0] davinci: platform changes to support vpfe camera capture
Date: Mon, 29 Jun 2009 10:43:42 -0700
Cc: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com> <200906271042.01379.david-b@pacbell.net> <A69FA2915331DC488A831521EAE36FE401448CDD97@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401448CDD97@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906291043.43140.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 29 June 2009, Karicheri, Muralidharan wrote:
> <snip>
> >> >
> >> > -static struct tvp514x_platform_data tvp5146_pdata = {
> >> > -     .clk_polarity = 0,
> >> > -     .hs_polarity = 1,
> >> > -     .vs_polarity = 1
> >
> >Clearly this patch is against neither mainline nor the
> >current DaVinci GIT tree... I suggest reissuing against
> >mainline, now that it's got most DM355 stuff.
> >
> 
> That is because, I have my first (vpfe capture version v3)
> patch lined up for merge to upstream/davinci git kernel ... 
> 
> >>NOTE: Depends on v3 version of vpfe capture driver patch
> 
> What is your suggestion in such cases?

Always submit against mainline.  In the handfull of cases
that won't work (e.g. depends on code that's not there),
submit against the DaVinci tree.


> >> > +static const struct i2c_device_id dm355evm_msp_ids[] = {
> >> > +     { "dm355evm_msp", 0, },
> >> > +     { /* end of list */ },
> >> > +};
> >
> >Needless to say:  NAK on all this.  There is already a
> >drivers/mfd/dm355evm_msp.c managing this device.  You
> >shouldn't have video code crap all over it.
> >
> >It currently sets up for TVP5146 based capture iff that
> >driver is configured (else the external imager); and
> >exports the NTSC/nPAL switch setting as a GPIO that's
> >also visible in sysfs.
> >
> >I suggest the first revision of this VPFE stuff use
> >the existing setup.  A later patch could add some
> >support for runtime reconfiguration.
> >
> I didn't know that you have a video code crap added to
> drivers/mfd/dm355evm_msp.c :) 

:)

It's just setting up everything the msp430 touches,
so the board is in a known sane state.  Standard
stuff for initialization code.


> The first patch is already out and is using TVP5146.
> So I will investigate your msp driver and see how I
> can support run time configuring the input.  
> If you have any suggestion let me know.
>
> Wondering why you chose to make msp driver dm355
> specific? MSP430 is available on dm6446 and dm355, right?

The MSP430 is a microcontroller family.  The firmware used
on each board is extremely board-specific.  On DM355 EVM,
the firmware's I2C interface was at least sanely structured.

- Dave



