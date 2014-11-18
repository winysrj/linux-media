Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:48829 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbaKRMv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 07:51:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com
Subject: [REVIEWv7 PATCH 00/12] vb2: improve dma-sg, expbuf
Date: Tue, 18 Nov 2014 13:50:56 +0100
Message-Id: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since RFCv6:

- Dropped patches 12-16/16: introducing begin/end_cpu_access functions
  is not yet ready for upstreaming.
- Incorporated Pawel's review comments except for his comment regarding
  the use of 'if (!IS_ERR_OR_NULL(alloc_ctx))' in vb2_dma_sg_cleanup_ctx().
  I rather like it (it's more robust for one thing) and actually added a
  patch to do the same for vb2_dma_contig_cleanup_ctx(). If this really
  runs into resistance, then I can remove it again.

The patch series adds an allocation context to dma-sg and uses that to move
dma_(un)map_sg into the vb2 framework, which is where it belongs.

Some drivers needs to fixup the buffers before giving it back to userspace
(or before handing it over to the kernel). Document that this can be done
in buf_prepare and buf_finish.

DMABUF export support is added to dma-sg and vmalloc, so now all memory
models support DMABUF importing and exporting.

I'm planning to make a pull request on Friday if there are no more comments.

Regards,

	Hans

