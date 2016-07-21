Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46549 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbcGUMOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 08:14:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	laurent.pinchart@ideasonboard.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv2 0/2] vb2: check for valid device pointer
Date: Thu, 21 Jul 2016 14:14:01 +0200
Message-Id: <1469103243-5296-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make error handling of alloc, get_userptr and attach_dmabuf systematic.

Add tests to check for a valid non-NULL device pointer.

Regards,

	Hans

Changes since v1:

- Split into two patches
- Drop pr_debug

Hans Verkuil (2):
  vb2: don't return NULL for alloc and get_userptr ops
  vb2: add WARN_ONs checking if a valid struct device was passed

 drivers/media/v4l2-core/videobuf2-core.c       | 12 ++++++++----
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  9 +++++++++
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 19 +++++++++++++------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 13 ++++++++-----
 include/media/videobuf2-core.h                 |  6 +++---
 5 files changed, 41 insertions(+), 18 deletions(-)

-- 
2.8.1

