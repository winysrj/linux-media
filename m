Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3DLJW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 05:22:28 -0400
Received: from avalon.localnet (unknown [91.178.242.31])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 639F63598B
	for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 11:22:09 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] OMAP3 ISP patches
Date: Fri, 12 Apr 2013 11:22:29 +0200
Message-ID: <1731183.tBO8QF8hR3@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 81e096c8ac6a064854c2157e0bf802dc4906678c:

  [media] budget: Add support for Philips Semi Sylt PCI ref. design 
(2013-04-08 07:28:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 36960bd76f1088e0cebbe47328e41045443bdc56:

  omap3isp: Use the common clock framework (2013-04-12 10:59:37 +0200)

Please note that the patch depends on

commit 533ddeb1e86f506129ee388a6cc13796dcf31311
Author: Mike Turquette <mturquette@linaro.org>
Date:   Thu Mar 28 13:59:02 2013 -0700

    clk: allow reentrant calls into the clk framework

scheduled for v3.10.

----------------------------------------------------------------
Laurent Pinchart (1):
      omap3isp: Use the common clock framework

 drivers/media/platform/omap3isp/isp.c | 277 +++++++++++++++++++++++----------
 drivers/media/platform/omap3isp/isp.h |  22 +++-
 include/media/omap3isp.h              |  10 +-
 3 files changed, 225 insertions(+), 84 deletions(-)

-- 
Regards,

Laurent Pinchart

