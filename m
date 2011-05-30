Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37391 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab1E3Os1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 10:48:27 -0400
Received: from lancelot.localnet (unknown [91.178.186.233])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D7BCF359D1
	for <linux-media@vger.kernel.org>; Mon, 30 May 2011 14:48:25 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.0] OMAP3 ISP fixes
Date: Mon, 30 May 2011 16:48:31 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105301648.32113.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-stable-omap3isp

Laurent Pinchart (1):
      v4l: Fix media_entity_to_video_device macro argument name

Sanjeev Premi (1):
      omap3isp: fix compiler warning

 drivers/media/video/omap3isp/isp.c |    2 +-
 include/media/v4l2-dev.h           |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart
