Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50345 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJLHN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 06:07:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 2.6.38] Control framework fixes
Date: Mon, 10 Jan 2011 12:08:00 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101101208.00917.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit 0a97a683049d83deaf636d18316358065417d87b:

  [media] cpia2: convert .ioctl to .unlocked_ioctl (2011-01-06 11:34:41 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git ctrl-framework

Could you please include them in the next pull request for 2.6.38 ? The second 
one is a bug fix and has been reviewed by Hans.

Laurent Pinchart (2):
      v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
      v4l: Fix a use-before-set in the control framework

 drivers/media/video/v4l2-ctrls.c |    2 +-
 include/media/v4l2-ctrls.h       |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

-- 
Regards,

Laurent Pinchart
