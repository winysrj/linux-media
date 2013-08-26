Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32778 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3HZN21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 09:28:27 -0400
Received: from avalon.localnet (unknown [109.134.70.29])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 02C9435A6F
	for <linux-media@vger.kernel.org>; Mon, 26 Aug 2013 15:28:04 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.12] VSP1 driver fixes
Date: Mon, 26 Aug 2013 15:29:46 +0200
Message-ID: <1604449.0Llice0ng2@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are three v3.12 fixes for the VSP1 driver.

The following changes since commit e0c332c671e71941e0bd4a339972ee4af15df676:

  [media] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig 
(2013-08-25 07:34:52 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1

for you to fetch changes up to 74552e772a715b9004d41b9fda239e74f1dcc990:

  v4l: vsp1: Fix mutex double lock at streamon time (2013-08-26 15:24:48 
+0200)

----------------------------------------------------------------
Laurent Pinchart (3):
      v4l: vsp1: Initialize media device bus_info field
      v4l: vsp1: Add support for RT clock
      v4l: vsp1: Fix mutex double lock at streamon time

 drivers/media/platform/vsp1/vsp1.h       |  1 +
 drivers/media/platform/vsp1/vsp1_drv.c   | 42 ++++++++++++++++++++++++++-----
 drivers/media/platform/vsp1/vsp1_video.c |  2 --
 3 files changed, 38 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

