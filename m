Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0ADCC282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 10:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFE46218A3
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 10:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfA3KK1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:10:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:5771 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbfA3KK1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 05:10:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2019 02:10:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,540,1539673200"; 
   d="scan'208";a="110987846"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga007.jf.intel.com with ESMTP; 30 Jan 2019 02:10:25 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 3CBBD20389;
        Wed, 30 Jan 2019 12:10:24 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gomoQ-0004aN-3p; Wed, 30 Jan 2019 12:09:42 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     laurent.pinchart@ideasonboard.com
Cc:     linux-media@vger.kernel.org, chiranjeevi.rapolu@intel.com
Subject: [PATCH v2 1/1] uvc: Avoid NULL pointer dereference at the end of streaming
Date:   Wed, 30 Jan 2019 12:09:41 +0200
Message-Id: <20190130100941.17589-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The UVC video driver converts the timestamp from hardware specific unit to
one known by the kernel at the time when the buffer is dequeued. This is
fine in general, but the streamoff operation consists of the following
steps (among other things):

1. uvc_video_clock_cleanup --- the hardware clock sample array is
   released and the pointer to the array is set to NULL,

2. buffers in active state are returned to the user and

3. buf_finish callback is called on buffers that are prepared. buf_finish
   includes calling uvc_video_clock_update that accesses the hardware
   clock sample array.

The above is serialised by a queue specific mutex. Address the problem by
skipping the clock conversion if the hardware clock sample array is
already released.

Fixes: 9c0863b1cc48 ("[media] vb2: call buf_finish from __queue_cancel")
Reported-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Tested-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
since v1:

- Improve the comment in uvc_video_clock_update().

- Add appropriate Cc: stable, Reviewed-by: and Fixes: tags.

 drivers/media/usb/uvc/uvc_video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 84525ff047450..e314657a1843a 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -676,6 +676,14 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 	if (!uvc_hw_timestamps_param)
 		return;
 
+	/*
+	 * We will get called from __vb2_queue_cancel() if there are buffers
+	 * done but not dequeued by the user, but the sample array has already
+	 * been released at that time. Just bail out in that case.
+	 */
+	if (!clock->samples)
+		return;
+
 	spin_lock_irqsave(&clock->lock, flags);
 
 	if (clock->count < clock->size)
-- 
2.11.0

