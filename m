Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbeJER1w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:27:52 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 0/3] Coding style cleanups after the fwnode patchset
Date: Fri,  5 Oct 2018 06:29:35 -0400
Message-Id: <cover.1538735151.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fwnode patchset added a several new warnings, as identified by
checkpatch.pl --strict.

Those are at the core stuff, and makes harder to review patches there.

In order to fully address checkpatch.pl, we still need to:

	- Add SPDX headers;
	- Rename functions.

Let's do those on some future change.

-

v2:
   - fixed a weird line break at patch 1/3;
   - kept the order of arguments inside a function at patch 3/3.

Mauro Carvalho Chehab (3):
  media: v4l2-core: cleanup coding style at V4L2 async/fwnode
  media: v4l2-fwnode: cleanup functions that parse endpoints
  media: v4l2-fwnode: simplify v4l2_fwnode_reference_parse_int_props()
    call

 drivers/media/v4l2-core/v4l2-async.c  |  45 +++---
 drivers/media/v4l2-core/v4l2-fwnode.c | 188 ++++++++++++++------------
 include/media/v4l2-async.h            |  12 +-
 include/media/v4l2-fwnode.h           |  45 +++---
 include/media/v4l2-mediabus.h         |  32 +++--
 5 files changed, 176 insertions(+), 146 deletions(-)

-- 
2.17.1
