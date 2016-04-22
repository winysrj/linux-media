Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58758 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbcDVIII (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 04:08:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4959E18021C
	for <linux-media@vger.kernel.org>; Fri, 22 Apr 2016 10:08:03 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Streaming I/O: proposal to expose MMAP/USERPTR/DMABUF
 capabilities with QUERYCAP
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <5719DBE3.3040707@xs4all.nl>
Date: Fri, 22 Apr 2016 10:08:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have always been unhappy with the fact that it is so hard to tell whether
the USERPTR and/or DMABUF modes are available with Streaming I/O. QUERYCAP
only tells you if Streaming I/O is available, but not in which flavors.

So I propose the following:

#define V4L2_CAP_STREAMING_MMAP V4L2_CAP_STREAMING
#define V4L2_CAP_STREAMING_USERPTR 0x08000000
#define V4L2_CAP_STREAMING_DMABUF  0x10000000

All drivers that currently support CAP_STREAMING also support MMAP. For userptr
and dmabuf support we add new caps. These can be set by the core if the driver
uses vb2 since the core can query the io_modes field of vb2_queue.

For the drivers that do not yet support vb2 we can add it manually.

I was considering making it a requirement that the MMAP streaming mode is
always present, but I don't know if that works once we get drivers that operate
on secure memory. So I won't do that for now.

Since we are looking at device caps anyway: can we just drop V4L2_CAP_ASYNCIO?
It's never been implemented, nor is it likely in the future. And we don't have
all that many bits left before we need to use one of the reserved fields for
additional capabilities.

Regards,

	Hans
