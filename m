Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43912 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752598AbdHNKbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 06:31:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/2] [PATCH 0/2] Bugfix for the fwnode smatch warning fix
Date: Mon, 14 Aug 2017 13:31:35 +0300
Message-Id: <20170814103137.17882-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here's a few patches to address a subtle but serious bug introduced in the
fwnode smatch warning fix. The first patch fixes a bug whereas the second
one returns the way the lane polarity array size is calculatated consistent
across V4L2 fwnode.

Sakari Ailus (2):
  v4l: fwnode: Fix lane-polarities property parsing
  v4l: fwnode: The clock lane is the first lane in lane_polarities

 drivers/media/v4l2-core/v4l2-fwnode.c | 12 ++++++++----
 include/media/v4l2-fwnode.h           |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.11.0
