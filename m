Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3360C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9D720651
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfANONm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:13:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:55416 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfANONl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:13:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 06:13:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,477,1539673200"; 
   d="scan'208";a="108113358"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006.jf.intel.com with ESMTP; 14 Jan 2019 06:13:39 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id CE3832050A;
        Mon, 14 Jan 2019 16:13:38 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gj2zG-0007dt-1D; Mon, 14 Jan 2019 16:13:10 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 2/4] Sync the latest headers
Date:   Mon, 14 Jan 2019 16:13:06 +0200
Message-Id: <20190114141308.29329-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
References: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Just import changes brought by patch "v4l: uAPI: V4L2_BUF_TYPE_META_OUTPUT
is an output buffer type". This is needed by further metadata output
patches.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/linux/videodev2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index aac4b75280..6b1d780fd8 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -159,7 +159,8 @@ enum v4l2_buf_type {
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

