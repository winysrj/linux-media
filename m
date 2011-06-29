Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59915 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1F2AFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 20:05:43 -0400
Received: from lancelot.localnet (unknown [91.178.33.185])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E381635B82
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 00:05:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.0] v4l core and uvcvideo fixes
Date: Wed, 29 Jun 2011 02:05:51 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106290205.52374.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit b0af8dfdd67699e25083478c63eedef2e72ebd85:

  Linux 3.0-rc5 (2011-06-27 19:12:22 -0700)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

Laurent Pinchart (2):
      v4l: Don't access media entity after is has been destroyed
      uvcvideo: Ignore entities for terminals with no supported format

Sjoerd Simons (2):
      uvcvideo: Remove buffers from the queues when freeing
      uvcvideo: Disable the queue when failing to start

 drivers/media/video/uvc/uvc_entity.c |   34 ++++++++++++++++++-----------
 drivers/media/video/uvc/uvc_queue.c  |    2 +
 drivers/media/video/uvc/uvc_video.c  |    4 ++-
 drivers/media/video/v4l2-dev.c       |   39 ++++++---------------------------
 4 files changed, 33 insertions(+), 46 deletions(-

The first two patches fix serious regressions causing oopses and need to go in 
3.0. The last two patches fix non-regression bugs and can be delayed until 3.1 
if needed.

-- 
Regards,

Laurent Pinchart
