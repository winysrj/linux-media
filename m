Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbZLCLJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 06:09:50 -0500
Message-ID: <4B179C5A.2090504@redhat.com>
Date: Thu, 03 Dec 2009 09:09:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <4B155288.1060509@redhat.com>	 <20091202093803.GA8656@core.coreip.homeip.net>	 <4B16614A.3000208@redhat.com>	 <20091202171059.GC17839@core.coreip.homeip.net>	 <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>	 <4B16BE6A.7000601@redhat.com>	 <20091202195634.GB22689@core.coreip.homeip.net>	 <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>	 <9e4733910912021620s7a2b09a8v88dd45eef38835a@mail.gmail.com>	 <4B1720E6.3000802@redhat.com> <9e4733910912022108j71d0c27fh75dacfa79dca7c22@mail.gmail.com>
In-Reply-To: <9e4733910912022108j71d0c27fh75dacfa79dca7c22@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Wed, Dec 2, 2009 at 9:22 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Jon Smirl wrote:
>>> On Wed, Dec 2, 2009 at 3:04 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>>>> On Dec 2, 2009, at 2:56 PM, Dmitry Torokhov wrote:
>>>>
>>>>> On Wed, Dec 02, 2009 at 02:22:18PM -0500, Jarod Wilson wrote:
>>>>>> On 12/2/09 12:30 PM, Jon Smirl wrote:
>>>>>>>>>> (for each remote/substream that they can recognize).
>>>>>>>>>>> I'm assuming that, by remote, you're referring to a remote receiver (and not to
>>>>>>>>>>> the remote itself), right?
>>>>>>>>> If we could separate by remote transmitter that would be the best I
>>>>>>>>> think, but I understand that it is rarely possible?
>>>>>>> The code I posted using configfs did that. Instead of making apps IR
>>>>>>> aware it mapped the vendor/device/command triplets into standard Linux
>>>>>>> keycodes.  Each remote was its own evdev device.
>>>>>> Note, of course, that you can only do that iff each remote uses distinct
>>>>>> triplets. A good portion of mythtv users use a universal of some sort,
>>>>>> programmed to emulate another remote, such as the mce remote bundled
>>>>>> with mceusb transceivers, or the imon remote bundled with most imon
>>>>>> receivers. I do just that myself.
>>>>>>
>>>>>> Personally, I've always considered the driver/interface to be the
>>>>>> receiver, not the remote. The lirc drivers operate at the receiver
>>>>>> level, anyway, and the distinction between different remotes is made by
>>>>>> the lirc daemon.
>>>>> The fact that lirc does it this way does not necessarily mean it is the
>>>>> most corerct way.
>>>> No, I know that, I'm just saying that's how I've always looked at it, and that's how lirc does it right now, not that it must be that way.
>>>>
>>>>> Do you expect all bluetooth input devices be presented
>>>>> as a single blob just because they happen to talk to the sane receiver
>>>>> in yoru laptop? Do you expect your USB mouse and keyboard be merged
>>>>> together just because they end up being serviced by the same host
>>>>> controller? If not why remotes should be any different?
>>>> A bluetooth remote has a specific device ID that the receiver has to pair with. Your usb mouse and keyboard each have specific device IDs. A usb IR *receiver* has a specific device ID, the remotes do not. So there's the major difference from your examples.
>>> Actually remotes do have an ID. They all transmit vendor/device pairs
>>> which is exactly how USB works.
>>>
>> Well, the description of NEC and RC5 protocol at http://www.sbprojects.com/knowledge/ir/rc5.htm
>> doesn't mention any vendor/device pair, nor I'm able to get them with the IR hardware decoders
>> I have.
> 
> Some of the protocols were not intended to be multi-vendor  - the
> vendor is implicit in the protocol encoding. You don't have to split
> the IR codes into vendor/device/command triplets. I just do that
> because it is convenient to think of them that way. It is equally
> valid to treat them as a 64b integers and use four bits of the int to
> encode the protocol.  It should really be a quad
> protocol/vendor/device/command and some of the fields may be missing.
> Bottom line, you are looking for unique codes how the fields are split
> up doesn't really matter.

Currently, there aren't any in-kernel driver that support 64 bit IR's.
They support only up to 16 bits. So, we have only address (device)/command. 
As I said before, AFAIK, only RC6 mode 6 remotes support 64 bits. 

As pointed by Andy, it is risky to support such protocol in kernel,
since you won't be able to ship the kernel to countries where RC6 patents 
got accepted, or you would need.

> A fixed protocol receiver is more of a challenge. You have to figure
> out how to make a universal remote transmit device codes for a device
> you don't already own that is also encoded in the protocol your
> hardware supports. 
> There's nothing we can do about that problem in
> Linux, its a side effect of fixed protocol decode hardware. 

With hardware decoders, you're limited to the supported protocols, but yet,
you can use a different scancode than the one that comes with the shipped
device.

If you take a look, for example, at the NEC protocol decoder we have on
drivers/media/video/saa7134/saa7134-input.c [1], you'll see that the
tasklet (nec_task) holds CPU control up to 76.5 ms, in order to be able
to receive the entire sequence at the GPIO port. Fortunately, on the device
where this decoder is called (Avermedia M135A), we can trigger the start
of the IR code via IRQ.

[1]http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=blob;f=drivers/media/video/saa7134/saa7134-input.c;h=6e219c2db8419013ab3ced30470ad1c19431974a;hb=HEAD


In this specific decoder I've implemented it some time ago. I think
I tried first to get the pulse/space width using just IRQ without the tasklet,
but the lengths weren't precise enough for decoding. Also, if you have a bad
contact at the IR sensor connector, as it is directly connected to an IRQ pin,
you may end by hanging the machine, if the code is not carefully written.

I remember I had some bad time due to the bad contacts at the IR sensor
with the sample I had available for implementing that IR.

Btw, looking at that code, while it is not impossible to split the 
IR pulse/space measures from the NEC decoder itself, and make it generic
to support other protocols, it is not a trivial task, and may result on
a less stable driver. Without splitting the protocol decoder, even being
able to store raw pulse/space data on some fifo, the driver will still
limit the protocol for that board to NEC (there is a similar code for RC5
there also, using some generic functions [2]).

[2]http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=blob;f=drivers/media/common/ir-functions.c;h=16792a68a44951e1bc1c2cbb1c9da27a2b6b2722;hb=HEAD


The advantage of the NEC decoding approach on saa7134 is that you know for
sure how much time it is required to get the entire code. So, the code 
can easily abort the reception of a bad code. The disadvantage is that 
only one protocol can be decoded at the same time.

The same problem also happens with almost all in-kernel drivers: the decoders
for raw mode were constructed to work with just one pulse/space code at the
same time. A conversion into a generic code can happen, but it will require
several tests to be sure that they won't cause undesirable side-effects.

The advantage of hardware decoders is that you don't need to be polling the
IR serial port at a high rate, as you'll get directly the code. So, you'll
free the CPU to do something else.

> You're just going to have to start guessing devices in the remote until you
> find one that uses your fixed protocol and doesn't also activate the
> devices you own. We can put suggestions in the doc when working
> devices are discovered. With a universal receiver the problem is
> simpler, just pick a device you don't own - the encoding protocol
> doesn't matter. These are generic problems with IR that are the same
> no matter how things get implemented in Linux.

Yes, provided that we can successfully change the drivers to split decoders from
pulse/space counting.

Cheers,
Mauro.

