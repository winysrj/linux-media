Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B97BC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF9820659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfANOCe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:02:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:42081 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfANOCe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:02:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 06:02:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,477,1539673200"; 
   d="scan'208";a="114547598"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 14 Jan 2019 06:02:24 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 322872010E;
        Mon, 14 Jan 2019 16:02:23 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gj2oM-0004al-Hb; Mon, 14 Jan 2019 16:01:54 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, yong.zhi@intel.com, rajmohan.mani@intel.com
Subject: [PATCH 1/1] v4l: uAPI: V4L2_BUF_TYPE_META_OUTPUT is an output buffer type
Date:   Mon, 14 Jan 2019 16:01:54 +0200
Message-Id: <20190114140154.17613-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

V4L2_BUF_TYPE_META_OUTPUT was added by patch 72148d1a57e7 but the patch
missed adding the type to the macro telling whether a given type is an
output type or not. Do that now. Getting this wrong leads to handling the
buffer as a capture buffer in a lot of places.

Fixes: 72148d1a57e7 ("media: v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT")

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Hans,

I haven't tested this a lot yet but it seems rather obvious.

 include/uapi/linux/videodev2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index b6afa28eb092a..c5e268fedeac3 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -161,7 +161,8 @@ enum v4l2_buf_type {
 	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY	\
 	 || (type) == V4L2_BUF_TYPE_VBI_OUTPUT			\
 	 || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT		\
-	 || (type) == V4L2_BUF_TYPE_SDR_OUTPUT)
+	 || (type) == V4L2_BUF_TYPE_SDR_OUTPUT			\
+	 || (type) == V4L2_BUF_TYPE_META_OUTPUT)
 
 enum v4l2_tuner_type {
 	V4L2_TUNER_RADIO	     = 1,
-- 
2.11.0

