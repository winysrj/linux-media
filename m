Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:29148 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab1BNAQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 19:16:48 -0500
Subject: Re: [corrected get-bisect results]: DViCO FusionHDTV7 Dual Express
 I2C write failed
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mark Zimmerman <markzimm@frii.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1297632410.2401.6.camel@localhost>
References: <20101207190753.GA21666@io.frii.com>
	 <20110212152954.GA20838@io.frii.com> <20110213144758.GA79915@io.frii.com>
	 <AANLkTik5iYsS5UNQQv6OxTyC0X9nEYvsOEtA6mBLQ-Jq@mail.gmail.com>
	 <20110213202644.GA15282@io.frii.com>  <1297632410.2401.6.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 19:16:54 -0500
Message-ID: <1297642614.19186.38.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-02-13 at 16:26 -0500, Andy Walls wrote:
> On Sun, 2011-02-13 at 13:26 -0700, Mark Zimmerman wrote:
> > On Sun, Feb 13, 2011 at 09:52:25AM -0500, Devin Heitmueller wrote:
> > > On Sun, Feb 13, 2011 at 9:47 AM, Mark Zimmerman <markzimm@frii.com> wrote:
> > > > Clearly my previous bisection went astray; I think I have a more
> > > > sensible result this time.
> > > >
> > > > qpc$ git bisect good
> > > > 44835f197bf1e3f57464f23dfb239fef06cf89be is the first bad commit
> > > > commit 44835f197bf1e3f57464f23dfb239fef06cf89be
> > > > Author: Jean Delvare <khali@linux-fr.org>
> > > > Date: ? Sun Jul 18 16:52:05 2010 -0300
> > > >
> > > > ? ?V4L/DVB: cx23885: Check for slave nack on all transactions
> > > >
> > > > ? ?Don't just check for nacks on zero-length transactions. Check on
> > > > ? ?other transactions too.
> > > 
> > > This could be a combination of the xc5000 doing clock stretching and
> > > the cx23885 i2c master not properly implementing clock stretch.  In
> > > the past I've seen i2c masters broken in their handling of clock
> > > stretching where they treat it as a NAK.
> > > 
> > > The xc5000 being one of the few devices that actually does i2c clock
> > > stretching often exposes cases where it is improperly implemented in
> > > the i2c master driver (I've had to fix this with several bridges).
> > > 

Devin,

I just checked.  The CX23885 driver *is* setting up to allow slaves to
stretch the clock.

By analysis, I have confirmed that Jean's sugguested patch that I moved
forward was wrong for the hardware's behavior.  When the cx23885 I2C
routines decide to set the I2C_EXTEND flag (and maybe the I2C_NOSTOP
flag), we most certainly should *not* be expecting an ACK from the
particular hardware register.  The original commit should certainly be
reverted.

Checking for slave ACK/NAK will need to be done with a little more care;
so for now, I'll settle for ignoring them.

Regards,
Andy

