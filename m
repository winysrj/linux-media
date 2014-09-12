Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1032 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaILNA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 09:00:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [RFCv2 PATCH 00/14] vb2: improve dma-sg, expbuf
Date: Fri, 12 Sep 2014 14:59:49 +0200
Message-Id: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:

- Updated commit logs of patches 1 and 3.
- Added patches for tw68 and cx23885.

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

There is one thing I am not happy about: the addition of the 'new_cookies'
flag. The idea is that if it is set, then the driver has to setup the
DMA engine descriptors in buf_prepare(). This avoids creating the DMA
descriptors in every buf_prepare and deleting them again for every buf_finish.
The problem is that when using the new flag the cleanup of those descriptors
can't be done in buf_finish anymore since when that op is called you do not
yet know if the descriptors need to be updated. Instead the cleanup has to
happen in buf_cleanup(). The tw68 patch is a good example of that.

Unfortunately, this sequence is asymmetrical.

I cannot think of a good alternative. The only slight improvement that might
be worth doing is that the vb2 core also sets new_cookies when buf_cleanup()
needs to cleanup the descriptors. There is a corner case where buf_cleanup
doesn't need to do that (e.g. if buf_prepare returned an error), and right
now drivers need to detect that. It's probably better to move that logic
to the vb2 core.

Regards,

	Hans

