Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab2IOQNg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 12:13:36 -0400
Date: Sat, 15 Sep 2012 13:13:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 9/9] videobuf2-core: Change vb2_queue_init return type
 to void
Message-ID: <20120915131333.11353e32@redhat.com>
In-Reply-To: <CALF0-+Uyp6mV1ho-tqeezaCZc6tfZTJsqw92_oD49_TgX2b1bQ@mail.gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
	<1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
	<20120825092814.4eee46f0@lwn.net>
	<CALF0-+VEGKL6zqFcqkw__qxuy+_3aDa-0u4xD63+Mc4FioM+aw@mail.gmail.com>
	<20120825113021.690440ba@lwn.net>
	<CALF0-+WjGYhHd4xshW9fOtdVp-Cgmz-7t8JzzoqMW-w0pNv85A@mail.gmail.com>
	<20120828105552.1e39b32b@lwn.net>
	<CALF0-+XhgNSjA_RMVK1VWkM=_oEh3JHitZNH55cCSn=AKK0N3Q@mail.gmail.com>
	<50547907.2050101@redhat.com>
	<CALF0-+Vx2eb4KJ4UoHts7R1ks4YsiUFHoqSixY-yd9bMV5VBeA@mail.gmail.com>
	<20120915103719.4f038ee0@redhat.com>
	<CALF0-+Vrf+t1eN+0LRGP4rBrrbSxrwTgkY1205v=7=5YQxsqWg@mail.gmail.com>
	<CALF0-+Uyp6mV1ho-tqeezaCZc6tfZTJsqw92_oD49_TgX2b1bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Sep 2012 12:22:48 -0300
Ezequiel Garcia <elezegarcia@gmail.com> escreveu:

> Mauro,
> 
> (Cc got messed up, so I'm sending this to you and media list)
> 
> On Sat, Sep 15, 2012 at 10:37 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em Sat, 15 Sep 2012 10:05:40 -0300
> > Ezequiel Garcia <elezegarcia@gmail.com> escreveu:
> >
> >> On Sat, Sep 15, 2012 at 9:48 AM, Mauro Carvalho Chehab
> >> <mchehab@redhat.com> wrote:
> >> > Em 28-08-2012 14:23, Ezequiel Garcia escreveu:
> >> >> Hi Jon,
> >> >>
> >> >> Thanks for your answers, I really appreciate it.
> >> >>
> >> >> On Tue, Aug 28, 2012 at 1:55 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> >> >>> On Sun, 26 Aug 2012 19:59:40 -0300
> >> >>> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> >> >>>
> >> >>>> 1.
> >> >>>> Why do we need to check for all these conditions in the first place?
> >> >>>> There are many other functions relying on "struct vb2_queue *q"
> >> >>>> not being null (almost all of them) and we don't check for it.
> >> >>>> What makes vb2_queue_init() so special that we need to check for it?
> >> >>>
> >> >>> There are plenty of developers who would argue for the removal of the
> >> >>> BUG_ON(!q) line regardless, since the kernel will quickly crash shortly
> >> >>> thereafter.  I'm a bit less convinced; there are attackers who are very
> >> >>> good at exploiting null pointer dereferences, and some systems still allow
> >> >>> the low part of the address space to be mapped.
> >> >>>
> >> >>> In general, IMO, checks for consistency make sense; it's nice if the
> >> >>> kernel can *tell* you that something is wrong.
> >> >>>
> >> >>> What's a mistake is the BUG_ON; that should really only be used in places
> >> >>> where things simply cannot continue.  In this case, the initialization can
> >> >>> be failed, the V4L2 device will likely be unavailable, but everything else
> >> >>> can continue as normal.  -EINVAL is the right response here.
> >> >>>
> >> >>
> >> >> I see your point.
> >> >>
> >> >> What I really can't seem to understand is why we should have a check
> >> >> at vb2_queue_init() but not at vb2_get_drv_priv(), just to pick one.
> >> >
> >> > Those BUG_ON() checks are there since likely the first version of VB1.
> >> > VB2 just inherited it.
> >> >
> >> > The think is that letting the VB code to run without checking for some
> >> > conditions is evil, as it could cause mass memory corruption, as the
> >> > videobuf code writes on a large amount of memory (typically, something
> >> > like 512MB written on every 1/30s). So, the code has protections, in order
> >> > to try avoiding it. Even so, with VB1, when the output buffer is at the
> >> > video adapter memory region (what is called PCI2PCI memory transfers),
> >> > there are known bugs with some chipsets that will cause mass data corruption
> >> > at the hard disks (as the PCI2PCI transfers interfere at the data transfers
> >> > from/to the disk, due to hardware bugs).
> >> >
> >> > Calling WARN_ON_ONCE() and returning some error code works, provided that
> >> > we enforce that the error code will be handled at the drivers that call
> >> > vb2_queue_init(), using something like __attribute__((warn_unused_result, nonnull))
> >> > and double_checking the code at VB2 callers.
> >> >
> >>
> >> So, you want me to resend?
> >
> > Yes, please.
> >
> 
> I can't decide on coding style. So, how about this?:
> 
> (copy pasted on gmail, sorry if spaces are mangled):
> 
>   */
>  int vb2_queue_init(struct vb2_queue *q)
>  {
> -       BUG_ON(!q);
> -       BUG_ON(!q->ops);
> -       BUG_ON(!q->mem_ops);
> -       BUG_ON(!q->type);
> -       BUG_ON(!q->io_modes);
> -
> -       BUG_ON(!q->ops->queue_setup);
> -       BUG_ON(!q->ops->buf_queue);
> +       /*
> +        * Sanity check
> +        */
> +       if (WARN_ON_ONCE(!q)            ||
> +           WARN_ON_ONCE(!q->ops)       ||
> +           WARN_ON_ONCE(!q->mem_ops)   ||
> +           WARN_ON_ONCE(!q->type)      ||
> +           WARN_ON_ONCE(!q->io_modes)  ||
> +           WARN_ON_ONCE(!q->ops->queue_setup) ||
> +           WARN_ON_ONCE(!q->ops->buf_queue))
> +               return -EINVAL;
> 
>         INIT_LIST_HEAD(&q->queued_list);
>         INIT_LIST_HEAD(&q->done_list);

It seems OK on my eyes.

-- 
Regards,
Mauro
