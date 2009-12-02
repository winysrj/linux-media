Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:44037
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbZLBTzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 14:55:37 -0500
Subject: Re: [RFC v2] Another approach to IR
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4B16C10E.6040907@redhat.com>
Date: Wed, 2 Dec 2009 14:55:38 -0500
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <1CA77278-9B8E-4169-8F10-78764A35F64E@wilsonet.com>
References: <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com> <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com> <4B155288.1060509@redhat.com> <20091201175400.GA19259@core.coreip.homeip.net> <4B1567D8.7080007@redhat.com> <20091201201158.GA20335@core.coreip.homeip.net> <4B15852D.4050505@redhat.com> <20091202093803.GA8656@core.coreip.homeip.net> <4B16614A.3000208@redhat.com> <20091202171059.GC17839@core.coreip.homeip.net> <4B16C10E.6040907@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dec 2, 2009, at 2:33 PM, Mauro Carvalho Chehab wrote:

> Dmitry Torokhov wrote:
>> 
...
>>>> (for each remote/substream that they can recognize).
>>> I'm assuming that, by remote, you're referring to a remote receiver (and not to 
>>> the remote itself), right?
>> 
>> If we could separate by remote transmitter that would be the best I
>> think, but I understand that it is rarely possible?
> 
> IMHO, the better is to use a separate interface for the IR transmitters,
> on the devices that support this feature. There are only a few devices
> I'm aware of that are able to transmit IR codes.

If I'm thinking clearly, there are only three lirc kernel drivers that support transmit, lirc_mceusb, lirc_zilog and lirc_serial. The mceusb driver was posted, so I won't rehash what it is here. The zilog driver binds to a Zilog z80 microprocessor thingy (iirc) exposed via i2c, found on many Hauppauge v4l/dvb devices (PVR-150, HVR-1600, HD-PVR, etc). The serial driver is fairly self-explanatory as well.

There are also a few userspace-driven devices that do transmit, but I'm assuming they're (currently) irrelevant to this discussion.

-- 
Jarod Wilson
jarod@wilsonet.com



