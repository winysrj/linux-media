Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:54246 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbcHOPHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:07:17 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 00/10] rcar-vin: clean up and prepare for Gen3
Date: Mon, 15 Aug 2016 17:06:25 +0200
Message-Id: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series cleans up issues that have been found in the driver and 
prepares it for Gen3 support. The series is based on v4.8-rc1 and is 
tested om Koelsch. The most noteworthy fix in in the series is patch 
9/10 that fixes a of_node_put() warning during loading of the driver.

The series is the first cleanup series but all patches are marked as v3 
since they have been broken out of the Gen3 enablement series which have 
been stuck for a while. Hopefully these cleanups can be picked up and 
then I can rebase and repost all other pending rcar-vin patches ontop of 
this clean up. The changlog from the Gen3 enablement branch is however 
kept here for reference.

Changes since v2:
- Drop all Gen3 enablement patches.
- Split a large cosmetic cleanup patch in smaller ones.
- Fix comment from Sergei about return code from platform_get_irq().
- Rebase ontop of v4.8-rc1

Changes since v1:
- Address review comments from Laurent.
- Split cleanup of driver to smaller chunks.
- Remove initial work for v4l2 framework changes to support a pad aware
s_stream operation.
- Picked up patch for incorrect media bus format.
- Removed Ulrich patches which now have been picked up in media_tree.

Niklas Söderlund (10):
  [media] rcar-vin: fix indentation errors in rcar-v4l2.c
  [media] rcar-vin: reduce indentation in rvin_s_dv_timings()
  [media] rcar-vin: arrange enum chip_id in chronological order
  [media] rcar-vin: rename entity to digital
  [media] rcar-vin: return correct error from platform_get_irq()
  [media] rcar-vin: do not use v4l2_device_call_until_err()
  [media] rcar-vin: add dependency on MEDIA_CONTROLLER
  [media] rcar-vin: move chip check for pixelformat support
  [media] rcar-vin: rework how subdeivce is found and bound
  [media] rcar-vin: move media bus information to struct
    rvin_graph_entity

 drivers/media/platform/rcar-vin/Kconfig     |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c | 258 +++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  18 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  91 +++++-----
 drivers/media/platform/rcar-vin/rcar-vin.h  |  25 +--
 5 files changed, 186 insertions(+), 208 deletions(-)

-- 
2.9.2

