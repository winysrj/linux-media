Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51113 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLRQzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 11:55:49 -0500
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id DAF1620BD6
	for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 17:52:28 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20]  OMAP3 ISP and OMAP4 ISS changes
Date: Thu, 18 Dec 2014 18:55:51 +0200
Message-ID: <2473465.MT2HERg2rx@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal 
(2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap/next

for you to fetch changes up to 0ad05d6633d3a6cb4410473ebc93c94b14f16478:

  v4l: omap4iss: Stop started entities when pipeline start fails (2014-12-18 
18:54:27 +0200)

----------------------------------------------------------------
Laurent Pinchart (5):
      omap3isp: Fix division by 0
      v4l: omap4iss: Enable DMABUF support
      v4l: omap4iss: Remove bogus frame number propagation
      v4l: omap4iss: csi2: Perform real frame number propagation
      v4l: omap4iss: Stop started entities when pipeline start fails

 drivers/media/platform/omap3isp/isp.c        |   3 +
 drivers/staging/media/omap4iss/iss.c         | 111 +++++++++++++++-----------
 drivers/staging/media/omap4iss/iss_csi2.c    |  43 ++++++++++----
 drivers/staging/media/omap4iss/iss_csi2.h    |   2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c |  22 +------
 drivers/staging/media/omap4iss/iss_regs.h    |   2 +
 drivers/staging/media/omap4iss/iss_resizer.c |  18 +-----
 drivers/staging/media/omap4iss/iss_video.c   |  11 +++-
 8 files changed, 116 insertions(+), 96 deletions(-)

-- 
Regards,

Laurent Pinchart

