Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691E6C43444
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A3F020651
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfANONn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:13:43 -0500
Received: from mga06.intel.com ([134.134.136.31]:53546 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfANONm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:13:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 06:13:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,477,1539673200"; 
   d="scan'208";a="116635539"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2019 06:13:40 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 6B225209F0;
        Mon, 14 Jan 2019 16:13:39 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gj2zG-0007dw-P8; Mon, 14 Jan 2019 16:13:10 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 3/4] v4l2-ctl: Print metadata capture formats on --all
Date:   Mon, 14 Jan 2019 16:13:07 +0200
Message-Id: <20190114141308.29329-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
References: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Printing metadata formats was supported separately with
--list-formats-meta but no meta formats were printed with --all option.
Fix this.

Fixes: b3f1cf6b8519 ("v4l2-compliance/v4l2-ctl: support V4L2_CTRL_FLAG_MODIFY_LAYOUT and metadata")

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/v4l2-ctl/v4l2-ctl.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index a65262f65e..1783979d76 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -1246,6 +1246,7 @@ int main(int argc, char **argv)
 		options[OptGetSlicedVbiOutFormat] = 1;
 		options[OptGetSdrFormat] = 1;
 		options[OptGetSdrOutFormat] = 1;
+		options[OptGetMetaFormat] = 1;
 		options[OptGetFBuf] = 1;
 		options[OptGetCropCap] = 1;
 		options[OptGetOutputCropCap] = 1;
-- 
2.11.0

