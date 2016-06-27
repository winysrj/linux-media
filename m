Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:59537 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbcF0RrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 13:47:25 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Cc: ulrich.hecht+renesas@gmail.com, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] [media] rcar-csi2: add Renesas R-Car MIPI CSI-2 driver
Date: Mon, 27 Jun 2016 19:45:32 +0200
Message-Id: <20160627174533.16029-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch adds support for the R-Car MIPI CSI-2 driver.

It is based on top of the media_tree and depends on the series '[PATCH 
0/2] move s_stream from v4l2_subdev_video_ops to move s_stream from 
v4l2_subdev_pad_ops'. It's tested on a Renesas Salvator-X board.

The patch itself do not need a pad argument for s_stream but it is 
tested on a Renesas Salvator-X which have a ADV7482 device in the video 
input pipeline (RFC for that driver previously posted) which needs the 
pad argument.

If anyone is interested to test on Salvator-X the following branch 
contains all the patches to grab video (rcar-vin for Gen3, rcar-cis2 and 
adv7482).

https://git.ragnatech.se/linux rcar-vin-gen3


Niklas Söderlund (1):
  [media] rcar-csi2: add Renesas R-Car MIPI CSI-2 driver

 .../devicetree/bindings/media/rcar-csi2.txt        |  79 +++
 drivers/media/platform/rcar-vin/Kconfig            |  11 +
 drivers/media/platform/rcar-vin/Makefile           |   2 +
 drivers/media/platform/rcar-vin/rcar-csi2.c        | 545 +++++++++++++++++++++
 4 files changed, 637 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2.txt
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

-- 
2.8.3

