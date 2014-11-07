Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42166 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbaKGIum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 03:50:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com
Subject: [RFCv5 PATCH 00/15] vb2: improve dma-sg, expbuf
Date: Fri,  7 Nov 2014 09:50:19 +0100
Message-Id: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v4:
- Rebased to latest media_tree master

Changes since v3:

- Dropped patch 02/10: succeeded by patch 10/15 in this series
- Added patches 11-15 to correctly handle syncing/mapping dmabuf
  buffers for CPU access. This was never done correctly before.
  Many thanks to Pawel Osciak for helping me with this during the
  media mini-summit last week.

The patch series adds an allocation context to dma-sg and uses that to move
dma_(un)map_sg into the vb2 framework, which is where it belongs.

Some drivers needs to fixup the buffers before giving it back to userspace
(or before handing it over to the kernel). Document that this can be done
in buf_prepare and buf_finish.

The last 5 patches make this more strict by requiring all cpu access to
be bracketed by calls to vb2_plane_begin/end_cpu_access() which replaces
the old vb2_plane_vaddr() call.

Note: two drivers still use the vb2_plane_addr() call: coda and
exynos4-is/fimc-capture.c. For both drivers I will need some help since
I am not sure where to put the begin/end calls. Patch 14 removes
the vb2_plane_vaddr call, so obviously those two drivers won't compile
after that.

DMABUF export support is added to dma-sg and vmalloc, so now all memory
models support DMABUF importing and exporting.

I am inclined to make a pull request for patches 1-10 if there are no
new comments. The issues that patches 11-15 address are separate from
the patches 1-10 and this is only an issue when using dmabuf with
drivers that need cpu access.

Reviews are very welcome.

Regards,

	Hans

