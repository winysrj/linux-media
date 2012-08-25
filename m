Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50822 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab2HYQMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 12:12:01 -0400
Received: by ialo24 with SMTP id o24so5397599ial.19
        for <linux-media@vger.kernel.org>; Sat, 25 Aug 2012 09:12:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120825092814.4eee46f0@lwn.net>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
	<1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
	<20120825092814.4eee46f0@lwn.net>
Date: Sat, 25 Aug 2012 13:12:01 -0300
Message-ID: <CALF0-+VEGKL6zqFcqkw__qxuy+_3aDa-0u4xD63+Mc4FioM+aw@mail.gmail.com>
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

(Ccing videobuf2 authors)

On Sat, Aug 25, 2012 at 12:28 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Sat, 25 Aug 2012 00:09:06 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>
>> -int vb2_queue_init(struct vb2_queue *q)
>> +void vb2_queue_init(struct vb2_queue *q)
>>  {
>>       BUG_ON(!q);
>>       BUG_ON(!q->ops);
>
> If this change goes through in this form, you can add my ack for the
> Marvell piece.  But I have to wonder...might it not be better to retain
> the return value and use it to return -EINVAL instead of the seven BUG_ON()
> calls found in that function?  It shouldn't be necessary to bring things
> down in this situation, and, who knows, one of those might just be turned
> into a DOS vector with some driver someday.
>

The mentioned BUG_ON() are these:

void vb2_queue_init(struct vb2_queue *q)
{
        BUG_ON(!q);
        BUG_ON(!q->ops);
        BUG_ON(!q->mem_ops);
        BUG_ON(!q->type);
        BUG_ON(!q->io_modes);
[...]

Unless I'm overlooking something they look fine to me,
since vb2_queue should always be prepared  by the driver.

On the other hand, it seems these BUG_ON are inherited from videobuf1
(see videobuf_queue_core_init).

Marek, Pawel: What do you think?

Thanks,
Ezequiel.
