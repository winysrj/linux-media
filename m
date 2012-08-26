Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49452 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2HZW7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 18:59:43 -0400
Received: by ialo24 with SMTP id o24so6950991ial.19
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2012 15:59:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120825113021.690440ba@lwn.net>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
	<1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
	<20120825092814.4eee46f0@lwn.net>
	<CALF0-+VEGKL6zqFcqkw__qxuy+_3aDa-0u4xD63+Mc4FioM+aw@mail.gmail.com>
	<20120825113021.690440ba@lwn.net>
Date: Sun, 26 Aug 2012 19:59:40 -0300
Message-ID: <CALF0-+WjGYhHd4xshW9fOtdVp-Cgmz-7t8JzzoqMW-w0pNv85A@mail.gmail.com>
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

On Sat, Aug 25, 2012 at 2:30 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Sat, 25 Aug 2012 13:12:01 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>
>> The mentioned BUG_ON() are these:
>>
>> void vb2_queue_init(struct vb2_queue *q)
>> {
>>         BUG_ON(!q);
>>         BUG_ON(!q->ops);
>>         BUG_ON(!q->mem_ops);
>>         BUG_ON(!q->type);
>>         BUG_ON(!q->io_modes);
>> [...]
>>
>> Unless I'm overlooking something they look fine to me,
>> since vb2_queue should always be prepared  by the driver.
>
> http://permalink.gmane.org/gmane.linux.kernel/1347333 is, I believe, the
> definitive word on this kind of use of BUG_ON()...
>

As usual Linus's words are truly enlightening.

Perhaps you could help me understand this better:

1.
Why do we need to check for all these conditions in the first place?
There are many other functions relying on "struct vb2_queue *q"
not being null (almost all of them) and we don't check for it.
What makes vb2_queue_init() so special that we need to check for it?

2.
If a DoS attack is the concern here, I wonder how this would be achieved?
vb2_queue_init() is an "internal" (so to speak) function, that will only
be called by videobuf2 drivers.

I'm not arguing, truly. I wan't to understand what's the rationale behind
putting BUG_ON, or WARN_ON, or return -EINVAL in a case like this.

Thanks,
Ezequiel.
