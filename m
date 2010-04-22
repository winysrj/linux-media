Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50137 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab0DVJlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 05:41:35 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L1900LB3UX7G5@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Apr 2010 10:41:33 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L19001EQUX7QK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Apr 2010 10:41:31 +0100 (BST)
Date: Thu, 22 Apr 2010 11:41:14 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH] v4l: videobuf: qbuf now uses relevant v4l2_buffer fields
 for OUTPUT types
In-reply-to: <201004221129.11164.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <001701cae1ff$f354ee20$d9feca60$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1271843067-23496-1-git-send-email-p.osciak@samsung.com>
 <201004221114.41737.laurent.pinchart@ideasonboard.com>
 <001501cae1fd$a9d2f230$fd78d690$%osciak@samsung.com>
 <201004221129.11164.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>On Thursday 22 April 2010 11:24:52 Pawel Osciak wrote:
>> >Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> >> According to the V4L2 specification, applications set bytesused, field
>> >> and timestamp fields of struct v4l2_buffer when the buffer is intended
>> >> for output and memory type is MMAP. This adds proper copying of those
>> >> values to videobuf_buffer so drivers can use them.
>> >
>> >Why only for the MMAP memory type ? Don't drivers need the information for
>> >USERPTR buffers as well ?
>>
>> It is only mentioned for the MMAP memory type:
>> http://linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html
>> #vidioc-qbuf although it would make sense to do this for USERPTR as well.
>> Maybe I am trying too hard to stay 100% faithful to the documentation, I
>> guess it should be corrected as well then?
>
>This wouldn't be the first time the spec is wrong :-) I'd like other people's
>opinion on this, but I think we should fix the spec and copy the values for
>both MMAP and USERPTR.

Yes, same here. Thanks for pointing that up. I really have to stop treating the
spec as it was somehow sacred :)

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





