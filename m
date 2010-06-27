Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41538 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0F0Uvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 16:51:32 -0400
Message-ID: <4C27B9CD.4070404@kolumbus.fi>
Date: Sun, 27 Jun 2010 23:51:25 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Jaroslav Klaus <jaroslav.klaus@gmail.com>
Subject: Re: TS discontinuity with TT S-2300
References: <1CF58597-201D-4448-A80C-55815811753E@gmail.com> <201006271437.01502@orion.escape-edv.de> <4C277496.7050508@kolumbus.fi> <201006272025.39822@orion.escape-edv.de>
In-Reply-To: <201006272025.39822@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

27.06.2010 21:25, Oliver Endriss wrote:
> Are you sure that Mantis driver delivers garbage, not partial packets?
> Please note that the dvb_dmx_swfilter[_204]() routines must accept
> partial packets, i.e. the rest of the packet will be dellivered with the
> next call.
>   
Yes, I'm sure that the garbage comes from the PCI device itself:
garbage should be found at less than 204 byte position otherwise.

My latest mailed patch that I use makes sure 0x47 is found at
demux->tsbufp[0],
if there is at least one spared byte. Otherwise the resulting 188 sized
packet would be discarded eventually.

It would be good if Mauro would accept my patch for dvb_dmx_swfilter(_204)
functions some day. It increases robustness with garbage input, and
performance by avoiding unnecessary packet copying.

> dvb_dmx_swfilter_packets() expects complete TS packets from the driver.
> The saa7146 does so. It does not deliver garbage data. (Otherwise this
> would have been noticed a long time ago. The ttpci drivers are the
> oldest DVB drivers and are very well tested.)
>   
I'm very sorry I even questioned ttpci's and the hardware's robustness.

I'm delighted to hear that ttpci is so well implemented and tested and
so long :)
I was very impressed in the quality of the code with
dvb_dmx_swfilter_packets():
so simple and efficient.

Unfortunately I have had lots of problems with Mantis.
But because of that, I've learned DVB driver programming.

H.264 works now mostly in one TV channel without crashing Xine with
remote vdr.
I had to modify streamdev plugin too for vdr.

CU
Marko

