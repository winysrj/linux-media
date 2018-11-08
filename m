Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14947 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbeKHVjj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 16:39:39 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH v3.16 0/2] V4L2 event subscription fixes
Date: Thu,  8 Nov 2018 14:03:48 +0200
Message-Id: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

The two patches fix a use-after-free issue in V4L2 event handling. The
first patch that fixes that issue is already in the other stable trees (as
well as Linus's tree) whereas the second that fixes a bug in the first
one, is in the media tree only as of yet.

<URL:https://git.linuxtv.org/media_tree.git/commit/?id=92539d3eda2c090b382699bbb896d4b54e9bdece>

Sakari Ailus (2):
  v4l: event: Prevent freeing event subscriptions while accessed
  v4l: event: Add subscription to list before calling "add" operation

 drivers/media/v4l2-core/v4l2-event.c | 63 ++++++++++++++++++++----------------
 drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
 include/media/v4l2-fh.h              |  1 +
 3 files changed, 38 insertions(+), 28 deletions(-)

-- 
2.11.0
