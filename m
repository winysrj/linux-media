Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252ADC67838
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 01:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05FF208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 01:04:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E05FF208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbeLGBEO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 20:04:14 -0500
Received: from mga04.intel.com ([192.55.52.120]:47525 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbeLGBEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 20:04:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2018 17:04:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,324,1539673200"; 
   d="scan'208";a="127821911"
Received: from twiley-mobl.amr.corp.intel.com (HELO yzhi-desktop.amr.corp.intel.com) ([10.254.183.51])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2018 17:04:12 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com,
        tian.shu.qiu@intel.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, mchehab@kernel.org, bingbu.cao@intel.com,
        jian.xu.zheng@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v8 16/17] media: v4l2-ctrls: Reserve controls for IPU3 ImgU
Date:   Thu,  6 Dec 2018 19:03:41 -0600
Message-Id: <1544144622-29791-17-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544144622-29791-1-git-send-email-yong.zhi@intel.com>
References: <1544144622-29791-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: "Cao,Bing Bu" <bingbu.cao@intel.com>

Add a base to be used for allocation of all the IPU3 specific
controls in the ImgU driver.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Tian Shu Qiu <tian.shu.qiu@intel.com>
---
 include/uapi/linux/v4l2-controls.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 998983a6e6b7..2b52f44d0ba5 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -192,6 +192,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_IMX_BASE			(V4L2_CID_USER_BASE + 0x10b0)
 
+/* The base for the ipu3 ImgU driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_INTEL_IPU3_BASE		(V4L2_CID_USER_BASE + 0x10c0)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
-- 
2.7.4

