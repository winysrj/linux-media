Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56656 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaJGQWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Oct 2014 12:22:03 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 693C120115
	for <linux-media@vger.kernel.org>; Tue,  7 Oct 2014 18:20:26 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.18] uvcvideo fix
Date: Tue, 07 Oct 2014 19:22:13 +0300
Message-ID: <1612006.gTirVuyUTl@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit cf3167cf1e969b17671a4d3d956d22718a8ceb85:

  [media] pt3: fix DTV FE I2C driver load error paths (2014-09-28 22:23:42 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvcvideo/fixes

for you to fetch changes up to a7f053c67c357c4b68c1be21976a1d464f97916b:

  v4l: uvcvideo: Fix buffer completion size check (2014-10-07 19:16:16 +0300)

This fixes a bug introduced by commit e93e7fd9f5a3 ("v4l2: uvcvideo: Allow 
using larger buffers") scheduled for merge in v3.18.

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: uvcvideo: Fix buffer completion size check

 drivers/media/usb/uvc/uvc_v4l2.c  | 1 -
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 drivers/media/usb/uvc/uvcvideo.h  | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

