Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:53735 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIXSD3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 14:03:29 -0400
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] [media] OMAP3 ISP: Adjustments for some function
 implementations
Message-ID: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Date: Sun, 24 Sep 2017 20:03:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 19:57:34 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Delete an error message for a failed memory allocation in three functions
  Adjust 53 checks for null pointers
  Use common error handling code in isp_video_open()
  Delete an unnecessary variable initialisation in isp_video_open()

 drivers/media/platform/omap3isp/isp.c         | 20 +++++-----
 drivers/media/platform/omap3isp/ispccdc.c     | 28 +++++++-------
 drivers/media/platform/omap3isp/ispccp2.c     |  6 +--
 drivers/media/platform/omap3isp/ispcsi2.c     |  6 +--
 drivers/media/platform/omap3isp/ispcsiphy.c   |  2 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c |  5 +--
 drivers/media/platform/omap3isp/isph3a_af.c   |  7 +---
 drivers/media/platform/omap3isp/isphist.c     |  4 +-
 drivers/media/platform/omap3isp/isppreview.c  |  8 ++--
 drivers/media/platform/omap3isp/ispresizer.c  |  8 ++--
 drivers/media/platform/omap3isp/ispstat.c     |  4 +-
 drivers/media/platform/omap3isp/ispvideo.c    | 53 +++++++++++++--------------
 12 files changed, 70 insertions(+), 81 deletions(-)

-- 
2.14.1
