Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34118 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0BWHnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 02:43:23 -0500
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KYA00LRZAS90E@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Feb 2010 07:43:21 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KYA008UCAS8HR@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Feb 2010 07:43:21 +0000 (GMT)
Date: Tue, 23 Feb 2010 08:41:49 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: More videobuf and streaming I/O questions
In-reply-to: <201002220012.20797.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>
Message-id: <000901cab45b$a8c55a10$fa500e30$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <201002201500.21118.hverkuil@xs4all.nl>
 <201002220012.20797.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

>On Mon, 22 Feb 2010 00:12:18 +0100
>Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> On Saturday 20 February 2010 15:00:21 Hans Verkuil wrote:
>> > 1) The spec mentions that the memory field should be set for
>> > VIDIOC_DQBUF. But videobuf doesn't need it and it makes no sense to
>> > me either unless it is for symmetry with VIDIOC_QBUF. Strictly
>> > speaking QBUF doesn't need it either, but it is a good sanity check.
>> >
>> > Can I remove the statement in the spec that memory should be set
>> > for DQBUF? The alternative is to add a check against the memory
>> > field in videobuf, but that's rather scary.
>>
>> In that case I would remove it for QBUF as well, and state that the
>> memory field must be ignored by drivers (but should they fill it when
>> returning from QBUF/DQBUF ?)
>
>Agree. It seems that the memory field is not useful at all in the struct
>v4l2_buffer if a same process does reqbuf, qbuf, dqbuf and querybuf.

In the current multi-plane buffer proposal, the memory field is required
in querybuf, qbuf and dqbuf for the v4l2-ioctl.c code to be able to
determine whether the planes array should be copied from/to user along
with the buffer.
Just wanted to add another view to the problem, as multiplanes are accepted
yet of course.


As for the REQBUF, I've always thought it'd be nice to be able to ask the
driver for the "recommended" number of buffers that should be used by
issuing a REQBUF with count=0...


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


