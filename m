Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54088 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaCCVwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 16:52:49 -0500
Received: from avalon.localnet (unknown [91.178.178.142])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1F51335AC4
	for <linux-media@vger.kernel.org>; Mon,  3 Mar 2014 22:51:46 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] uvcvideo fixes
Date: Mon, 03 Mar 2014 22:54:14 +0100
Message-ID: <6017354.8tlIuUTvP2@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit cd701c89751d5c63230f47da9a78cdbb39384fdc:

  [media] em28xx: implement em28xx_usb_driver suspend, resume, reset_resume 
hooks (2014-03-03 06:46:48 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

for you to fetch changes up to a44939ba9afaccf63f727d263c1db1054cc130b2:

  uvcvideo: Add bayer 8-bit patterns to uvcvideo (2014-03-03 13:35:14 +0100)

----------------------------------------------------------------
Edgar Thier (1):
      uvcvideo: Add bayer 8-bit patterns to uvcvideo

Oleksij Rempel (1):
      uvcvideo: Do not use usb_set_interface on bulk EP

 drivers/media/usb/uvc/uvc_driver.c | 22 +++++++++++++++++++++-
 drivers/media/usb/uvc/uvc_video.c  | 20 +++++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

