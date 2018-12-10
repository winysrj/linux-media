Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFC8C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA3DF204FD
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA3DF204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbeLJVUi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 16:20:38 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59432 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727934AbeLJVUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 16:20:38 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 813C4634C84;
        Mon, 10 Dec 2018 23:20:32 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com
Subject: [v4l-utils PATCH 1/2] Update uAPI headers from the kernel
Date:   Mon, 10 Dec 2018 23:20:35 +0200
Message-Id: <20181210212036.16643-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181210212036.16643-1-sakari.ailus@linux.intel.com>
References: <20181210212036.16643-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This brings the META_OUTPUT buffer type as well as the related capability.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/linux/videodev2.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9350bdc1..6aae99ea 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -143,6 +143,7 @@ enum v4l2_buf_type {
 	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
 	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
 	V4L2_BUF_TYPE_META_CAPTURE         = 13,
+	V4L2_BUF_TYPE_META_OUTPUT	   = 14,
 	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
@@ -463,6 +464,7 @@ struct v4l2_capability {
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
+#define V4L2_CAP_META_OUTPUT		0x08000000  /* Is a metadata output device */
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
 
-- 
2.11.0

