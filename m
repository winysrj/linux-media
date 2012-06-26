Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51009 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2FZBe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 21:34:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/2] Miscellaneous OMAP3 ISP fixes
Date: Tue, 26 Jun 2012 03:34:54 +0200
Message-Id: <1340674496-31953-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Not much to be said here. The first patch is needed by the second, which is
described in its commit message. I'd like to get this into v3.6.

Laurent Pinchart (2):
  omap3isp: Don't access ISP_CTRL directly in the statistics modules
  omap3isp: Configure HS/VS interrupt source before enabling interrupts

 drivers/media/video/omap3isp/isp.c         |   47 +++++++++++++++++----------
 drivers/media/video/omap3isp/isp.h         |    9 +++--
 drivers/media/video/omap3isp/isph3a_aewb.c |   10 +-----
 drivers/media/video/omap3isp/isph3a_af.c   |   10 +-----
 drivers/media/video/omap3isp/isphist.c     |    6 +--
 5 files changed, 40 insertions(+), 42 deletions(-)

-- 
Regards,

Laurent Pinchart

