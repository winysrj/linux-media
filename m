Return-path: <mchehab@pedra>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:56903 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0JTU61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 16:58:27 -0400
Received: from TheShoveller.local
 (ool-4572125f.dyn.optonline.net [69.114.18.95]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0LAL002V3WXD7I90@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 16:58:26 -0400 (EDT)
Date: Wed, 20 Oct 2010 16:58:27 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885 module
In-reply-to: <BLU0-SMTP3076739B1A745CCB3563D3A75C0@phx.gbl>
To: Daniel Lee Kim <danlkim@hotmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4CBF57F3.1000008@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <BLU0-SMTP179D180C75C88F1B693AA73A75A0@phx.gbl>
 <4CBE0D47.7080201@kernellabs.com>
 <BLU0-SMTP3076739B1A745CCB3563D3A75C0@phx.gbl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/20/10 12:19 PM, Daniel Lee Kim wrote:
> Thank you, Steve, for introducing me to the mailing list and showing me the
> protocol. I have taken a look at your questions and comments. My responses are
> interspersed in the email below

You are welcome.

<cut>

> However, running dmesg, I get the following:
> [ 3072.274680] cx23885 driver version 0.0.2 loaded
> [ 3072.274752] cx23885 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [ 3072.274970] CORE cx23885[0]: subsystem: 1461:d439, board: AVermedia M791
> [card=29,autodetected]
> [ 3072.605134] cx23885_dvb_register() allocating 1 frontend(s)
> [ 3072.605189] cx23885[0]: cx23885 based dvb card
> [ 3072.621974] MT2131: successfully identified at address 0x60
> [ 3072.621981] DVB: registering new adapter (cx23885[0])
> [ 3072.621986] DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303
> VSB/QAM Frontend)...
> [ 3072.622519] cx23885_dev_checkrevision() Hardware revision = 0xb1
> [ 3072.622529] cx23885[0]/0: found at 0000:04:00.0, rev: 15, irq: 19, latency:
> 0, mmio: 0xea000000
> [ 3072.622540] cx23885 0000:04:00.0: setting latency timer to 64
> [ 3072.622546] IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
>
> so it does look like it has identified MT2131 as the tuner but is unable to work
> it.
>
> Any further help would be greatly appreciated.

If the drivers are now loading (which sounds like progress) then the GPIOs (in 
whatever form you have them) are probably OK. Double check this by doing a cold 
boot without booting into windows first, does the tuner still attach?

It's never wise to drive a GPIO regardless unless you know what you are doing, 
you could be sinking current into a part for long periods of time that doesn't 
like it (or applying/removing write protection from eeproms etc).

At this stage I'd probably guess when you say the 'tuner is unable to work' that 
it's not locking when testing with azap (and a correctly configured 
channels.conf). It's probably the I/F (intermediate frequency) between the 
MT2131 and the LG3305 is incorrect, so the demod does not see the RF correctly 
from the tuner. Try stepping the LG I/F through it's various combination (see 
the LG header .h file) then repeat the test with spectral inversion inverted.

Use azap to tune during each test and watch for status bits 0x1f (meaning the 
demod is locked).

If no lock, adjust the I/F and/or spectral inversion and try again.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

