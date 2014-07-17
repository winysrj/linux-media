Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35851 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaGQKLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 06:11:48 -0400
Received: from avalon.localnet (unknown [91.178.197.224])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id BA69C359FA
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 12:10:43 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.17] OMAP4 ISS fixes and enhancements
Date: Thu, 17 Jul 2014 12:11:54 +0200
Message-ID: <127783026.6sLjMWfivo@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks 
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 97c9a001293360b566cb20853df2bd4b772d820f:

  MAINTAINERS: Add the OMAP4 ISS driver (2014-07-17 12:10:07 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      v4l: omap4iss: tighten omap4iss dependencies

Laurent Pinchart (7):
      v4l: vb2: Don't return POLLERR during transient buffer underruns
      v4l: vb2: Add fatal error condition flag
      v4l: omap4iss: Don't reinitialize the video qlock at every streamon
      v4l: omap4iss: Add module debug parameter
      v4l: omap4iss: Use the devm_* managed allocators
      v4l: omap4iss: Signal fatal errors to the vb2 queue
      MAINTAINERS: Add the OMAP4 ISS driver

Vitaly Osipov (1):
      v4l: omap4iss: Copy paste error in iss_get_clocks

 MAINTAINERS                                |  3 +-
 drivers/media/v4l2-core/videobuf2-core.c   | 40 ++++++++++++++++--
 drivers/staging/media/omap4iss/Kconfig     |  2 +-
 drivers/staging/media/omap4iss/iss.c       | 86 +++--------------------------
 drivers/staging/media/omap4iss/iss_video.c | 22 +++++-----
 include/media/videobuf2-core.h             |  3 ++
 6 files changed, 64 insertions(+), 92 deletions(-)

-- 
Regards,

Laurent Pinchart

