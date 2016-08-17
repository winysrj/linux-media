Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34849
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbcHQS3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 14:29:14 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] [media] vb2: defer part of vb2_buffer_done() and move dma-buf unmap from DQBUF
Date: Wed, 17 Aug 2016 14:28:55 -0400
Message-Id: <1471458537-16859-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series attempt to do the dma-buf unmap as soon as possible, once
the driver has finished using the buffer. Instead of waiting until DQBUF to
do the unmap.

Patch #1 splits vb2_buffer_done() and moves part of its logic to a workqueue
to avoid calling the vb2 .finish mem ops. Since doing a buffer sync can take
a lot of time so isn't suitable for interrupt context. This was suggested by
Hans Verkuil on a previous patch [0].

Patch #2 then moves the dma-buf unmap out of DQBUF to vb2_done_work() now that
this is executed in process context since the dmabuf unmap operation can sleep.

[0]: https://lkml.org/lkml/2016/8/13/36

Best regards,
Javier


Javier Martinez Canillas (2):
  [media] vb2: defer sync buffers from vb2_buffer_done() with a
    workqueue
  [media] vb2: move dma-buf unmap from __vb2_dqbuf() to vb2_done_work()

 drivers/media/v4l2-core/videobuf2-core.c | 114 ++++++++++++++++++++-----------
 include/media/videobuf2-core.h           |   5 ++
 2 files changed, 79 insertions(+), 40 deletions(-)

-- 
2.5.5

