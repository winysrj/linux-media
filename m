Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38233 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750827AbZKWNln (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 08:41:43 -0500
Date: Mon, 23 Nov 2009 14:41:38 +0100
From: grafgrimm77@gmx.de
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dibusb-common.c FE_HAS_LOCK problem
Message-ID: <20091123144138.5a27485b@x2.grafnetz>
In-Reply-To: <alpine.LRH.2.00.0911231418350.14263@pub1.ifh.de>
References: <20091107105614.7a51f2f5@x2.grafnetz>
	<alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de>
	<20091121182514.61b39d23@x2.grafnetz>
	<alpine.LRH.2.00.0911230947540.14263@pub1.ifh.de>
	<20091123120310.5b10c9cc@x2.grafnetz>
	<alpine.LRH.2.00.0911231206450.14263@pub1.ifh.de>
	<20091123123338.7273255b@x2.grafnetz>
	<alpine.LRH.2.00.0911231321270.14263@pub1.ifh.de>
	<alpine.LRH.2.00.0911231418350.14263@pub1.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 23 Nov 2009 14:19:10 +0100 (CET)
schrieb Patrick Boettcher <pboettcher@kernellabs.com>:

> On Mon, 23 Nov 2009, Patrick Boettcher wrote:
> 
> > On Mon, 23 Nov 2009, grafgrimm77@gmx.de wrote:
> >> [..]
> >> ----- hello stupid I2C access ----
> >> Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
> >> Call Trace:
> >> [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
> >> [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
> >> [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
> >> [<ffffffffa00855c9>] ? dvb_pll_attach+0xa9/0x238 [dvb_pll]
> >> [..]
> >
> > Voila.
> >
> > This is the access with makes the dvb-pll-driver not create the tuner driver.
> >
> > This is (I forgot the correct name) read-without-write-i2caccess. It is bad 
> > handled by the dibusb-driver and it can destroy the eeprom on the USB side.
> >
> > Please try whether the attached patch fixes the whole situation for you.
> >
> > If so, please send back a line like this:
> >
> > Tested-by: Your name <email>
> 
> The patch attached.
> 
> --
> 
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/

Hi Patrick, 

your patch [dibusb-common-fix  text/PLAIN (1054 bytes)] works here. 

Tested-by: Mario Bachmann <grafgrimm77@gmx.de>

Mario
