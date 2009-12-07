Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935324AbZLGXoc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 18:44:32 -0500
Message-ID: <4B1D934E.7030103@redhat.com>
Date: Mon, 07 Dec 2009 21:44:14 -0200
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
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>	 <1260070593.3236.6.camel@pc07.localdom.local>	 <20091206065512.GA14651@core.coreip.homeip.net>	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	 <m3skbn6dv1.fsf@intrepid.localdomain> <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
In-Reply-To: <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let me add my view for those questions.

Jon Smirl wrote:
> On Sun, Dec 6, 2009 at 3:34 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
>> Jon Smirl <jonsmirl@gmail.com> writes:
>>
>>>> Once again: how about agreement about the LIRC interface
>>>> (kernel-userspace) and merging the actual LIRC code first? In-kernel
>>>> decoding can wait a bit, it doesn't change any kernel-user interface.
>>> I'd like to see a semi-complete design for an in-kernel IR system
>>> before anything is merged from any source.
>> This is a way to nowhere, there is no logical dependency between LIRC
>> and input layer IR.
>>
>> There is only one thing which needs attention before/when merging LIRC:
>> the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
>> actually, making a correct IR core design without the LIRC merged can be
>> only harder.
> 
> Here's a few design review questions on the LIRC drivers that were posted....
> 
> How is the pulse data going to be communicated to user space?

lirc_dev will implement a revised version of the lirc API. I'm assuming that
Jerod and Christoph will do this review, in order to be sure that it is stable
enough for kernel inclusion (as proposed by Gerd).

> Can the pulse data be reported via an existing interface without
> creating a new one?

Raw pulse data should be reported only via lirc_dev, but it can be converted
into a keycode and reported via evdev as well, via an existing interface.

> Where is the documentation for the protocol?

I'm not sure what you're meaning here. I've started a doc about IR at the media
docbook. This is currently inside the kernel Documents/DocBook. If you want
to browse, it is also available as:

	http://linuxtv.org/downloads/v4l-dvb-apis/ch17.html

For sure we need to better document the IR's, and explain the API's there.

> Is it a device interface or something else?

lirc_dev should create a device interface.

> What about capabilities of the receiver, what frequencies?
> If a receiver has multiple frequencies, how do you report what
> frequency the data came in on?

IMO, via sysfs.

> What about multiple apps simultaneously using the pulse data?

IMO, the better is to limit the raw interface to just one open.

> How big is the receive queue?

It should be big enough to receive at least one keycode event. Considering that
the driver will use kfifo (IMO, it is a good strategy, especially since you
won't need any lock if just one open is allowed), it will require a power of two size.

> How does access work, root only or any user?

IMO, it should be the same requirement as used by an input interface.

> How are capabilities exposed, sysfs, etc?

IMO, sysfs.

> What is the interface for attaching an in-kernel decoder?

IMO, it should use the kfifo for it. However, if we allow both raw data and
in-kernel decoders to read data there, we'll need a spinlock to protect the
kfifo.

> If there is an in-kernel decoder should the pulse data stop being
> reported, partially stopped, something else?

I don't have a strong opinion here, but, from the previous discussions, it
seems that people want it to be double-reported by default. If so, I think
we need to implement a command at the raw interface to allow disabling the
in-kernel decoder, while the raw interface is kept open.

> What is the mechanism to make sure both system don't process the same pulses?

I don't see a good way to avoid it.

> Does it work with poll, epoll, etc?
> What is the time standard for the data, where does it come from?
> How do you define the start and stop of sequences?
> Is receiving synchronous or queued?
> What about transmit, how do you get pulse data into the device?
> Transmitter frequencies?
> Multiple transmitters?
> Is transmitting synchronous or queued?
> How big is the transmit queue?

I don't have a clear answer for those. I'll let those to LIRC developers to answer.


Cheers,
Mauro


