Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:60518 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZLHQ0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 11:26:10 -0500
MIME-Version: 1.0
In-Reply-To: <4B1E756D.2090908@redhat.com>
References: <20091204220708.GD25669@core.coreip.homeip.net>
	 <m3638k6lju.fsf@intrepid.localdomain>
	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <m3skbn6dv1.fsf@intrepid.localdomain>
	 <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
	 <4B1D934E.7030103@redhat.com> <m3hbs1vain.fsf@intrepid.localdomain>
	 <4B1E5DA3.7000206@redhat.com> <m3y6ldscut.fsf@intrepid.localdomain>
	 <4B1E756D.2090908@redhat.com>
Date: Tue, 8 Dec 2009 11:26:15 -0500
Message-ID: <9e4733910912080826h53db3049j9a75d490bcaebbd9@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
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

On Tue, Dec 8, 2009 at 10:49 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Krzysztof Halasa wrote:
>> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
>>
>>> If you use a kfifo to store the event (space_or_mark, timestamp),
>>> the IRQ handler can return immediately, and a separate kernel thread
>>> can do the decode without needing to touch at the IRQ.
>>
>> But the decoding itself is a really simple thing, why complicate it?
>> There is no need for the kernel thread if the handler is fast (and it
>> is).
>
> The decoding of just one protocol may be fast, but having several decoders
> serialized (without kthreads, you're serializing the decoders) will possibly
> not be that fast.
>
> Also, you don't need wake the decoders kthreads for every event, but wait

Just wake the default kthread on each event. If you wake the default
thread multiple times it is the same as waking it once.

The default kthread doesn't schedule very fast. If you get 120 events
and call wake 120 times, the thread is only going to visit your driver
one or two times not 120 times.

> for some number of events to happen before waking it. For example,
> 16 pulse/space events correspond to 8 bits of data on most protocols,
> so you can wake the kthread only after 16 events for really simple decoders,
> or if a timeout event is detected. The number of events to wake may be customized
> per decoder.
>
> Cheers,
> Mauro.
>



-- 
Jon Smirl
jonsmirl@gmail.com
