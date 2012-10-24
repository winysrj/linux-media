Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58610 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab2JXXw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 19:52:28 -0400
Received: from avalon.localnet (unknown [91.178.212.53])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9F01435A8D
	for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 01:52:26 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.7] OMAP3 ISP fixes
Date: Thu, 25 Oct 2012 01:53:16 +0200
Message-ID: <6257625.TDgOYogvlV@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two regression fixes for v3.7 that get rid of compilation warnings.

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp/stable

Laurent Pinchart (2):
      omap3isp: video: Fix warning caused by bad vidioc_s_crop prototype
      omap3isp: Fix warning caused by bad subdev events operations prototypes

 drivers/media/platform/omap3isp/ispccdc.c  |    4 ++--
 drivers/media/platform/omap3isp/ispstat.c  |    4 ++--
 drivers/media/platform/omap3isp/ispstat.h  |    4 ++--
 drivers/media/platform/omap3isp/ispvideo.c |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

