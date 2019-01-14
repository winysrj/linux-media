Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941DFC43444
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6513A20651
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfANONl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:13:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:14554 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfANONl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:13:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 06:13:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,477,1539673200"; 
   d="scan'208";a="134433974"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jan 2019 06:13:39 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 1D03820376;
        Mon, 14 Jan 2019 16:13:38 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gj2zF-0007dq-Ba; Mon, 14 Jan 2019 16:13:09 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/4] Update static build instructions
Date:   Mon, 14 Jan 2019 16:13:05 +0200
Message-Id: <20190114141308.29329-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
References: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It appears that the required libraries may depend on whether linking is
done statically or dynamically. The pkg-config thus needs to know. Update
the instructions accordingly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 INSTALL | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/INSTALL b/INSTALL
index d55f56cd9f..b7546aa61e 100644
--- a/INSTALL
+++ b/INSTALL
@@ -62,12 +62,10 @@ using an option for disabling shared libraries:
 	$ LDFLAGS="--static -static" ./configure --disable-shared
 
 Note that this requires static variants of all the libraries needed for
-linking which may not be available in all systems.
+linking which may not be available in all systems. Then run the configure
+script as follows:
 
-In order to build binaries that are not dependent on libraries contained
-in v4l-utils, simply use the --disable-shared option:
-
-	$ ./configure --disable-shared
+	$ PKG_CONFIG="pkg-config --static" ./configure --disable-shared
 
 Android Cross Compiling and Installing:
 ----------------
-- 
2.11.0

