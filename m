Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51126 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaLRRB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 12:01:28 -0500
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id D73C820BD6
	for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 17:58:08 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20] uvcvideo changes
Date: Thu, 18 Dec 2014 19:01:31 +0200
Message-ID: <3365098.yJ6YfCn1pi@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal 
(2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to b8a2eed854ea417e82f316b45a749bbe0b43fb18:

  uvcvideo: Add GUID for BGR 8:8:8 (2014-12-18 18:59:50 +0200)

----------------------------------------------------------------
Lad, Prabhakar (1):
      media: usb: uvc: use vb2_ops_wait_prepare/finish helper

William Manley (1):
      uvcvideo: Add GUID for BGR 8:8:8

 drivers/media/usb/uvc/uvc_driver.c |  5 +++++
 drivers/media/usb/uvc/uvc_queue.c  | 19 +++----------------
 drivers/media/usb/uvc/uvcvideo.h   |  3 +++
 3 files changed, 11 insertions(+), 16 deletions(-)

-- 
Regards,

Laurent Pinchart

