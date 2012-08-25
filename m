Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:33814 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab2HYR3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 13:29:54 -0400
Date: Sat, 25 Aug 2012 11:30:21 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 9/9] videobuf2-core: Change vb2_queue_init return type
 to void
Message-ID: <20120825113021.690440ba@lwn.net>
In-Reply-To: <CALF0-+VEGKL6zqFcqkw__qxuy+_3aDa-0u4xD63+Mc4FioM+aw@mail.gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
	<1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
	<20120825092814.4eee46f0@lwn.net>
	<CALF0-+VEGKL6zqFcqkw__qxuy+_3aDa-0u4xD63+Mc4FioM+aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Aug 2012 13:12:01 -0300
Ezequiel Garcia <elezegarcia@gmail.com> wrote:

> The mentioned BUG_ON() are these:
> 
> void vb2_queue_init(struct vb2_queue *q)
> {
>         BUG_ON(!q);
>         BUG_ON(!q->ops);
>         BUG_ON(!q->mem_ops);
>         BUG_ON(!q->type);
>         BUG_ON(!q->io_modes);
> [...]
> 
> Unless I'm overlooking something they look fine to me,
> since vb2_queue should always be prepared  by the driver.

http://permalink.gmane.org/gmane.linux.kernel/1347333 is, I believe, the
definitive word on this kind of use of BUG_ON()...

jon
