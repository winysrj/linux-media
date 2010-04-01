Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31688 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0DAM4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 08:56:00 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L0700I8L7XA24@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 13:55:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0700L2N7X5DA@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 13:55:58 +0100 (BST)
Date: Thu, 01 Apr 2010 14:53:54 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v3 1/2] v4l: Add memory-to-memory device helper framework
 for videobuf.
In-reply-to: 
To: Pawel Osciak <p.osciak@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, hvaibhav@ti.com
Message-id: <004401cad19a$630ee610$292cb230$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
 <1269848207-2325-2-git-send-email-p.osciak@samsung.com>
 <201004011106.51357.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Pawel Osciak [mailto:p.osciak@samsung.com] wrote:
>>> +unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>>> +			   struct poll_table_struct *wait)
>>> +{
>>> +	struct videobuf_queue *dst_q;
>>> +	struct videobuf_buffer *vb = NULL;
>>> +	unsigned int rc = 0;
>>> +
>>> +	dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
>>> +
>>> +	mutex_lock(&dst_q->vb_lock);
>>> +
>>> +	if (dst_q->streaming) {
>>> +		if (!list_empty(&dst_q->stream))
>>> +			vb = list_entry(dst_q->stream.next,
>>> +					struct videobuf_buffer, stream);
>>> +	}
>>> +
>>> +	if (!vb)
>>> +		rc = POLLERR;
>>> +
>>> +	if (0 == rc) {
>>> +		poll_wait(file, &vb->done, wait);
>>> +		if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
>>> +			rc = POLLOUT | POLLRDNORM;
>>> +	}
>>> +
>>> +	mutex_unlock(&dst_q->vb_lock);
>>
>>Would there be any need for polling for writing?
>
>Something has to be chosen, we could be polling for both of course, but in
>my opinion in case of m2m devices we are usually interested in the result
>of the operation. And in a great majority of cases (1:1 src:dst buffers) this
>will also mean src buffer is ready as well. Besides, the app can always simply
>sleep on dqbuf in one thread.
>

On second thought, we could set both and let the application use it as it sees
fit...



Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





