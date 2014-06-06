Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42316 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaFFPVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 11:21:20 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.142.25])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6DF5F35A40
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 17:20:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] OMAP4 ISS: Miscellaneous fixes and improvements
Date: Fri,  6 Jun 2014 17:21:41 +0200
Message-Id: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set brings miscellaneous fixes and improvements to the OMAP4 ISS
driver. Please see individual patches for details.

Patch 4/5 depends on the "vb2: Report POLLERR for fatal errors only" patch
series posted to the linux-media mailing list.

I plan to send a pull request that will include both series.

Laurent Pinchart (5):
  v4l: omap4iss: Don't reinitialize the video qlock at every streamon
  v4l: omap4iss: Add module debug parameter
  v4l: omap4iss: Use the devm_* managed allocators
  v4l: omap4iss: Signal fatal errors to the vb2 queue
  MAINTAINERS: Add the OMAP4 ISS driver

 MAINTAINERS                                |  3 +-
 drivers/staging/media/omap4iss/iss.c       | 84 +++---------------------------
 drivers/staging/media/omap4iss/iss_video.c | 22 ++++----
 3 files changed, 22 insertions(+), 87 deletions(-)

-- 
Regards,

Laurent Pinchart
