Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59573 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbdA3Kgr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 05:36:47 -0500
Received: from avalon.localnet (unknown [91.179.29.12])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 0282220098
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2017 11:36:05 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.11] uvcvideo changes
Date: Mon, 30 Jan 2017 12:37:07 +0200
Message-ID: <1751022.MDrEgGuLi4@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to eeb7ba86db3cf031b659bae245ca56d38dc44741:

  uvcvideo: Change result code of debugfs_init to void (2017-01-19 02:07:10 
+0200)

----------------------------------------------------------------
Guennadi Liakhovetski (3):
      uvcvideo: (cosmetic) Add and use an inline function
      uvcvideo: (cosmetic) Remove a superfluous assignment
      uvcvideo: Fix a wrong macro

Jaejoong Kim (1):
      uvcvideo: Change result code of debugfs_init to void

 drivers/media/usb/uvc/uvc_debugfs.c | 15 ++++++---------
 drivers/media/usb/uvc/uvc_queue.c   | 13 +++++++++----
 drivers/media/usb/uvc/uvc_video.c   |  3 +--
 drivers/media/usb/uvc/uvcvideo.h    |  4 ++--
 4 files changed, 18 insertions(+), 17 deletions(-)

-- 
Regards,

Laurent Pinchart

