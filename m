Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1336 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaJKJWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Oct 2014 05:22:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [RFCv3 PATCH 00/10] vb2: improve dma-sg, expbuf
Date: Sat, 11 Oct 2014 11:22:27 +0200
Message-Id: <1413019357-12382-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v2:

- Dropped buf_prepare/finish_for_cpu: buf_prepare/finish are already
  suitable for CPU access (but see discussion on dmabuf imports below)
- Moved dma_map_sg to buf_init as suggested by Laurent and others. This
  made it possible to drop the whole 'new_cookies' handling that I had
  in v1. Much better this way.
- Updated to latest linuxtv master.

The patch series adds an allocation context to dma-sg and uses that to move
dma_(un)map_sg into the vb2 framework, which is where it belongs.

Some drivers needs to fixup the buffers before giving it back to userspace
(or before handing it over to the kernel). Document that this can be done
in buf_prepare and buf_finish.

Note however that is does not work for DMABUF imports. This is a problem
today as well. Pawel, I would like to discuss this on Wednesday in more
detail. I don't entirely understand what is going on here or what the
right solution is.

DMABUF export support is added to dma-sg and vmalloc, so now all memory
models support DMABUF importing and exporting.

Reviews are very welcome.

Regards,

	Hans

