Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbZLBTXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2009 14:23:12 -0500
Message-ID: <4B16BE6A.7000601@redhat.com>
Date: Wed, 02 Dec 2009 14:22:18 -0500
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>	 <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>	 <4B155288.1060509@redhat.com>	 <20091201175400.GA19259@core.coreip.homeip.net>	 <4B1567D8.7080007@redhat.com>	 <20091201201158.GA20335@core.coreip.homeip.net>	 <4B15852D.4050505@redhat.com>	 <20091202093803.GA8656@core.coreip.homeip.net>	 <4B16614A.3000208@redhat.com>	 <20091202171059.GC17839@core.coreip.homeip.net> <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
In-Reply-To: <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/2/09 12:30 PM, Jon Smirl wrote:
>>>> (for each remote/substream that they can recognize).
>>> >>
>>> >>  I'm assuming that, by remote, you're referring to a remote receiver (and not to
>>> >>  the remote itself), right?
>> >
>> >  If we could separate by remote transmitter that would be the best I
>> >  think, but I understand that it is rarely possible?
 >
> The code I posted using configfs did that. Instead of making apps IR
> aware it mapped the vendor/device/command triplets into standard Linux
> keycodes.  Each remote was its own evdev device.

Note, of course, that you can only do that iff each remote uses distinct 
triplets. A good portion of mythtv users use a universal of some sort, 
programmed to emulate another remote, such as the mce remote bundled 
with mceusb transceivers, or the imon remote bundled with most imon 
receivers. I do just that myself.

Personally, I've always considered the driver/interface to be the 
receiver, not the remote. The lirc drivers operate at the receiver 
level, anyway, and the distinction between different remotes is made by 
the lirc daemon.

> For IR to "just work" the irrecord training process needs be
> eliminated for 90% of users.

Pretty sure that's already the case. I have upwards of 20 remotes and 15 
receivers. I've had to run irrecord maybe two times in five years to get 
any of them working. The existing lirc remote database is fairly extensive.

-- 
Jarod Wilson
jarod@redhat.com
