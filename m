Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58077 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZCNCgn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 22:36:43 -0400
Subject: Re: cx231xx review of i2c handling
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200903130032.07709.hverkuil@xs4all.nl>
References: <200903130032.07709.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 22:36:17 -0400
Message-Id: <1236998177.3290.165.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-03-13 at 00:32 +0100, Hans Verkuil wrote:
> Hi Sri,
> 
> Here is a review of the i2c part of this driver, together with pointers on 
> how to proceed to convert it to v4l2_device/v4l2_subdev.
> 
> Time permitting I hope to look at the v4l2 implementation in the driver as 
> well over the weekend, but the i2c part is for me the most urgent issue at 
> the moment as you've no doubt guessed by now :-)
> 
> Although I couldn't help noticing this typo:
> 
> cx231xx-cards.c:                cx231xx_info("Board is Conexnat RDE 250\n");
> cx231xx-cards.c:                cx231xx_info("Board is Conexnat RDU 250\n");
> 
> :-)
> 
> Looking at cx231xx-i2c.c I see it has the following devices:
> 
> 0x32: Geminit III
> 0x02: Acquarius
> 0xa0: eeprom
> 0x60: Colibri
> 0x8e: IR
> 0x80/0x88: Hammerhead
> 
> And it also uses an external tuner.
> 
> It is my understanding that these devices are integrated on the cx231xx and 
> so are completely internal to it:
> 
> Geminit III, Acquarius, Colibri, Hammerhead.
> 
> Is the eeprom also internal, or is it external?
> 
> Why can Hammerhead be at two addresses? Since it is an integral device I'd 
> expect that the address would be fixed. Or are there two Hammerheads? 
> Looking at the source I'd say that it can only be at address 0x88.
> 
> A general note: please add a description in the cx231xx.h header or in 
> another suitable place for each of these devices. The codenames themselves 
> do not give much of an idea of what the device actually does.

Hans,

The public product brief for the CX23100, CX23101, CX23102 (Polaris?) is
here:

http://www.conexant.com/products/entry.jsp?id=552
http://www.conexant.com/servlets/DownloadServlet/PBR-201370-004.pdf?docid=1371&revid=4

There's a block diagram on the second page of the PDF and a table on the
first page showing that the CX23100 and CX23101 do not have the full
complement of internal components that the CX23102 has.

Since a Hammerhead is a shark as is a Mako, and since the CX25843
firmware is often refered to *MakoC.rom in the Windows drivers, I
guessed that the Hammerhead was an A/V digitizer.  I see you've
confirmed that from the code.  From the product brief, it looks like the
internal Hammerhead is not in the CX23100.

>From the code, it looks like the Colibri is the integrated Analog IF
demodulator.  If true, this unit is also not in the CX23100.  Thus an
analog IF demod and AV digitizer could be external to a CX23100 (but one
would have to wonder why an integrator wouuld ever do that...)

>From the code, the Flatiron looks like an Audio source and has at least
one ADC (sigma-delta) and an Audio Mux to select it's ADC or another
source for audio.  I'm guessing this is the 18 bit audio ADCs onblock on
the diagram.

According to the board entries for dmeod I2C addresses both the Gemini
III and Aquarius are demodulators.  Since the code mentions attaching
the s5h1411 module, sh51411.h mentions I2C addresses 0x32 and 0x34, and
the cx231xx code mentions the Gemini III is at 0x32, then I assume the
Gemini III is a s5h1411.  There is no mention of a linux driver for the
Aquarius I2C address.

The Product brief doesn't show an EEPROM nor does it call one out.  I'll
bet it is not internal to the Polaris.

And that's all I can deduce from publicly available information.


But the *big* question is my mind is why the unit is called Polaris and
not Ursa Minor?  The demods got named after whole constellations, and
not just a single star in one. ;)


Regards,
Andy



