Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55880 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaEIMPe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:15:34 -0400
Received: from avalon.localnet (161.23-200-80.adsl-dyn.isp.belgacom.be [80.200.23.161])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 515ED359FA
	for <linux-media@vger.kernel.org>; Fri,  9 May 2014 14:12:55 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.16] uvcvideo fixes
Date: Fri, 09 May 2014 14:15:33 +0200
Message-ID: <7909686.JGN3j7sPAP@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:

  [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

for you to fetch changes up to 4d576e85f1d7e11190652619156b9a136d4c4a98:

  uvcvideo: Fix clock param realtime setting (2014-05-09 14:10:37 +0200)

----------------------------------------------------------------
Anton Leontiev (1):
      uvcvideo: Fix marking buffer erroneous in case of FID toggling

Olivier Langlois (1):
      uvcvideo: Fix clock param realtime setting

 drivers/media/usb/uvc/uvc_video.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

-- 
Regards,

Laurent Pinchart

