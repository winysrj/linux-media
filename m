Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:57619 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbbIKLw1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 07:52:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	sumit.semwal@linaro.org, robdclark@gmail.com,
	daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC RESEND 00/11] vb2: Handle user cache hints, allow drivers to choose cache coherency                                                           
Date: Fri, 11 Sep 2015 14:50:23 +0300
Message-Id: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This RFC patchset achieves two main objectives:

1. Respects cache flags passed from the user space. As no driver nor
videobuf2 has (ever?) implemented them, the two flags are replaced by a
single one (V4L2_BUF_FLAG_NO_CACHE_SYNC) and the two old flags are
deprecated. This is done since a single flag provides the driver with
enough information on what to do. (See more info in patch 4.)

2. Allows a driver using videobuf2 dma-contig memory type to choose
whether it prefers coherent or non-coherent CPU access to buffer memory
for MMAP and USERPTR buffers. This could be later extended to be specified
by the user, and per buffer if needed.

Only dma-contig memory type is changed but the same could be done to
dma-sg as well. I can add it to the set if people are happy with the
changes to dma-contig.

-- 
Kind regards,
Sakari

