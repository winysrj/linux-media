Return-path: <linux-media-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51486 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747AbcGDUhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 16:37:03 -0400
Message-ID: <1467664616.2288.12.camel@HansenPartnership.com>
Subject: IR remote stopped working in kernels 4.5 and 4.6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 04 Jul 2016 13:36:56 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This looks to be a problem with the rc subsystem.  The IR controller in
question is part of a cx8800 atsc card. In the 4.4 kernel, where it
works, this is what ir-keytable says:

Found /sys/class/rc/rc0/ (/dev/input/event12) with:
	Driver cx88xx, table rc-hauppauge
	Supported protocols: other lirc rc-5 jvc sony nec sanyo mce-kbd rc-6 sharp xmp 
	Enabled protocols: lirc nec 
	Name: cx88 IR (pcHDTV HD3000 HDTV)
	bus: 1, vendor/product: 7063:3000, version: 0x0001
	Repeat delay = 500 ms, repeat period = 125 ms

And in 4.6, where it doesn't work:

Found /sys/class/rc/rc0/ (/dev/input/event12) with:
	Driver cx88xx, table rc-hauppauge
	Supported protocols: lirc 
	Enabled protocols: lirc 
	Name: cx88 IR (pcHDTV HD3000 HDTV)
	bus: 1, vendor/product: 7063:3000, version: 0x0001
	Repeat delay = 500 ms, repeat period = 125 ms

The particular remote in question seems to require the nec protocol to
work and the failure in 4.5 and 4.6 is having any supported protocols
at all.  I can get the remote to start working again by adding the nec
protocol:

echo nec > /sys/class/rc/rc0/protocols

But it would be nice to have this happen by default rather than having
to add yet another work around init script.

James

