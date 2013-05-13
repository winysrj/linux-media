Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtpa09-04.prod.phx3.secureserver.net ([173.201.193.233]:55794
	"EHLO p3plsmtpa09-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab3EMLHY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 07:07:24 -0400
From: Leonid Kegulskiy <leo@lumanate.com>
To: hverkuil@xs4all.nl
Cc: Leonid Kegulskiy <leo@lumanate.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] HDPVR series of patches to replace Apr 25 series
Date: Mon, 13 May 2013 04:06:44 -0700
Message-Id: <1368443208-12431-1-git-send-email-leo@lumanate.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

This series of patches replace the previous series sent on Apr 25.
This adds the check you requested for ret byte count in get_video_info().

Thank you,
-Leo.

Leonid Kegulskiy (4):
  [media] hdpvr: Removed unnecessary get_video_info() call from
    hdpvr_device_init()
  [media] hdpvr: Removed unnecessary use of kzalloc() in
    get_video_info()
  [media] hdpvr: Added some error handling in hdpvr_start_streaming()
  [media] hdpvr: Cleaned up error handling

 drivers/media/usb/hdpvr/hdpvr-control.c |   22 +++-------
 drivers/media/usb/hdpvr/hdpvr-core.c    |    8 ----
 drivers/media/usb/hdpvr/hdpvr-video.c   |   70 +++++++++++++++++--------------
 drivers/media/usb/hdpvr/hdpvr.h         |    2 +-
 4 files changed, 46 insertions(+), 56 deletions(-)

-- 
1.7.9.5

