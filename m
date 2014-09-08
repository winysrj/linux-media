Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4123 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaIHOPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 10:15:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com
Subject: [RFC PATCH 00/12] vb2: improve dma-sg, expbuf.
Date: Mon,  8 Sep 2014 16:14:29 +0200
Message-Id: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch series adds an allocation context to dma-sg and uses that to move
dma_(un)map_sg into the vb2 framework, which is where it belongs.

Related to that is the addition of buf_prepare/finish _for_cpu variants,
where the _for_cpu ops are called when the buffer is synced for the cpu, and
the others are called when it is synced to the device.

DMABUF export support is added to dma-sg and vmalloc, so now all memory
models support DMABUF importing and exporting.

A new flag was added so drivers know when the DMA engine should be
(re)programmed. This is primarily needed for the dma-sg memory model.

Reviews are very welcome.

Regards,

	Hans

