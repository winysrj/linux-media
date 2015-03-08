Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35538 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbbCHLCe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 07:02:34 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 4A6912000F
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2015 12:01:33 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.1] uvcvideo changes
Date: Sun, 08 Mar 2015 13:02:34 +0200
Message-ID: <12085313.RFR9ORrFbp@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 
13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to d3e577ef6e959f5bcec7e8542be33a520452f119:

  uvcvideo: Validate index during step-wise frame intervals enumeration 
(2015-03-06 20:24:03 +0200)

----------------------------------------------------------------
Laurent Pinchart (3):
      uvcvideo: Don't call vb2 mmap and get_unmapped_area with queue lock held
      uvcvideo: Recognize the Tasco USB microscope
      uvcvideo: Validate index during step-wise frame intervals enumeration

 drivers/media/usb/uvc/uvc_driver.c |  8 ++++++++
 drivers/media/usb/uvc/uvc_queue.c  | 15 ++-------------
 drivers/media/usb/uvc/uvc_v4l2.c   |  3 +++
 3 files changed, 13 insertions(+), 13 deletions(-)

-- 
Regards,

Laurent Pinchart

