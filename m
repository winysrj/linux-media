Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933780Ab3DOMmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 08:42:54 -0400
Date: Mon, 15 Apr 2013 09:42:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
Message-ID: <20130415094248.2272db90@redhat.com>
In-Reply-To: <8085333.TIMqcSUBaO@avalon>
References: <3775187.HOcoQVPfEE@avalon>
	<20130414165958.6a8bc9eb@redhat.com>
	<8085333.TIMqcSUBaO@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Apr 2013 12:19:23 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Sunday 14 April 2013 16:59:58 Mauro Carvalho Chehab wrote:
> > Em Fri, 12 Apr 2013 11:13:06 +0200 Laurent Pinchart escreveu:
> > > Hi Mauro,
> > > 
> > > The following changes since commit 
> 81e096c8ac6a064854c2157e0bf802dc4906678c:
> > >   [media] budget: Add support for Philips Semi Sylt PCI ref. design
> > > 
> > > (2013-04-08 07:28:01 -0300)
> > > 
> > > are available in the git repository at:
> > >   git://linuxtv.org/pinchartl/media.git sensors/next
> > > 
> > > for you to fetch changes up to c890926a06339944790c5c265e21e8547aa55e49:
> > >   mt9p031: Use the common clock framework (2013-04-12 11:07:07 +0200)
> > > 
> > > ----------------------------------------------------------------
> > > 
> > > Laurent Pinchart (5):
> > >       mt9m032: Fix PLL setup
> > >       mt9m032: Define MT9M032_READ_MODE1 bits
> > >       mt9p031: Use devm_* managed helpers
> > >       mt9p031: Add support for regulators
> > >       mt9p031: Use the common clock framework
> > 
> > Hmm... It seems ugly to have regulators and clock framework and other SoC
> > calls inside an i2c driver that can be used by a device that doesn't have
> > regulators.
> > 
> > I'm not sure what's the best solution for it, so, I'll be adding those two
> > patches, but it seems that we'll need to restrict the usage of those calls
> > only if the caller driver is a platform driver.
> 
> The MT9P031 needs power supplies and a clock on all platforms, regardless of 
> the bridge bus type. 

Well, all digital devices require clock and power. If power is either a
simple electric circuit, a battery or a regulator, that depends on the board.

> I suppose the use case that mostly concerns you here is 
> USB webcams 

Yes.

> where the power supplies and the clock are controlled 
> automatically by the device. 

Or could be not controlled at all. It could be a simple XTAL attached to the
sensor or a clock signal provided by the bridge obtained from a fixed XTAL,
and a resistor bridge or a Zenner diode providing the needed power voltage.

> If we ever need to support such a device in the 
> future we can of course revisit the driver then, and one possible solution 
> would be to register fixed voltage regulators and a fixed clock.

That is an overkill: devices were the power supply/xtal clock can't be
controlled should not require extra software that pretend to control it.

Regards,
Mauro
