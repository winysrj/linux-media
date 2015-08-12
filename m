Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43136 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbbHLIGn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 04:06:43 -0400
Received: from avalon.localnet (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id B71AB2000F
	for <linux-media@vger.kernel.org>; Wed, 12 Aug 2015 10:05:21 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.3] MC core bugfix
Date: Wed, 12 Aug 2015 11:07:37 +0300
Message-ID: <1630479.sidOooZzFE@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2696f495bdc046d84da6c909a1e7f535138a2a62:

  [media] Staging: media: lirc: use USB API functions rather than constants 
(2015-08-11 18:00:30 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/next

for you to fetch changes up to ab25def6e98d8a16105ab34bb1fc7b80f4b2dff5:

  media: Correctly notify about the failed pipeline validation (2015-08-12 
10:57:05 +0300)

----------------------------------------------------------------
Sakari Ailus (1):
      media: Correctly notify about the failed pipeline validation

 drivers/media/media-entity.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

