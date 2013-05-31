Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26645 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3EaIwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 04:52:25 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNN00M1EN9K9U90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 09:52:23 +0100 (BST)
Message-id: <51A864C5.4090703@samsung.com>
Date: Fri, 31 May 2013 10:52:21 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC PATCH v3] [media] mem2mem: add support for hardware buffered
 queue
References: <1369989199-20952-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1369989199-20952-1-git-send-email-p.zabel@pengutronix.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 05/31/2013 10:33 AM, Philipp Zabel wrote:
> +void v4l2_m2m_queue_set_buffered(struct vb2_queue *vq, bool buffered)

How about making it a 'static inline' function in include/media/v4l2-mem2mem.h
instead ?

> +{
> +	struct v4l2_m2m_queue_ctx *q_ctx = container_of(vq, struct v4l2_m2m_queue_ctx, q);
> +
> +	q_ctx->buffered = buffered;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_m2m_queue_set_buffered);


Also, I was wondering how do you handle now in the coda driver a situation
when, e.g. during normal stream decoding more than one buffer is produced
by the decoder from one compressed data buffer on its input side ?

Regards,
Sylwester

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
Samsung Electronics
