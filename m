Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbZLCLJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 06:09:52 -0500
Message-ID: <4B179C70.7090803@redhat.com>
Date: Thu, 03 Dec 2009 09:09:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, j@jannau.net,
	jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>	 <4B154C54.5090906@redhat.com>	 <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>	 <4B155288.1060509@redhat.com>	 <20091201175400.GA19259@core.coreip.homeip.net>	 <4B1567D8.7080007@redhat.com>	 <20091201201158.GA20335@core.coreip.homeip.net>	 <4B15852D.4050505@redhat.com>	 <20091202093803.GA8656@core.coreip.homeip.net>	 <4B16614A.3000208@redhat.com>	 <20091202171059.GC17839@core.coreip.homeip.net>	 <4B16C10E.6040907@redhat.com>	 <1CA77278-9B8E-4169-8F10-78764A35F64E@wilsonet.com> <1259802169.3085.10.camel@palomino.walls.org>
In-Reply-To: <1259802169.3085.10.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Wed, 2009-12-02 at 14:55 -0500, Jarod Wilson wrote:
>> On Dec 2, 2009, at 2:33 PM, Mauro Carvalho Chehab wrote:
>>
>>> Dmitry Torokhov wrote:
>> ...
>>>>>> (for each remote/substream that they can recognize).
>>>>> I'm assuming that, by remote, you're referring to a remote receiver (and not to 
>>>>> the remote itself), right?
>>>> If we could separate by remote transmitter that would be the best I
>>>> think, but I understand that it is rarely possible?
>>> IMHO, the better is to use a separate interface for the IR transmitters,
>>> on the devices that support this feature. There are only a few devices
>>> I'm aware of that are able to transmit IR codes.
>> If I'm thinking clearly, there are only three lirc kernel drivers that
>> support transmit, lirc_mceusb, lirc_zilog and lirc_serial. The mceusb
>> driver was posted, so I won't rehash what it is here. The zilog driver
>> binds to a Zilog z80 microprocessor thingy (iirc) exposed via i2c,
>> found on many Hauppauge v4l/dvb devices (PVR-150, HVR-1600, HD-PVR,
>> etc). The serial driver is fairly self-explanatory as well.
>>
>> There are also a few userspace-driven devices that do transmit, but
>> I'm assuming they're (currently) irrelevant to this discussion.
> 
> 
> I've got the CX23888 integrated IR Rx done and Tx nearly done.  I was
> waiting to see how kfifo and lirc_dev panned out before making the
> interface to userspace.
> 
> The CX23885, CX23418, and CX2584x integrated IR is essentially the same.
> I hope to have CX23885 IR done by Christmas.
> 
> Both of those IR devices are/will be encapsulated in a v4l2_subdevice
> object internally.  I was going to write lirc_v4l glue between the
> v4l2_device/v4l2_subdev_ir_ops and lirc_dev.
> 
> As for the the I2C chips, I was going to go back and encapsulate those
> in the v4l2_subdevice object as well, so then my notional lirc_v4l could
> pick those up too.  The I2C subsystem only allows one binding to an I2C
> client address/name on a bus.  So without some new glue like a notional
> lirc_v4l, it *may* be hard to share between ir-kbd-i2c and lirc_i2c and
> lirc_zilog.

The better is to add the lirc glue at ir-common module. There, we have the support
functions used by all V4L devices, and they'll be expanded to cover also
dvb-usb, as soon as I can find some time to do a patch for it.

Cheers,
Mauro.
