Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51541 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZFZSDd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:03:33 -0400
Subject: cx18: MPC718 MT352 "firmware" load needs testing (Re: Acer aspire
 idea 500?)
From: Andy Walls <awalls@radix.net>
To: Steve Firth <firth650@btinternet.com>
Cc: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
In-Reply-To: <1245793760.3185.11.camel@palomino.walls.org>
References: <etPan.4a40fbf2.26aadd86.59ac@localhost>
	 <1245793760.3185.11.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 14:00:39 -0400
Message-Id: <1246039239.3159.26.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-06-23 at 17:49 -0400, Andy Walls wrote:
> On Tue, 2009-06-23 at 16:59 +0100, Steve Firth wrote:
> > Just another quick update. 
> > 
> > I've now reinstalled the 2nd tuner card back into the ACER 500, and I
> > can confirm  that the patched drivers for the Yuan MPC718 work fine on
> > DVB-T both inside and outside of mythtv. 
> 
> Glad to hear it's working. 

> > I don't know how your release procedures work or if further testing or
> > trials are needed but if you require me to do any e.g. regression
> > testing  just let me know
> 
> I'd like to get 2 more things done:
> 
> 1. Get the EEPROM dump working for the MPC-718 working properly.  It
> will hopefully be useful for identifying variants of the card in the
> future.
> 
> 2. Change the function to init the mt352 DVB-T demodulator to read in a
> "firmware" file.  The init sequence in my repository was extracted from
> the windows driver.  I strongly believe I cannot have that committed to
> the Linux kernel, even though it is only 46 bytes from a 143 kilobyte
> file.  I will also have to write an extraction tool to pull the sequence
> out of the windows binary and put instructions on a wiki page.
> 
> 
> I will need you to test both of these changes when I'm ready.

Steve,

To ensure MPC-718 DVB-T support can be included in the Linux kernel, I
have checked in changes to my MPC-718 development repo to:

1. extract a "firmware" sequence from the MPC-718 Windows driver
2. load that firmware in the cx18 driver to help init the MT352 on the
MPC-718

See

http://linuxtv.org/hg/~awalls/cx18-mpc718



Please test it when you can

1. Run the get_dvb_firmware script with my changes from that repo and
install the new firmware file:

	$ cd cx18-mpc718
	$ chmod u+x linux/Documentation/dvb/get_dvb_firmware
	$ linux/Documentation/dvb/get_dvb_firmware mpc718
	$ sudo cp dvb-cx18-mpc718-mt352.fw /lib/firmware   (or wherever for your distro)

2. Compile, install, and test the updated cx18 driver from that repo.


Once we know it works for you, I can build a cleaned up patch set and
ask for it to be pulled to the main v4l-dvb repo.

I'd still like to fix (and have you test) the EEPROM dump after we know
the DVB-T changes are good.


Regards,
Andy


