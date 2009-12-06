Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:64412 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934223AbZLFVXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 16:23:46 -0500
MIME-Version: 1.0
In-Reply-To: <m3skbn6dv1.fsf@intrepid.localdomain>
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	 <1260070593.3236.6.camel@pc07.localdom.local>
	 <20091206065512.GA14651@core.coreip.homeip.net>
	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <m3skbn6dv1.fsf@intrepid.localdomain>
Date: Sun, 6 Dec 2009 16:23:51 -0500
Message-ID: <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 6, 2009 at 3:34 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Jon Smirl <jonsmirl@gmail.com> writes:
>
>>> Once again: how about agreement about the LIRC interface
>>> (kernel-userspace) and merging the actual LIRC code first? In-kernel
>>> decoding can wait a bit, it doesn't change any kernel-user interface.
>>
>> I'd like to see a semi-complete design for an in-kernel IR system
>> before anything is merged from any source.
>
> This is a way to nowhere, there is no logical dependency between LIRC
> and input layer IR.
>
> There is only one thing which needs attention before/when merging LIRC:
> the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
> actually, making a correct IR core design without the LIRC merged can be
> only harder.

Here's a few design review questions on the LIRC drivers that were posted....

How is the pulse data going to be communicated to user space?
Can the pulse data be reported via an existing interface without
creating a new one?
Where is the documentation for the protocol?
Is it a device interface or something else?
Does it work with poll, epoll, etc?
What is the time standard for the data, where does it come from?
How do you define the start and stop of sequences?
What about capabilities of the receiver, what frequencies?
If a receiver has multiple frequencies, how do you report what
frequency the data came in on?
What about multiple apps simultaneously using the pulse data?
Is receiving synchronous or queued?
How big is the receive queue?
How does access work, root only or any user?
What about transmit, how do you get pulse data into the device?
Transmitter frequencies?
Multiple transmitters?
Is transmitting synchronous or queued?
How big is the transmit queue?
How are capabilities exposed, sysfs, etc?
What is the interface for attaching an in-kernel decoder?
If there is an in-kernel decoder should the pulse data stop being
reported, partially stopped, something else?
What is the mechanism to make sure both system don't process the same pulses?

> --
> Krzysztof Halasa
>



-- 
Jon Smirl
jonsmirl@gmail.com
