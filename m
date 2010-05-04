Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f202.google.com ([209.85.223.202]:37293 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab0EDCim (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 22:38:42 -0400
Received: by iwn40 with SMTP id 40so4232759iwn.1
        for <linux-media@vger.kernel.org>; Mon, 03 May 2010 19:38:41 -0700 (PDT)
Subject: Linux kernel development for the Geniatech/Mygica A680B
 (AU0828/AU8524/TDA18271)
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>
Cc: linux-media@vger.kernel.org, Fang <Fjj@geniatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 19:38:37 -0700
Message-ID: <1272940717.32556.98.camel@chimera>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am writing to the three of you to ask whether you have any uncommitted
code for the au0828 and/or au8522 drivers so that I do not reinvent the
wheel. I am CC'ing the mailing list for posterity and the ODM contact
that came forward a year ago here:
<http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/18802>

I have begun by forward-porting the changes from the mercurial tree at
<http://linuxtv.org/hg/~mkrufky/teledongle> to the mercurial tree at
<http://linuxtv.org/hg/dvb-apps>, and I found the result _mostly_ works,
but the demodulator has trouble providing a stream after some tuning
attempts and not others. It seems to be more successful if the Windows
driver first initializes the device in a VM. The Usbsnoop report shows
that a different, shorter initialization sequence is used. First of all,
the 0x600 register in the AU0828 is not touched, but instead, 0x1 is
written to 0x601. Instead of the AU0828's GPIO setup registers being put
in a reset state and then taken out, they are written once, with 0x0 to
0x003 and 0x001, 0xec to 0x002, and 0xe0 to 0x000. Prior to DVB use, 0x5
is written to 0x601. Rather than blindly replacing the existing sequence
with this (which does not create a noticeable change), I ask the
significance of register 0x601 and the relevant GPIO setup bits, based
on your knowledge of the chips involved, and maybe the CC'ed ODM might
say how this device in particular uses them, as well as how to
differentiate among different similar Geniatech devices. Also, the
Usbsnoop report shows that the 0x202 clock divider register is set to
0x4, 0x8, and 0x20, in different contexts.

It seems most supported AU0828 devices have an IR receiver, so I am
wondering whether any code has already been written for it. I don't know
about other AU0828 devices, but the Usbsnoop report for this one reveals
a pretty straightforward protocol:

The AU8524 demodulator has a GPIO control register (0xe0), a GPIO status
register (0xe1), and a GPIO data register (0xe2). An access cycle of
read-modify-write-verify sets bit 4 in the control register and then the
status register is read. Rinse and repeat 100ms later.

Is this at all typical of other AU0828 devices with IR?

