Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44005 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3LKPx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 10:53:27 -0500
Received: from avalon.localnet (unknown [91.178.175.146])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 86B0235A6A
	for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 16:52:38 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] More OMAP3 ISP patches
Date: Wed, 11 Dec 2013 16:53:39 +0100
Message-ID: <2324784.ej7lajPpLD@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 989af88339db26345e23271dae1089d949c4a0f1:

  [media] v4l: vsp1: Add LUT support (2013-12-11 09:25:20 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 16fb2398942d3b2fc765d09adfc6c4ec52843149:

  omap3isp: Fix buffer flags handling when querying buffer (2013-12-11 
16:52:02 +0100)

----------------------------------------------------------------
Laurent Pinchart (2):
      omap3isp: Use devm_ioremap_resource()
      omap3isp: Fix buffer flags handling when querying buffer

Sylwester Nawrocki (1):
      omap3isp: Modify clocks registration to avoid circular references

 drivers/media/platform/omap3isp/isp.c      | 47 +++++++++++++----------------
 drivers/media/platform/omap3isp/isp.h      |  3 +--
 drivers/media/platform/omap3isp/ispqueue.c |  2 ++
 3 files changed, 24 insertions(+), 28 deletions(-)

-- 
Regards,

Laurent Pinchart

