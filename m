Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA90C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 21:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D96220882
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 21:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfA2Vu3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 16:50:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:56432 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbfA2Vu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 16:50:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2019 13:50:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,538,1539673200"; 
   d="scan'208";a="129571782"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jan 2019 13:50:27 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 714B920141;
        Tue, 29 Jan 2019 23:50:26 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gobGK-0004Or-R2; Tue, 29 Jan 2019 23:49:44 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     laurent.pinchart@ideasonboard.com
Cc:     linux-media@vger.kernel.org, chiranjeevi.rapolu@intel.com
Subject: [PATCH 1/1] uvc: Avoid NULL pointer dereference at the end of streaming
Date:   Tue, 29 Jan 2019 23:49:44 +0200
Message-Id: <20190129214944.16875-1-sakari.ailus@linux.intel.com>
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

Reported-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Tested-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Laurent,

This seems like something that's been out there for a while... I'll figure
out soon which stable kernels should receive it, if any.

 drivers/media/usb/uvc/uvc_video.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 84525ff047450..a30c5e1893e72 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -676,6 +676,13 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 	if (!uvc_hw_timestamps_param)
 		return;
 
+	/*
+	 * We may get called if there are buffers done but not dequeued by the
+	 * user. Just bail out in that case.
+	 */
+	if (!clock->samples)
+		return;
+
 	spin_lock_irqsave(&clock->lock, flags);
 
 	if (clock->count < clock->size)
-- 
2.11.0

