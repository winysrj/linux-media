Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:33416 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab2HYP1r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 11:27:47 -0400
Date: Sat, 25 Aug 2012 09:28:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 9/9] videobuf2-core: Change vb2_queue_init return type
 to void
Message-ID: <20120825092814.4eee46f0@lwn.net>
In-Reply-To: <1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
	<1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Aug 2012 00:09:06 -0300
Ezequiel Garcia <elezegarcia@gmail.com> wrote:

> -int vb2_queue_init(struct vb2_queue *q)
> +void vb2_queue_init(struct vb2_queue *q)
>  {
>  	BUG_ON(!q);
>  	BUG_ON(!q->ops);

If this change goes through in this form, you can add my ack for the
Marvell piece.  But I have to wonder...might it not be better to retain
the return value and use it to return -EINVAL instead of the seven BUG_ON()
calls found in that function?  It shouldn't be necessary to bring things
down in this situation, and, who knows, one of those might just be turned
into a DOS vector with some driver someday.

jon
