Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47012 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab2HLPYy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 11:24:54 -0400
Received: from avalon.localnet (unknown [91.178.199.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 54A887AAF
	for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 17:24:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.7] uvcvideo patches
Date: Sun, 12 Aug 2012 17:25:05 +0200
Message-ID: <2583529.5y4fYzNJ2T@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 518c267f4ca4c45cc51bd582b4aef9f0b9f01eba:

  [media] saa7164: use native print_hex_dump() instead of custom one 
(2012-08-12 07:58:54 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Jayakrishnan Memana (1):
      uvcvideo: Reset the bytesused field when recycling an erroneous buffer

Laurent Pinchart (2):
      uvcvideo: Support super speed endpoints
      uvcvideo: Add support for Ophir Optronics SPCAM 620U cameras

Stefan Muenzel (1):
      uvcvideo: Support 10bit, 12bit and alternate 8bit greyscale formats

 drivers/media/video/uvc/uvc_driver.c |   28 ++++++++++++++++++++++++++--
 drivers/media/video/uvc/uvc_queue.c  |    1 +
 drivers/media/video/uvc/uvc_video.c  |   30 ++++++++++++++++++++++++------
 drivers/media/video/uvc/uvcvideo.h   |    9 +++++++++
 4 files changed, 60 insertions(+), 8 deletions(-)

-- 
Regards,

Laurent Pinchart

