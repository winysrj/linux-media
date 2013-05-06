Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33638 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab3EFWpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 18:45:36 -0400
Received: by mail-lb0-f171.google.com with SMTP id u10so86537lbi.2
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 15:45:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF6AEGvV7dbUP7Cx65saEL8nUchGt5-fWgnsOq1RY3MQV25eJA@mail.gmail.com>
References: <1367382644-30788-1-git-send-email-airlied@gmail.com>
	<CAKMK7uGJWHb7so8_uNe0JzH_EUAQLExFPda=ZR+8yuG+ALvo2w@mail.gmail.com>
	<CAPM=9tzW-9U+ff2818asviXtm8+56-gp3NOFxy_u1m7b21TaQg@mail.gmail.com>
	<20130506155930.GG5763@phenom.ffwll.local>
	<CAPM=9txE51ZzPaX52rfqvvBp+=pwVe3fk=xE8p6qb79kJbQX=Q@mail.gmail.com>
	<CAKMK7uHBD3nGJU_xd1eX39Ee1ikojbp62AXZKAvB-wO1nyFqOg@mail.gmail.com>
	<CAF6AEGvV7dbUP7Cx65saEL8nUchGt5-fWgnsOq1RY3MQV25eJA@mail.gmail.com>
Date: Tue, 7 May 2013 08:45:34 +1000
Message-ID: <CAPM=9twx1bkcOTr3SySF2OTzO8Wp5YnDHEG_i-johkqBGmLPfg@mail.gmail.com>
Subject: Re: [PATCH] drm/udl: avoid swiotlb for imported vmap buffers.
From: Dave Airlie <airlied@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> One that appears the same as a GEM object created by userspace. i.e. mmap works.
>>
>> Oh, we have an mmap interface in the dma_buf thing for that, and iirc
>> Rob Clark even bothered to implement the gem->dma_buf mmap forwarding
>> somewhere. And iirc android's ion-on-dma_buf stuff is even using the
>> mmap interface stuff.
>
> fwiw, what I did was dma_buf -> gem mmap fwding, ie. implement mmap
> for the dmabuf object by fwd'ing it to my normal gem mmap code.  Might
> be the opposite of what you are looking for here.  Although I suppose
> the reverse could work to, I hadn't really thought about it yet.
>

Yeah thats the opposite, I want to implement my GEM mmap ioctls using
dma-buf mmaps :)

Dave.
