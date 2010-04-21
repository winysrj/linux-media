Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34715 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0DUJds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 05:33:48 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L1700AS7ZWAI8@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 10:33:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1700JYOZUOXN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 10:32:49 +0100 (BST)
Date: Wed, 21 Apr 2010 11:28:34 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v4 1/2] v4l: Add memory-to-memory device helper framework
 for videobuf.
In-reply-to: <19F8576C6E063C45BE387C64729E7394044E1EB2CA@dbde02.ent.ti.com>
To: "'Hiremath, Vaibhav'" <hvaibhav@ti.com>,
	linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <000e01cae135$039d7ed0$0ad87c70$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1271680218-32395-1-git-send-email-p.osciak@samsung.com>
 <1271680218-32395-2-git-send-email-p.osciak@samsung.com>
 <19F8576C6E063C45BE387C64729E7394044E1EB2CA@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

thanks for the review. My responses below.


> Hiremath, Vaibhav <hvaibhav@ti.com> wrote:
>
>> -----Original Message-----
>> From: Pawel Osciak [mailto:p.osciak@samsung.com]
>> Sent: Monday, April 19, 2010 6:00 PM
>> To: linux-media@vger.kernel.org
>> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
>> kyungmin.park@samsung.com; Hiremath, Vaibhav
>> Subject: [PATCH v4 1/2] v4l: Add memory-to-memory device helper framework
>> for videobuf.


>[Hiremath, Vaibhav] Add one line here.
>

Ok...

[snip]

>> +/**
>> + * v4l2_m2m_querybuf() - multi-queue-aware QUERYBUF multiplexer
>> + *
>> + * See v4l2_m2m_mmap() documentation for details.
>> + */
>> +int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>> +                   struct v4l2_buffer *buf)
>> +{
>> +     struct videobuf_queue *vq;
>> +     int ret;
>> +
>> +     vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
>> +     ret = videobuf_querybuf(vq, buf);
>> +
>> +     if (buf->memory == V4L2_MEMORY_MMAP
>> +         && vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>> +             buf->m.offset += DST_QUEUE_OFF_BASE;
>> +     }
>[Hiremath, Vaibhav] Don't you think we should check for ret value also here? Should it be something -
>
>if (!ret && buf->memory == V4L2_MEMORY_MMAP
>                        && vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>        buf->m.offset += DST_QUEUE_OFF_BASE;
>}
>

I think it should stay like this. The offset should never be different
depending on whether an error is being reported or not. The unmodified offset
could confuse userspace applications or even conflict with the other buffer
type (although in case of errors userspace should not be using those offsets
anyway).

[snip]

>> +/**
>> + * v4l2_m2m_dqbuf() - dequeue a source or destination buffer, depending on
>> + * the type
>> + */
>> +int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>> +                struct v4l2_buffer *buf)
>> +{
>> +     struct videobuf_queue *vq;
>> +
>> +     vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
>
>
>[Hiremath, Vaibhav] Does it make sense to check the return value here?
>

Well, videobuf does not check it either. I mean, it would be important if
there was a possibility that userspace passes malicious data. But a NULL
here would mean a driver error.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


