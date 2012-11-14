Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37595 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2KNJaq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 04:30:46 -0500
Received: from avalon.localnet (unknown [91.178.188.245])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 85FB1359DA
	for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 10:30:45 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] V4L subdev fix
Date: Wed, 14 Nov 2012 10:31:41 +0100
Message-ID: <2177620.Q2jQvYdsnp@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2c4e11b7c15af70580625657a154ea7ea70b8c76:

  [media] siano: fix RC compilation (2012-11-07 11:09:08 +0100)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git v4l2/core

Laurent Pinchart (1):
      v4l: Don't warn during link validation when encountering a V4L2 devnode

 drivers/media/v4l2-core/v4l2-subdev.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-

-- 
Regards,

Laurent Pinchart

