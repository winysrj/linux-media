Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11828 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935431Ab0BZHhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 02:37:54 -0500
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KYF009UEUJ355@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Feb 2010 07:37:51 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KYF0091WUJ32R@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Feb 2010 07:37:51 +0000 (GMT)
Date: Fri, 26 Feb 2010 08:36:19 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: More videobuf and streaming I/O questions
In-reply-to: <201002260046.16878.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>
Message-id: <001b01cab6b6$631d05f0$295711d0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <201002201500.21118.hverkuil@xs4all.nl>
 <201002220012.20797.laurent.pinchart@ideasonboard.com>
 <000901cab45b$a8c55a10$fa500e30$%osciak@samsung.com>
 <201002260046.16878.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>On Tuesday 23 February 2010 08:41:49 Pawel Osciak wrote:
>> >On Mon, 22 Feb 2010 00:12:18 +0100
>> >Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> As for the REQBUF, I've always thought it'd be nice to be able to ask the
>> driver for the "recommended" number of buffers that should be used by
>> issuing a REQBUF with count=0...
>
>How would the driver come up with the number of recommended buffers ?

>From the top of my head: when encoding a video stream, a codec driver could
decide on the minimum number of input frames required (including reference
frames, etc.).

Or maybe I am missing something, what is your opinion on that?


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


