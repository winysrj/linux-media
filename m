Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9222 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0DVG7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 02:59:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L1900FGZNFRBK30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Apr 2010 07:59:51 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1900FFZNFR72@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Apr 2010 07:59:51 +0100 (BST)
Date: Thu, 22 Apr 2010 08:59:34 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v1 1/2] v4l: videobuf: Add support for out-of-order buffer
 dequeuing.
In-reply-to: <1271866235-14370-2-git-send-email-p.osciak@samsung.com>
To: Pawel Osciak <p.osciak@samsung.com>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <000601cae1e9$5dbf7b20$193e7160$%osciak@samsung.com>
Content-language: pl
References: <1271866235-14370-1-git-send-email-p.osciak@samsung.com>
 <1271866235-14370-2-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Responding to my own e-mail here, but I just realized one little thing.


>Pawel Osciak <p.osciak@samsung.com> wrote:

[snip]

>+void videobuf_buf_finish(struct videobuf_queue *q, struct videobuf_buffer *vb)
>+{
>+	unsigned long flags;
>+
>+	spin_lock_irqsave(&q->vb_done_lock, flags);
>+	list_add_tail(&vb->done_list, &q->vb_done_list);
>+	spin_unlock_irqrestore(&q->vb_done_lock, flags);
>+
>+	spin_lock_irqsave(q->irqlock, flags);
>+	wake_up(&vb->done);
>+	wake_up_interruptible(&q->vb_done_wait);
>+	spin_unlock_irqrestore(q->irqlock, flags);
>+}
>+EXPORT_SYMBOL_GPL(videobuf_buf_finish);


There is a slight problem here if this function is not called from an interrupt
context (which is the case usually though). irqlock is not held for a period of
time and vb could potentially become NULL. So a recheck against vb == NULL is
required; alternatively the function could be called by driver while holding
the irqlock the whole time. So not really a problem, just a thing to point out.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


