Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56358 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0E3PcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 11:32:24 -0400
Message-ID: <4C0284FF.4080707@gmail.com>
Date: Sun, 30 May 2010 17:32:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
CC: Richard Zidlicky <rz@linux-m68k.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: schedule inside spin_lock_irqsave?
References: <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com>
In-Reply-To: <4C028336.8030704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2010 05:24 PM, Jiri Slaby wrote:
> struct smscore_buffer_t *get_entry(void)
> {
>   struct smscore_buffer_t *cb = NULL;
>   spin_lock_irqsave(&coredev->bufferslock, flags);
>   if (!list_empty(&coredev->buffers)) {
>     cb = (struct smscore_buffer_t *) coredev->buffers.next;

Looking at the smscore_buffer_t definition, this is really ugly since it
relies on entry being the first in the structure. It should be
list_first_entry(&coredev->buffers, ...) instead, cast-less.

>     list_del(&cb->entry);
>   }
>   spin_unlock_irqrestore(&coredev->bufferslock, flags);
>   return cb;
> }


-- 
js
