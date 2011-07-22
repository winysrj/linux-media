Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51707 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1GVXoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 19:44:01 -0400
Received: from lancelot.localnet (unknown [91.178.30.248])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 91868359A4
	for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 23:44:00 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.1] Sensor driver fixes
Date: Sat, 23 Jul 2011 01:44:05 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107230144.05954.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit f0a21151140da01c71de636f482f2eddec2840cc:

  Merge tag 'v3.0' into staging/for_v3.1 (2011-07-22 13:33:14 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp-next-sensors

Laurent Pinchart (1):
      v4l: mt9v032: Fix Bayer pattern

 drivers/media/video/mt9v032.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

-- 
Regards,

Laurent Pinchart
