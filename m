Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbZLHLSC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 06:18:02 -0500
Message-ID: <4B1E35D6.6000602@redhat.com>
Date: Tue, 08 Dec 2009 09:17:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <20091204220708.GD25669@core.coreip.homeip.net>	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>	 <1260070593.3236.6.camel@pc07.localdom.local>	 <20091206065512.GA14651@core.coreip.homeip.net>	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	 <m3skbn6dv1.fsf@intrepid.localdomain>	 <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>	 <4B1D934E.7030103@redhat.com> <9e4733910912071628x3f3eba82r4c964982f9d8c5a4@mail.gmail.com>
In-Reply-To: <9e4733910912071628x3f3eba82r4c964982f9d8c5a4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Mon, Dec 7, 2009 at 6:44 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:

>>> Where is the documentation for the protocol?
>> I'm not sure what you're meaning here. I've started a doc about IR at the media
> 
> What is the format of the pulse stream data coming out of the lirc device?

AFAIK, it is at:
	http://www.lirc.org/html/index.html

It would be nice to to add it to DocBook after integrating the API in kernel.

>> docbook. This is currently inside the kernel Documents/DocBook. If you want
>> to browse, it is also available as:
>>
>>        http://linuxtv.org/downloads/v4l-dvb-apis/ch17.html
>>
>> For sure we need to better document the IR's, and explain the API's there.
>>
>>> Is it a device interface or something else?
>> lirc_dev should create a device interface.
>>
>>> What about capabilities of the receiver, what frequencies?
>>> If a receiver has multiple frequencies, how do you report what
>>> frequency the data came in on?
>> IMO, via sysfs.
> 
> Say you have a hardware device with two IR diodes, one at 38K and one
> at 56K. Both of these receivers can get pulses. How do we tell the
> user space app which frequency the pulses were received on? Seems to
> me like there has to be a header on the pulse data indicating the
> received carrier frequency. There is also baseband signaling. sysfs
> won't work for this because of the queuing latency.

Simply create two interfaces. One for each IR receiver. At sysfs, you'll
have /sys/class/irrcv/irrcv0 for the first one and /sys/class/irrcv/irrcv1.
> 
> How is over-run signaled to the app? You'd get an over-run if the app
> is too slow at reading the data out of the FIFO. If you ignore
> over-run you'll be processing bad data because part of the message was
> lost. An over-run signal tell the abort to abort the signal and start
> over.

The API should provide that info. Maybe it is already solved.

>>> What about multiple apps simultaneously using the pulse data?
>> IMO, the better is to limit the raw interface to just one open.
>>
>>> How big is the receive queue?
>> It should be big enough to receive at least one keycode event. Considering that
>> the driver will use kfifo (IMO, it is a good strategy, especially since you
>> won't need any lock if just one open is allowed), it will require a power of two size.
> 
> How is end of a pulse train detected? timeout? without decoding the
> protocol there is no way to tell the end of signal other than timeout.

The API should provide that info. Provided that lirc works, I'm assuming that
this is already solved.

>>> How does access work, root only or any user?
>> IMO, it should be the same requirement as used by an input interface.
>>
>>> How are capabilities exposed, sysfs, etc?
>> IMO, sysfs.
>>
>>> What is the interface for attaching an in-kernel decoder?
>> IMO, it should use the kfifo for it. However, if we allow both raw data and
>> in-kernel decoders to read data there, we'll need a spinlock to protect the
>> kfifo.
>>
>>> If there is an in-kernel decoder should the pulse data stop being
>>> reported, partially stopped, something else?
>> I don't have a strong opinion here, but, from the previous discussions, it
>> seems that people want it to be double-reported by default. If so, I think
>> we need to implement a command at the raw interface to allow disabling the
>> in-kernel decoder, while the raw interface is kept open.
> 
> Data could be sent to the in-kernel decoders first and then if they
> don't handle it, send it to user space.

Hmm... like adding a delay if the raw userspace is open and, if the raw userspace
doesn't read all pulse data, it will send via in-kernel decoder instead? This can
work, but I'm not sure if this is the better way, and will require some logic to
synchronize lirc_dev and IR core modules. Also, doing it key by key will introduce
some delay.

If you're afraid of having the userspace app hanged and having no IR output, 
it would be simpler to just close the raw interface if an available data won't be
read after a bigger timeout (3 seconds? 5 seconds?).

Cheers,
Mauro.
