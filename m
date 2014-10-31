Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51738 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:21:16 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 9A98420270
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:19:04 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] Miscellaneous OMAP4 ISS fixes and enhancements
Date: Fri, 31 Oct 2014 17:21:18 +0200
Message-Id: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here are four miscellaneous patches for the OMAP4 ISS driver. Please see
individual patches for details.

Laurent Pinchart (4):
  v4l: omap4iss: Enable DMABUF support
  v4l: omap4iss: Remove bogus frame number propagation
  v4l: omap4iss: csi2: Perform real frame number propagation
  v4l: omap4iss: Stop started entities when pipeline start fails

 drivers/staging/media/omap4iss/iss.c         | 111 +++++++++++++++------------
 drivers/staging/media/omap4iss/iss_csi2.c    |  43 ++++++++---
 drivers/staging/media/omap4iss/iss_csi2.h    |   2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c |  22 +-----
 drivers/staging/media/omap4iss/iss_regs.h    |   2 +
 drivers/staging/media/omap4iss/iss_resizer.c |  18 +----
 drivers/staging/media/omap4iss/iss_video.c   |  11 ++-
 7 files changed, 113 insertions(+), 96 deletions(-)

-- 
Regards,

Laurent Pinchart

