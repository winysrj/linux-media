Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:60909 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FYOtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 10:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQKjZNjjgG3hoKU2RLsG7w+B-2v7CpTT5hfnnTTJ2DgTEk0vA@mail.gmail.com>
References: <20130617182127.GM2718@n2100.arm.linux.org.uk>
	<007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
	<20130618084308.GU2718@n2100.arm.linux.org.uk>
	<008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
	<1371548849.4276.6.camel@weser.hi.pengutronix.de>
	<008601ce6cb0$2c8cec40$85a6c4c0$%dae@samsung.com>
	<1371637326.4230.24.camel@weser.hi.pengutronix.de>
	<00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com>
	<1371645247.4230.41.camel@weser.hi.pengutronix.de>
	<CAAQKjZNJD4HpnJQ7iE+Gez36066M6U0YQeUEdA0+UcSOKqeghg@mail.gmail.com>
	<20130619182925.GL2718@n2100.arm.linux.org.uk>
	<00da01ce6d81$76eb3d60$64c1b820$%dae@samsung.com>
	<1371714427.4230.64.camel@weser.hi.pengutronix.de>
	<00db01ce6d8f$a3c23dd0$eb46b970$%dae@samsung.com>
	<1371723063.4114.12.camel@weser.hi.pengutronix.de>
	<010801ce6da7$896affe0$9c40ffa0$%dae@samsung.com>
	<1371804843.4114.49.camel@weser.hi.pengutronix.de>
	<CAAQKjZOxOMuL3zh_yV7tU2LBcZ7oVryiKa+LgjTM5HLY+va8zQ@mail.gmail.com>
	<1371817628.5882.13.camel@weser.hi.pengutronix.de>
	<CAAQKjZOeskLB7n6FM+bnB8n7ecuQM5k6uANXJXo=xk979f9s9Q@mail.gmail.com>
	<CAH3drwZVhs=odjFdB_Mf+K0JLT5NSSbz5mP9aOS=5fx-PVdzSg@mail.gmail.com>
	<CAAQKjZNnJRddACHzD+VF=A8vJpt9SEy2ttnS3Kw0y3hexu8dnw@mail.gmail.com>
	<CAF6AEGsBvZbcWDbX3FFtyDxFO1NqYNRLqHEUyP4qUD9wK+ARbA@mail.gmail.com>
	<CAAQKjZNjjgG3hoKU2RLsG7w+B-2v7CpTT5hfnnTTJ2DgTEk0vA@mail.gmail.com>
Date: Tue, 25 Jun 2013 10:49:43 -0400
Message-ID: <CAH3drwYqwddVuFRjDbYyvs+2hVWxsQDC1X8OCXMJURRty2087Q@mail.gmail.com>
Subject: Re: [RFC PATCH] dmabuf-sync: Introduce buffer synchronization framework
From: Jerome Glisse <j.glisse@gmail.com>
To: Inki Dae <daeinki@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	YoungJun Cho <yj44.cho@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 25, 2013 at 10:17 AM, Inki Dae <daeinki@gmail.com> wrote:
> 2013/6/25 Rob Clark <robdclark@gmail.com>:
>> On Tue, Jun 25, 2013 at 5:09 AM, Inki Dae <daeinki@gmail.com> wrote:
>>>> that
>>>> should be the role of kernel memory management which of course needs
>>>> synchronization btw A and B. But in no case this should be done using
>>>> dma-buf. dma-buf is for sharing content btw different devices not
>>>> sharing resources.
>>>>
>>>
>>> hmm, is that true? And are you sure? Then how do you think about
>>> reservation? the reservation also uses dma-buf with same reason as long as I
>>> know: actually, we use reservation to use dma-buf. As you may know, a
>>> reservation object is allocated and initialized when a buffer object is
>>> exported to a dma buf.
>>
>> no, this is why the reservation object can be passed in when you
>> construction the dmabuf.
>
> Right, that way, we could use dma buf for buffer synchronization. I
> just wanted to ask for why Jerome said that "dma-buf is for sharing
> content btw different devices not sharing resources".

>From memory, the motivation of dma-buf was to done for few use case,
among them webcam capturing frame into a buffer and having gpu using
it directly without memcpy, or one big gpu rendering a scene into a
buffer that is then use by low power gpu for display ie it was done to
allow different device to operate on same data using same backing
memory.

AFAICT you seem to want to use dma-buf to create scratch buffer, ie a
process needs to use X amount of memory for an operation, it can
release|free this memory once its done and a process B can the use
this X memory for its own operation discarding content of process A. I
presume that next frame would have the sequence repeat, process A do
something, then process B does its thing. So to me it sounds like you
want to implement global scratch buffer using the dmabuf API and that
sounds bad to me.

I know most closed driver have several pool of memory, long lived
object, short lived object and scratch space, then user space allocate
from one of this pool and there is synchronization done by driver
using driver specific API to reclaim memory. Of course this work
nicely if you only talking about one logic block or at very least hw
that have one memory controller.

Now if you are thinking of doing scratch buffer for several different
device and share the memory among then you need to be aware of
security implication, most obvious being that you don't want process B
being able to read process A scratch memory. I know the argument about
it being graphic but one day this might become gpu code and it might
be able to insert jump to malicious gpu code.

Cheers,
Jerome
