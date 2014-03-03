Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54159 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaCCWIg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 17:08:36 -0500
Received: from avalon.localnet (unknown [91.178.178.142])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6235C35AC4
	for <linux-media@vger.kernel.org>; Mon,  3 Mar 2014 23:07:33 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] OMAP3 ISP and OMAP4 ISS fixes
Date: Mon, 03 Mar 2014 23:10:01 +0100
Message-ID: <2080385.eQNKOcWPWE@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit cd701c89751d5c63230f47da9a78cdbb39384fdc:

  [media] em28xx: implement em28xx_usb_driver suspend, resume, reset_resume 
hooks (2014-03-03 06:46:48 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to c6ca492864b522b57ed3ffbda9b15b78fc0c6b3c:

  v4l: omap4iss: Add DEBUG compiler flag (2014-03-03 22:56:11 +0100)

----------------------------------------------------------------
Lad, Prabhakar (3):
      omap3isp: Fix typos
      omap3isp: ispccdc: Remove unwanted comments
      omap3isp: Rename the variable names in description

Paul Bolle (1):
      v4l: omap4iss: Add DEBUG compiler flag

Peter Meerwald (1):
      omap3isp: Fix kerneldoc for _module_sync_is_stopping and isp_isr()

 drivers/media/platform/omap3isp/isp.c        |  7 ++-----
 drivers/media/platform/omap3isp/isp.h        | 12 ++++++------
 drivers/media/platform/omap3isp/ispccdc.c    | 10 +++++-----
 drivers/media/platform/omap3isp/ispccdc.h    |  6 ------
 drivers/media/platform/omap3isp/ispccp2.c    |  6 +++---
 drivers/media/platform/omap3isp/isphist.c    |  4 ++--
 drivers/media/platform/omap3isp/isppreview.c | 13 +++++++------
 drivers/media/platform/omap3isp/ispqueue.c   |  2 +-
 drivers/media/platform/omap3isp/ispresizer.c |  6 +++---
 drivers/media/platform/omap3isp/ispresizer.h |  4 ++--
 drivers/media/platform/omap3isp/ispstat.c    |  4 ++--
 drivers/media/platform/omap3isp/ispvideo.c   |  4 ++--
 drivers/staging/media/omap4iss/Makefile      |  2 ++
 13 files changed, 37 insertions(+), 43 deletions(-)

-- 
Regards,

Laurent Pinchart

