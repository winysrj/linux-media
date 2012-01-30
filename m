Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39914 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2A3LtM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 06:49:12 -0500
Received: from lancelot.localnet (unknown [91.178.121.38])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CB3E935C17
	for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 11:49:10 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.3] OMAP3 ISP fix
Date: Mon, 30 Jan 2012 12:49:27 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201301249.28622.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's one patch for v3.3 that fixes a regression. The patch was included in 
v3.2, but a merge conflict coupled with a bad conflict resolution removed it 
from v3.3.

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-stable

Laurent Pinchart (1):
      omap3isp: Fix crash caused by subdevs now having a pointer to devnodes

 drivers/media/video/omap3isp/ispccdc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Regards,

Laurent Pinchart
