Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56844 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936542AbcIHVhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/15] Fix another set of nitpick warnings
Date: Thu,  8 Sep 2016 18:37:26 -0300
Message-Id: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After this series, there are only 3 warnings left:

./include/media/media-entity.h:1053: warning: No description found for parameter '...'
./include/media/v4l2-mem2mem.h:339: WARNING: c:type reference target not found: queue_init
./include/media/v4l2-subdev.h:424: WARNING: c:type reference target not found: v4l2_sliced_vbi_line

The first two seems to be related to some kernel-doc parser issue.

The last one is actually a documentation error: the documentation is pointing to a
struct that doesn't exist! Probably, it got renamed during development.

I'll look into those three remaining issues likely tomorrow.

Mauro Carvalho Chehab (15):
  [media] mc-core.rst: fix a warning about an internal routine
  [media] v4l2-mem2mem.h: move descriptions from .c file
  [media] v4l2-mem2mem.h: document function arguments
  [media] v4l2-mem2mem.h: document the public structures
  [media] v4l2-mem2mem.h: make kernel-doc parse v4l2-mem2mem.h again
  [media] conf_nitpick.py: ignore an opaque struct from v4l2-mem2mem.h
  [media] videobuf2-core.h: move function descriptions from c file
  [media] videobuf2-core.h: document enum vb2_memory
  [media] videobuf2-core.h: improve documentation
  [media] conf_nitpick.py: ignore C domain data used on vb2
  [media] videobuf2-v4l2.h: get kernel-doc tags from C file
  [media] videobuf2-v4l2.h: improve documentation
  [media] videobuf2-v4l2: document two helper functions
  [media] v4l2-flash-led-class.h: document v4l2_flash_ops
  [media] v4l2-subdev: fix some references to v4l2_dev

 Documentation/media/conf_nitpick.py      |   8 +
 drivers/media/v4l2-core/v4l2-mem2mem.c   | 128 +----------
 drivers/media/v4l2-core/videobuf2-core.c | 254 ---------------------
 drivers/media/v4l2-core/videobuf2-v4l2.c | 142 ------------
 include/media/media-devnode.h            |   3 +-
 include/media/v4l2-flash-led-class.h     |  15 +-
 include/media/v4l2-mem2mem.h             | 262 ++++++++++++++++++++--
 include/media/v4l2-subdev.h              |   8 +-
 include/media/videobuf2-core.h           | 372 ++++++++++++++++++++++++++++---
 include/media/videobuf2-v4l2.h           | 182 ++++++++++++++-
 10 files changed, 791 insertions(+), 583 deletions(-)

-- 
2.7.4


