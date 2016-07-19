Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:53671 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbcGSOLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:11:44 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Cc: ulrich.hecht+renesas@gmail.com, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2] [PATCH] [media] rcar-csi2: add Renesas R-Car MIPI CSI-2 driver
Date: Tue, 19 Jul 2016 16:11:19 +0200
Message-Id: <20160719141120.21796-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch adds support for the R-Car MIPI CSI-2 interface. And is based 
on top of the media_tree.

Changes since v1:
- Drop dependency on a pad aware s_stream operation.
- Use the DT bindings format "renesas,<soctype>-<device>", thanks Geert 
  for pointing this out.

Niklas Söderlund (1):
  [media] rcar-csi2: add Renesas R-Car MIPI CSI-2 driver

 .../devicetree/bindings/media/rcar-csi2.txt        |  79 +++
 drivers/media/platform/rcar-vin/Kconfig            |  11 +
 drivers/media/platform/rcar-vin/Makefile           |   2 +
 drivers/media/platform/rcar-vin/rcar-csi2.c        | 544 +++++++++++++++++++++
 4 files changed, 636 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2.txt
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

-- 
2.9.0

