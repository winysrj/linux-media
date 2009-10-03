Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59972 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZJCRoe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 13:44:34 -0400
Received: by fxm27 with SMTP id 27so1963479fxm.17
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 10:43:57 -0700 (PDT)
Date: Sat, 3 Oct 2009 20:43:56 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>
Subject: Re: AVerTV MCE 116 Plus remote
Message-ID: <20091003174356.GA10155@moon>
References: <20091002214909.GA4761@moon> <1254575947.3169.11.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1254575947.3169.11.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 03, 2009 at 09:19:07AM -0400, Andy Walls wrote:
> On Sat, 2009-10-03 at 00:49 +0300, Aleksandr V. Piskunov wrote:
> > Preliminary version of patch adding support for AVerTV MCE 116 Plus remote.
> > This board has an IR sensor is connected to EM78P153S, general purpose 8-bit
> > microcontroller with a 1024 × 13 bits of OTP-ROM. According to i2cdetect, it is
> > sitting on address 0x40.
> > 
> > Patch allows ir-kbd-i2c to probe cx2341x boards for this address. Manually
> > loading ir-kbd-i2c now detects remote, every key is working as expected.
> > 
> > As I understand, current I2C/probing code is being redesigned/refactored. Sheer
> > amount of #ifdefs for every second kernel version is making my eyes bleed, so
> > please somebody involved check if patch is ok. 
> 
> 
> Aleksandr,
> 
> 
> > Should I also add the 0x40 address to addr_list[] in ivtv-i2c.c? How to point
> > ivtv to this remote and autoload ir-kbd-i2c?
> 
> No.
> 
> 
> At first glance, this patch doesn't look safe for all ivtv boards so:
> 
> 	Naked-by: Andy Walls <awalls@radix.net>
> 
> 
> In ivtv-i2c.c I see:
> 
> 	#define IVTV_MSP3400_I2C_ADDR           0x40
> 
> It is probably not good to assume that only an IR microcontroller could
> be at I2C address 0x40 for a CX2341x adapter.
> 

Yea, that did confuse me too yesterday, saw it while searching sources for 0x40.
Thanks for pointing out the problem! Besides after some testing I don't really like
the way that IR controller behaves, doesn't always catch keypresses, repeats
chaotically and sends wrong keygroup codes from time to time. Basically in order to
get a more or less stable keypress, one has to "doubleclick" the button on remote,
strange..

> I will work up an ivtv specific change similar to what I did in
> cx18-cards.c and cx18-i2c.c for IR on the HVR-1600 for bringing up the
> IR for the M116 cards alone.
> 
> What kernel version do you use?
> 

2.8.28, can easily switch to any later for testing.
