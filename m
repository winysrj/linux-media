Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55233 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932609Ab2CZOmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 10:42:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] OMAP3 ISP preview engine fixes
Date: Mon, 26 Mar 2012 16:42:28 +0200
Message-Id: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here are three patches for the OMAP3 ISP that improve the preview engine
configuration.

Patch 1/3 fixes in bug in the driver that shouldn't cause any misbehaviour,
but is still wrong nonetheless. Patch 2/3 speeds up interrupt handling for the
common case when no parameter has been modified, and patch 3/3 fixes a shadow
update issue that resulted in parameters never being applied in a common race
condition case.

Laurent Pinchart (3):
  omap3isp: preview: Skip brightness and contrast in configuration
    ioctl
  omap3isp: preview: Optimize parameters setup for the common case
  omap3isp: preview: Shorten shadow update delay

 drivers/media/video/omap3isp/isppreview.c |  129 ++++++++++++++++++++---------
 drivers/media/video/omap3isp/isppreview.h |   19 +++--
 2 files changed, 101 insertions(+), 47 deletions(-)

-- 
Regards,

Laurent Pinchart

