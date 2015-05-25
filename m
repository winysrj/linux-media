Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39355 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbbEYKch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 06:32:37 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 48A2620061
	for <linux-media@vger.kernel.org>; Mon, 25 May 2015 12:32:15 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.2] uvcvideo fixes
Date: Mon, 25 May 2015 13:32:54 +0300
Message-ID: <11121991.A0XHA3Ul9n@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

  [media] dvb-core: fix 32-bit overflow during bandwidth calculation 
(2015-05-20 14:01:46 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to a3dacb93b22f47c5f65dec9cf1c537ae4265d24c:

  uvcvideo: Remove unneeded device disconnected flag (2015-05-25 13:30:34 
+0300)

----------------------------------------------------------------
Laurent Pinchart (3):
      uvcvideo: Implement DMABUF exporter role
      uvcvideo: Fix incorrect bandwidth with Chicony device 04f2:b50b
      uvcvideo: Remove unneeded device disconnected flag

 drivers/media/usb/uvc/uvc_driver.c |  2 --
 drivers/media/usb/uvc/uvc_queue.c  | 12 ++++++++++++
 drivers/media/usb/uvc/uvc_v4l2.c   | 16 +++++++++++++---
 drivers/media/usb/uvc/uvc_video.c  |  8 ++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  7 ++-----
 5 files changed, 35 insertions(+), 10 deletions(-)

-- 
Regards,

Laurent Pinchart

