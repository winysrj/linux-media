Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C403C10F00
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 15:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43F0B20C01
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 15:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbfB1PaR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:30:17 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53568 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732772AbfB1PaQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 10:30:16 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 29022278659
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        ccr@tnsp.org, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [DONTCOMMIT/WIP] gspca: Check device presence before accessing hardware
Date:   Thu, 28 Feb 2019 12:30:03 -0300
Message-Id: <20190228153003.14493-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

sd_desc->stop0 and sd_desc->stopN hooks are meant to access
the device hardware, stopping the transfer. Thus, hardware
presence should be checked before calling them.

This means that sd_desc.start is not allowed to allocate resources,
since sd_desc.stop0 and sd_desc.stopN won't be releasing when
the USB device is disconnected.

TODO: Check what's the deal with the konica device, which is allocating
URB memory in sd_desc.start. This seems wrong.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/usb/gspca/gspca.c | 11 ++++++-----
 drivers/media/usb/gspca/gspca.h |  6 +++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 4d7517411cc2..98b68a7a52c0 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -745,15 +745,16 @@ static void gspca_stream_off(struct gspca_dev *gspca_dev)
 {
 	gspca_dev->streaming = false;
 	gspca_dev->usb_err = 0;
-	if (gspca_dev->sd_desc->stopN)
+	if (gspca_dev->present && gspca_dev->sd_desc->stopN)
 		gspca_dev->sd_desc->stopN(gspca_dev);
 	destroy_urbs(gspca_dev);
 	gspca_input_destroy_urb(gspca_dev);
-	gspca_set_alt0(gspca_dev);
-	if (gspca_dev->present)
+	if (gspca_dev->present) {
+		gspca_set_alt0(gspca_dev);
 		gspca_input_create_urb(gspca_dev);
-	if (gspca_dev->sd_desc->stop0)
-		gspca_dev->sd_desc->stop0(gspca_dev);
+		if (gspca_dev->sd_desc->stop0)
+			gspca_dev->sd_desc->stop0(gspca_dev);
+	}
 	gspca_dbg(gspca_dev, D_STREAM, "stream off OK\n");
 }
 
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index b0ced2e14006..e0ca120d2e31 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -105,13 +105,13 @@ struct sd_desc {
 	cam_cf_op config;	/* called on probe */
 	cam_op init;		/* called on probe and resume */
 	cam_op init_controls;	/* called on probe */
-	cam_op start;		/* called on stream on after URBs creation */
+	cam_op start;		/* called on stream on after URBs creation. Can't allocate any resources here! */
 	cam_pkt_op pkt_scan;
 /* optional operations */
 	cam_op isoc_init;	/* called on stream on before getting the EP */
 	cam_op isoc_nego;	/* called when URB submit failed with NOSPC */
-	cam_v_op stopN;		/* called on stream off - main alt */
-	cam_v_op stop0;		/* called on stream off & disconnect - alt 0 */
+	cam_v_op stopN;		/* called on stream off, only if usb device is present - main alt */
+	cam_v_op stop0;		/* called on stream off, only if usb device is present - alt 0 */
 	cam_v_op dq_callback;	/* called when a frame has been dequeued */
 	cam_get_jpg_op get_jcomp;
 	cam_set_jpg_op set_jcomp;
-- 
2.20.1

