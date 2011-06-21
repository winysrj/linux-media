Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55052 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab1FUWhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 18:37:08 -0400
Received: from lancelot.localnet (unknown [91.178.68.76])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A6F1B359BB
	for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 22:37:07 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.0] uvcvideo fixes
Date: Wed, 22 Jun 2011 00:37:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106220037.34441.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f:

  Linux 3.0-rc4 (2011-06-20 20:25:46 -0700)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

Sjoerd Simons (2):
      uvcvideo: Remove buffers from the queues when freeing
      uvcvideo: Disable the queue when failing to start

 drivers/media/video/uvc/uvc_queue.c |    2 ++
 drivers/media/video/uvc/uvc_video.c |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

Those patches fix bugs (including a user-triggerable oops), but they're not 
regression fixes.

-- 
Regards,

Laurent Pinchart
