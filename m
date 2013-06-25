Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:39586 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3FYORz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 10:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAF6AEGsBvZbcWDbX3FFtyDxFO1NqYNRLqHEUyP4qUD9wK+ARbA@mail.gmail.com>
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
Date: Tue, 25 Jun 2013 23:17:53 +0900
Message-ID: <CAAQKjZNjjgG3hoKU2RLsG7w+B-2v7CpTT5hfnnTTJ2DgTEk0vA@mail.gmail.com>
Subject: Re: [RFC PATCH] dmabuf-sync: Introduce buffer synchronization framework
From: Inki Dae <daeinki@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Jerome Glisse <j.glisse@gmail.com>,
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

2013/6/25 Rob Clark <robdclark@gmail.com>:
> On Tue, Jun 25, 2013 at 5:09 AM, Inki Dae <daeinki@gmail.com> wrote:
>>> that
>>> should be the role of kernel memory management which of course needs
>>> synchronization btw A and B. But in no case this should be done using
>>> dma-buf. dma-buf is for sharing content btw different devices not
>>> sharing resources.
>>>
>>
>> hmm, is that true? And are you sure? Then how do you think about
>> reservation? the reservation also uses dma-buf with same reason as long as I
>> know: actually, we use reservation to use dma-buf. As you may know, a
>> reservation object is allocated and initialized when a buffer object is
>> exported to a dma buf.
>
> no, this is why the reservation object can be passed in when you
> construction the dmabuf.

Right, that way, we could use dma buf for buffer synchronization. I
just wanted to ask for why Jerome said that "dma-buf is for sharing
content btw different devices not sharing resources".

> The fallback is for dmabuf to create it's
> own, for compatibility and to make life easier for simple devices with
> few buffers... but I think pretty much all drm drivers would embed the
> reservation object in the gem buffer and pass it in when the dmabuf is
> created.
>
> It is pretty much imperative that synchronization works independently
> of dmabuf, you really don't want to have two different cases to deal
> with in your driver, one for synchronizing non-exported objects, and
> one for synchronizing dmabuf objects.
>

Now my approach is concentrating on the most basic implementation,
buffer synchronization mechanism between CPU and CPU, CPU and DMA, and
DMA and DMA.  But I think reserveration could be used for other
purposes such as pipe line synchronization independently of dmabuf as
you said. Actually, I had already implemented pipe line
synchronization mechanism using the reservation: in case of MALI-400
DDK, there was pipe line issue between gp and pp jobs, and we had
solved the issue using the pipe line synchronization mechanism with
the reservation. So, we could add more features anytime; those two
different cases, dmabuf objects and non-exported objects, if needed
because we are using the reservation object.

Thanks,
Inki Dae

> BR,
> -R
