Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZHUGHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 02:07:54 -0400
Date: Fri, 21 Aug 2009 03:07:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Miguel <mcm@moviquity.com>, linux-media@vger.kernel.org
Subject: Re: USB Wintv HVR-900 Hauppauge
Message-ID: <20090821030749.372093bd@pedra.chehab.org>
In-Reply-To: <829197380908191016n8d7f21eq88ebe3a45816275b@mail.gmail.com>
References: <1250679685.14727.14.camel@McM>
	<829197380908190642sfabee2ahe599dda1df39678c@mail.gmail.com>
	<1250701340.14727.28.camel@McM>
	<829197380908191016n8d7f21eq88ebe3a45816275b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Aug 2009 13:16:23 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Unfortunately, it is not clear when/if Mauro will ever get back to
> getting that bridge to a supported state (it hasn't had any active
> development in over nine months).

This is a recorrent question, already discussed at the ML. Probably, I should
update the wiki.

The driver is still on my TODO list. I intend to return back to it, but this is
not on my current top priorities. Those chips are very buggy and they behave
badly if the driver doesn't do exactly the same thing as the original one (it
starts to loose frames). I suspect that this is a firmware bug at
tm6000/tm6010, although I'm not sure. Maybe the conversion of the driver to the
new i2c approach could help to fix this issue, since this will avoid sending
probing packets at i2c bus. Also, on all tests we've done so far, it can't
reliably read data from an i2c device. This prevents that tools like scan to
properly detect the signal strength of a channel. You can't even be sure if
xc3028 firmware were successfully loaded on this device, due to this issue.

It is important to notice that the vendor (Trident) doesn't seem to want
helping with open source development. I tried during 2007 and 2008 to get their
help by opening docs to me, via Linux Foundation NDA program, without success.
Currently, they are refusing so far to help with their demod DRX-K line that
they acquired from Micronas (as pointed at http://linux.terratec.de/tv_en.html).

In brief, while I want to fix the driver issues, I recommend to avoid
buying any devices with tm5600/tm6000/tm6010 (and DRX demod) chips. There are
other offers at the market with drivers that work properly, including some
nice HVR devices that are fully supported.



Cheers,
Mauro
