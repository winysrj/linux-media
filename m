Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36502 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GFNwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 09:52:23 -0400
Received: from avalon.localnet (unknown [91.178.165.100])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 698587AAE
	for <linux-media@vger.kernel.org>; Fri,  6 Jul 2012 15:52:22 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.5] OMAP3 ISP regression fixes
Date: Fri, 06 Jul 2012 15:52:30 +0200
Message-ID: <2082628.rb3Lgsj3of@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-stable

Both are v3.5 regression fixes.

Laurent Pinchart (2):
      omap3isp: preview: Fix output size computation depending on input format
      omap3isp: preview: Fix contrast and brightness handling

 drivers/media/video/omap3isp/isppreview.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

