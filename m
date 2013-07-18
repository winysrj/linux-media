Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35161 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756310Ab3GRKsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 06:48:52 -0400
Message-ID: <1374144546.1946.14.camel@palomino.walls.org>
Subject: Re: [PATCH] cx23885: Fix interrupt storm that happens in some cards
 when IR is enabled.
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Luis Alves <ljalvs@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	mchehab@infradead.org
Date: Thu, 18 Jul 2013 06:49:06 -0400
In-Reply-To: <CAGoCfizd+Ax3OfuHuxVMc17==SrTD3caidEph_CjN+2To29s0w@mail.gmail.com>
References: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
	 <CAGoCfizDcOPKiCo54rsoZJyXU3m-_v8jE0aTagxTyjB3QZrZXg@mail.gmail.com>
	 <51E74FAF.2060709@iki.fi>
	 <CAGoCfizd+Ax3OfuHuxVMc17==SrTD3caidEph_CjN+2To29s0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-07-17 at 22:41 -0400, Devin Heitmueller wrote:
> On Wed, Jul 17, 2013 at 10:15 PM, Antti Palosaari <crope@iki.fi> wrote:
> > hmm, I looked again the cx23885 driver.
> >
> > 0x4c == [0x98 >> 1] = "flatiron" == some internal block of the chip
> 
> Yeah, ok.  Pretty sure Flatiron is the codename for the ADC for the SIF.
> 
> > There is routine which dumps registers out, 0x00 - 0x23
> > cx23885_flatiron_dump()
> >
> > There is also existing routine to write those Flatiron registers. So, that
> > direct I2C access could be shorten to:
> > cx23885_flatiron_write(dev, 0x1f, 0x80);
> > cx23885_flatiron_write(dev, 0x23, 0x80);
> 
> Yeah, the internal register routines should be used to avoid confusion.
> 
> > Unfortunately these two register names are not defined. Something clock or
> > interrupt related likely.
> 
> Strange.  The ADC output is usually tied directly to the Merlin.  I
> wonder why it would ever generate interrupts.

The CX2310[012] datasheet has a very short description of these Flatiron
registers.

Apparently the Flatiron genereates an interrupt after the built-in self
test for each of its left and right channels has completed.

Apparently Conexant wire-OR'ed the Flatiron's interrupt output with the
interrupt output of the CX23885 A/V core.



> No easy answers here.  WIll probably have to take a closer look at the
> datasheet, or just ask Andy.

The I2C writes clear the interrupt status of the built in self test
status interrupt for the left and right channels respectively.

It would be best to do this after any spurious A/V core interrupt is
detected from a CX23885.  Since they are I2C writes, they have to be
done in a non-IRQ context, as are the IR unit manipulations.

Regards,
Andy



