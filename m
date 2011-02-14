Return-path: <mchehab@pedra>
Received: from smtp02.frii.com ([216.17.135.168]:50569 "EHLO smtp02.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1BNAhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 19:37:47 -0500
Date: Sun, 13 Feb 2011 17:37:46 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [corrected get-bisect results]: DViCO FusionHDTV7 Dual Express
	I2C write failed
Message-ID: <20110214003746.GA42201@io.frii.com>
References: <20101207190753.GA21666@io.frii.com> <20110212152954.GA20838@io.frii.com> <20110213144758.GA79915@io.frii.com> <AANLkTik5iYsS5UNQQv6OxTyC0X9nEYvsOEtA6mBLQ-Jq@mail.gmail.com> <20110213202644.GA15282@io.frii.com> <1297632410.2401.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297632410.2401.6.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 13, 2011 at 04:26:50PM -0500, Andy Walls wrote:
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
> > 
> > Thanks for your insight. I am looking at cx23885-i2c.c and there is no
> > clock stretching logic in i2c_slave_did_ack().  Would this be the
> > right place for it to be?  Can you point me to an example of another
> > driver that does it correctly?  I really don't know what I am doing...
> 
> 
> Mark,
> 
> You don't have much hope of getting that right without the CX23885
> datasheet.
> 
> Let's just get the bad commit reverted and into 2.6.38, and fix what
> used to work for you.  Doing a git bisect is enough work for anyone.
> 
> I'll do a patch to revert the commit and ask it to be pulled for
> 2.6.38-rc-whatever.  I'll be sure to add a
> 
> 	Bisected-by: Mark Zimmerman <markzimm@frii.com>
> 
> tag to the patch.  (The Linux Kernel devs understand the work involved
> to do a bisection.)
> 
> 
> Later, if I can work up a patch to deal with clock stretching properly,
> I may ask you to test.
> 
Thanks, that would be great. Meanwhile, I have built a 2.6.37 with the
offending commit removed:

git bisect reset
git checkout v2.6.37
git revert 44835f197bf1e3f57464f23dfb239fef06cf89be

and it seems to be working fine using both tuners:

xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
xc5000: firmware read 12401 bytes.
xc5000: firmware uploading...
xc5000: firmware upload complete...
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
xc5000: firmware read 12401 bytes.
xc5000: firmware uploading...
xc5000: firmware upload complete...

Thanks again
-- Mark

