Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36126 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaC1QAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:00:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: [PATCH v2 0/3] Miscellaneous fixes for UVC gadget driver
Date: Fri, 28 Mar 2014 17:02:45 +0100
Message-Id: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

These three patches fix miscellaneous issues in the UVC gadget driver. Patches
1 and 3 have already been posted as part of the "Clock fixes for UVC gadget
driver" series, and patch 2 is new.

The series is based on the latest media tree master branch as it depends on
commit 872484ce40881e295b046adf21f7211306477751 ("v4l: Add timestamp source
flags, mask and document them") queued for v3.15. It would thus be easier to
merge it through the media tree. Greg and Mauro, would that be fine ?
Alternatively I can rebase it on top of v3.15-rc1 when that version will be
tagged.

Laurent Pinchart (3):
  usb: gadget: uvc: Switch to monotonic clock for buffer timestamps
  usb: gadget: uvc: Set the V4L2 buffer field to V4L2_FIELD_NONE
  usb: gadget: uvc: Set the vb2 queue timestamp flags

 drivers/usb/gadget/uvc_queue.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

