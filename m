Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36964 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2KMNqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 08:46:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Archit Taneja <archit@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 0/2] omap_vout: Fix overlay support
Date: Tue, 13 Nov 2012 14:47:37 +0100
Message-Id: <1352814459-8215-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Commit 4b20259fa642d6f7a2dabef0b3adc14ca9dadbde ("v4l2-dev: improve ioctl
validity checks") broke overlay support in the omap_vout driver. This patch
series fix it.

Tested on a Beagleboard-xM with a YUYV overlay and the omap3-isp-live
application from http://git.ideasonboard.org/omap3-isp-live.git.

Is there an active maintainer for the omap_vout driver who can take this patch
in his/her tree ?

Laurent Pinchart (2):
  omap_vout: Drop overlay format enumeration
  omap_vout: Use the output overlay ioctl operations

 drivers/media/platform/omap/omap_vout.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

-- 
Regards,

Laurent Pinchart

