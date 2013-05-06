Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:48741 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3EFWNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 18:13:09 -0400
Received: by mail-ia0-f182.google.com with SMTP id x30so3688354iaa.41
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 15:13:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHBD3nGJU_xd1eX39Ee1ikojbp62AXZKAvB-wO1nyFqOg@mail.gmail.com>
References: <1367382644-30788-1-git-send-email-airlied@gmail.com>
	<CAKMK7uGJWHb7so8_uNe0JzH_EUAQLExFPda=ZR+8yuG+ALvo2w@mail.gmail.com>
	<CAPM=9tzW-9U+ff2818asviXtm8+56-gp3NOFxy_u1m7b21TaQg@mail.gmail.com>
	<20130506155930.GG5763@phenom.ffwll.local>
	<CAPM=9txE51ZzPaX52rfqvvBp+=pwVe3fk=xE8p6qb79kJbQX=Q@mail.gmail.com>
	<CAKMK7uHBD3nGJU_xd1eX39Ee1ikojbp62AXZKAvB-wO1nyFqOg@mail.gmail.com>
Date: Mon, 6 May 2013 18:13:08 -0400
Message-ID: <CAF6AEGvV7dbUP7Cx65saEL8nUchGt5-fWgnsOq1RY3MQV25eJA@mail.gmail.com>
Subject: Re: [PATCH] drm/udl: avoid swiotlb for imported vmap buffers.
From: Rob Clark <robdclark@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 6, 2013 at 4:44 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Mon, May 6, 2013 at 9:56 PM, Dave Airlie <airlied@gmail.com> wrote:
>> On Tue, May 7, 2013 at 1:59 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
>>> On Mon, May 06, 2013 at 10:35:35AM +1000, Dave Airlie wrote:
>>>> >>
>>>> >> However if we don't set a dma mask on the usb device, the mapping
>>>> >> ends up using swiotlb on machines that have it enabled, which
>>>> >> is less than desireable.
>>>> >>
>>>> >> Signed-off-by: Dave Airlie <airlied@redhat.com>
>>>> >
>>>> > Fyi for everyone else who was not on irc when Dave&I discussed this:
>>>> > This really shouldn't be required and I think the real issue is that
>>>> > udl creates a dma_buf attachement (which is needed for device dma
>>>> > only), but only really wants to do cpu access through vmap/kmap. So
>>>> > not attached the device should be good enough. Cc'ing a few more lists
>>>> > for better fyi ;-)
>>>>
>>>> Though I've looked at this a bit more, and since I want to be able to expose
>>>> shared objects as proper GEM objects from the import side I really
>>>> need that list of pages.
>>>
>>> Hm, what does "proper GEM object" mean in the context of udl?
>>
>> One that appears the same as a GEM object created by userspace. i.e. mmap works.
>
> Oh, we have an mmap interface in the dma_buf thing for that, and iirc
> Rob Clark even bothered to implement the gem->dma_buf mmap forwarding
> somewhere. And iirc android's ion-on-dma_buf stuff is even using the
> mmap interface stuff.

fwiw, what I did was dma_buf -> gem mmap fwding, ie. implement mmap
for the dmabuf object by fwd'ing it to my normal gem mmap code.  Might
be the opposite of what you are looking for here.  Although I suppose
the reverse could work to, I hadn't really thought about it yet.

BR,
-R

> Now for prime "let's just ship this, dammit" prevailed for now. But I
> still think that hiding the backing storage a bit better (with the
> eventual goal of supporting eviction with Maarten's fence/ww_mutex
> madness) feels like a worthy long-term goal.
>
> Cheers, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
