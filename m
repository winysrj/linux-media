Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725758AbeJEFJU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 01:09:20 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 0/3] Coding style cleanups after the fwnode patchset
Date: Thu,  4 Oct 2018 18:13:45 -0400
Message-Id: <cover.1538690587.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fwnode patchset added a several new warnings, as identified by
checkpatch.pl --strict.

Those are at the core stuff, and makes harder to review patches there.

The most irritating stuff there are functions like:

	some_very_long_function_that_has_a_very_comprehensive_name(
		...);

Functions ending with a "(" without arguments doesn't follow the
right coding style, and it is an heritage of the usage of "indent".

Ok, it sounds that the patches were actually trying to follow an existing
coding style inside it.

As we're about to close the media merge window, and the fwnode patches
already changed a lot of code there, before that becomes an habit to
follow its weird style, let's fix it.

After this series, all we have is the lack of SPDX inside the sources,
and some long lines (with is inevitable without renaming those kAPI
functions).

Btw, I was tempted to rename them, renaming functions like:

	v4l2_async_notifier_parse_fwnode_endpoints_by_port

to something like:
	v4l2_async_parse_fwnode_ep_by_port

or even:
	v4l2_parse_fwnode_ep_by_port

with is probably good enough, but, as this is part of the kAPI, I
opted to keep it as-is - for now.

Mauro Carvalho Chehab (3):
  media: v4l2-core: cleanup coding style at V4L2 async/fwnode
  media: v4l2-fwnode: cleanup functions that parse endpoints
  media: v4l2-fwnode: simplify v4l2_fwnode_reference_parse_int_props()
    call

 drivers/media/v4l2-core/v4l2-async.c  |  45 +++---
 drivers/media/v4l2-core/v4l2-fwnode.c | 190 ++++++++++++++------------
 include/media/v4l2-async.h            |  12 +-
 include/media/v4l2-fwnode.h           |  45 +++---
 include/media/v4l2-mediabus.h         |  32 +++--
 5 files changed, 177 insertions(+), 147 deletions(-)

-- 
2.17.1
