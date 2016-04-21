Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33555 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbcDUBOE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 21:14:04 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	David Airlie <airlied@linux.ie>
Subject: [PATCH 0/2] Renesas R-Car Gen3 DU alpha and z-order support
Date: Thu, 21 Apr 2016 04:14:11 +0300
Message-Id: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series implement support for alpha and z-order configuration in the
R-Car DU driver for the Gen3 SoCs family.

The Gen3 SoCs delegate composition to an external IP core called VSP,
supported by a V4L2 driver. The DU driver interfaces with the VSP driver using
direct function calls. Alpha and z-order configuration is implemented in the
VSP driver, the DU driver thus just needs to pass the values using the VSP
API.

This series depends on a large VSP series that has been merged in the Linux
media git tree for v4.7. Dave, instead of merging the media tree in your tree
to pull the dependency in, it would be easier to get those two patches
upstream through the media tree. I don't expect any conflict related to the
DU driver for v4.7. If you're fine with that, could you ack the patches ?

Laurent Pinchart (2):
  drm: rcar-du: Add Z-order support for VSP planes
  drm: rcar-du: Add alpha support for VSP planes

 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 16 ++++++++++++----
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h |  2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

