Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtpa09-03.prod.phx3.secureserver.net ([173.201.193.232]:36761
	"EHLO p3plsmtpa09-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab3DYKAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 06:00:04 -0400
From: Leonid Kegulskiy <leo@lumanate.com>
To: hverkuil@xs4all.nl
Cc: Leonid Kegulskiy <leo@lumanate.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] HDPVR series of patches to replace Apr 22 patch
Date: Thu, 25 Apr 2013 02:59:53 -0700
Message-Id: <1366883997-18909-1-git-send-email-leo@lumanate.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

This series of patches replace the previous patch sent on Apr 22:
    [PATCH] [media] hdpvr_ error handling and alloc abuse cleanup.

Thank you,
-Leo.

Leonid Kegulskiy (4):
  [media] hdpvr: Removed unnecessary get_video_info() call from
    hdpvr_device_init()
  [media] hdpvr: Removed unnecessary use of kzalloc() in
    get_video_info()
  [media] hdpvr: Added some error handling in hdpvr_start_streaming()
  [media] hdpvr: Cleaned up error handling

 drivers/media/usb/hdpvr/hdpvr-control.c |   20 ++-------
 drivers/media/usb/hdpvr/hdpvr-core.c    |    8 ----
 drivers/media/usb/hdpvr/hdpvr-video.c   |   70 +++++++++++++++++--------------
 drivers/media/usb/hdpvr/hdpvr.h         |    2 +-
 4 files changed, 43 insertions(+), 57 deletions(-)

-- 
1.7.10.4

