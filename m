Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42787 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbaKJMti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 07:49:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com
Subject: [RFCv6 PATCH 00/16] vb2: improve dma-sg, expbuf
Date: Mon, 10 Nov 2014 13:49:15 +0100
Message-Id: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v5:
- Moved 'replace write by dma_dir' to the beginning of the patch series.
- Split off the 'add dma_dir to alloc()' as a separate patch.
- Address all Pawel's review comments.

The patch series adds an allocation context to dma-sg and uses that to move
dma_(un)map_sg into the vb2 framework, which is where it belongs.

Some drivers needs to fixup the buffers before giving it back to userspace
(or before handing it over to the kernel). Document that this can be done
in buf_prepare and buf_finish.

The last 5 patches make this more strict by requiring all cpu access to
be bracketed by calls to vb2_plane_begin/end_cpu_access() which replaces
the old vb2_plane_vaddr() call.

Note: two drivers still use the vb2_plane_vaddr() call: coda and
exynos4-is/fimc-capture.c. For both drivers I will need some help since
I am not sure where to put the begin/end calls. Patch 15 removes
the vb2_plane_vaddr call, so obviously those two drivers won't compile
after that.

DMABUF export support is added to dma-sg and vmalloc, so now all memory
models support DMABUF importing and exporting.

I am inclined to make a pull request for patches 1-11 if there are no
new comments. The issues that patches 12-16 address are separate from
the patches 1-11 and this is only an issue when using dmabuf with
drivers that need cpu access.

Reviews are very welcome.

Regards,

	Hans

