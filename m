Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59958 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaHANzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 0/8] OMAP3 ISP CCDC fixes
Date: Fri,  1 Aug 2014 15:46:26 +0200
Message-Id: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series fixes several stability issues related to the CCDC,
especially (but not exclusively) in BT.656 mode.

The patches apply on top of the OMAP3 ISP CCDC BT.656 mode support series
previously posted. You can find both series at

	git://linuxtv.org/pinchartl/media.git omap3isp/bt656

I'm not sure to be completely happy with the last three patches. The CCDC
state machine is getting too complex for my tastes, race conditions becoming
too hard to spot. This doesn't mean the code is wrong, but a rewrite of the
state machine will probably needed sooner than later.

Laurent Pinchart (8):
  omap3isp: ccdc: Disable the video port when unused
  omap3isp: ccdc: Only complete buffer when all fields are captured
  omap3isp: ccdc: Rename __ccdc_handle_stopping to ccdc_handle_stopping
  omap3isp: ccdc: Simplify ccdc_lsc_is_configured()
  omap3isp: ccdc: Increment the frame number at VD0 time for BT.656
  omap3isp: ccdc: Fix freeze when a short frame is received
  omap3isp: ccdc: Don't timeout on stream off when the CCDC is stopped
  omap3isp: ccdc: Restart the CCDC immediately after an underrun in
    BT.656

 drivers/media/platform/omap3isp/ispccdc.c | 233 +++++++++++++++++++-----------
 drivers/media/platform/omap3isp/ispccdc.h |   9 ++
 2 files changed, 154 insertions(+), 88 deletions(-)

-- 
Regards,

Laurent Pinchart

