Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47150 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbdCNTKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:10:08 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 00/16] rcar-vin: fix issues with format and capturing
Date: Tue, 14 Mar 2017 19:59:41 +0100
Message-Id: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series fix a number of issues for the rcar-vin driver regarding 
format and capturing. It is based on top of v4.11-rc1 and is tested on 
Koelsch.

Parts of this series where previously part of '[PATCH 00/11] media: 
rcar-vin: fix OPS and format/pad index issues'. But after good reviews 
a large part of that series where dropped.

Niklas Söderlund (16):
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
  rcar-vin: make use of video_device_alloc() and video_device_release()
  rcar-vin: add missing error check to propagate error
  rcar-vin: fix bug in pixelformat selection

 drivers/media/platform/rcar-vin/rcar-core.c |  33 +++-
 drivers/media/platform/rcar-vin/rcar-dma.c  | 229 ++++++++++++++--------------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 127 ++++++++-------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  11 +-
 4 files changed, 216 insertions(+), 184 deletions(-)

-- 
2.12.0
