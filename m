Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64672 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2H1RXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 13:23:07 -0400
Received: by wibhr14 with SMTP id hr14so5068241wib.1
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2012 10:23:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120828105552.1e39b32b@lwn.net>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
	<1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
	<20120825092814.4eee46f0@lwn.net>
	<CALF0-+VEGKL6zqFcqkw__qxuy+_3aDa-0u4xD63+Mc4FioM+aw@mail.gmail.com>
	<20120825113021.690440ba@lwn.net>
	<CALF0-+WjGYhHd4xshW9fOtdVp-Cgmz-7t8JzzoqMW-w0pNv85A@mail.gmail.com>
	<20120828105552.1e39b32b@lwn.net>
Date: Tue, 28 Aug 2012 14:23:05 -0300
Message-ID: <CALF0-+XhgNSjA_RMVK1VWkM=_oEh3JHitZNH55cCSn=AKK0N3Q@mail.gmail.com>
Subject: Re: [PATCH 9/9] videobuf2-core: Change vb2_queue_init return type to void
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

Thanks for your answers, I really appreciate it.

On Tue, Aug 28, 2012 at 1:55 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Sun, 26 Aug 2012 19:59:40 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>
>> 1.
>> Why do we need to check for all these conditions in the first place?
>> There are many other functions relying on "struct vb2_queue *q"
>> not being null (almost all of them) and we don't check for it.
>> What makes vb2_queue_init() so special that we need to check for it?
>
> There are plenty of developers who would argue for the removal of the
> BUG_ON(!q) line regardless, since the kernel will quickly crash shortly
> thereafter.  I'm a bit less convinced; there are attackers who are very
> good at exploiting null pointer dereferences, and some systems still allow
> the low part of the address space to be mapped.
>
> In general, IMO, checks for consistency make sense; it's nice if the
> kernel can *tell* you that something is wrong.
>
> What's a mistake is the BUG_ON; that should really only be used in places
> where things simply cannot continue.  In this case, the initialization can
> be failed, the V4L2 device will likely be unavailable, but everything else
> can continue as normal.  -EINVAL is the right response here.
>

I see your point.

What I really can't seem to understand is why we should have a check
at vb2_queue_init() but not at vb2_get_drv_priv(), just to pick one.

Thanks a lot!
Ezequiel.
