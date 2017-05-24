Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46708 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756155AbdEXAQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:16:58 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 00/17] rcar-vin: fix issues with format and capturing
Date: Wed, 24 May 2017 02:15:23 +0200
Message-Id: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Hi,

This series fix a number of issues for the rcar-vin driver regarding
format and capturing. It is based on top of '[GIT PULL FOR v4.13] V4L2 
fwnode support' and tested on Koelsch.

Parts of this series where previously part of '[PATCH 00/11] media:
rcar-vin: fix OPS and format/pad index issues'. But after good reviews
a large part of that series where dropped.

* Changes since v1
- Do not consider the lack of a subdevice sink pad an error instead
  default to use pad 0 in such case. This keeps the behavior of the
  driver which previous versions of this series changed.
- When printing pad numbers print using %u not %d as they are unsigned.
- Keep comment in code which was lost when moving code around.
- If trying to set an unsupported pixel format do not switch the current
  format, instead switch to the first supported format of the driver to
  achieve a more deterministic behaviour.
- Add new patch to remove redundant checks in the async bind/unbind
  callbacks.
- Clarify some commit messages, thanks Laurent!
- Fix typos in commit messages, thanks Sergei and Laurent!
- Add Reviewed-by tags from Lauren

Niklas Söderlund (17):
  rcar-vin: reset bytesperline and sizeimage when resetting format
  rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
  rcar-vin: fix how pads are handled for v4l2 subdevice operations
  rcar-vin: fix standard in input enumeration
  rcar-vin: move subdev source and sink pad index to rvin_graph_entity
  rcar-vin: refactor pad lookup code
  rcar-vin: move pad lookup to async bound handler
  rcar-vin: use pad information when verifying media bus format
  rcar-vin: decrease buffers needed to capture
  rcar-vin: move functions which acts on hardware
  rcar-vin: select capture mode based on free buffers
  rcar-vin: allow switch between capturing modes when stalling
  rcar-vin: refactor and fold in function after stall handling rework
  rcar-vin: remove subdevice matching from bind and unbind callbacks
  rcar-vin: register the video device at probe time
  rcar-vin: add missing error check to propagate error
  rcar-vin: fix bug in pixelformat selection

 drivers/media/platform/rcar-vin/rcar-core.c |  96 +++++++++---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 230 ++++++++++++++--------------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 139 ++++++-----------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  10 +-
 4 files changed, 248 insertions(+), 227 deletions(-)

-- 
2.13.0
