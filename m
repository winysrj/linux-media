Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800B7C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 12:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4909220870
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 12:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfAVMaK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:30:10 -0500
Received: from mga18.intel.com ([134.134.136.126]:21203 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMaK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 07:30:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 04:30:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="127902083"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga002.jf.intel.com with ESMTP; 22 Jan 2019 04:30:09 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 46E3F2042C;
        Tue, 22 Jan 2019 14:30:08 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1glvBM-0005K1-T0; Tue, 22 Jan 2019 14:29:32 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 1/1] Fix static build instructions
Date:   Tue, 22 Jan 2019 14:29:32 +0200
Message-Id: <20190122122932.20419-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 5d0be9455254 updated the static build instructions but failed to
properly elaborate the use of PKG_CONFIG and LDFLAGS environment variables
as their effects. Do that now.

Fixes: 5d0be9455254 ("Update static build instructions")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 INSTALL | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/INSTALL b/INSTALL
index b7546aa61e..099c968c9f 100644
--- a/INSTALL
+++ b/INSTALL
@@ -56,17 +56,26 @@ make
 Building static binaries:
 -------------------------
 
-Fully static binares can be built by setting LDFLAGS for the configure and
-using an option for disabling shared libraries:
+There are two options in building static binaries: either fully static or
+dynamically linking to system shared libraries while statically linking
+libraries that are a part of v4l-utils.
 
-	$ LDFLAGS="--static -static" ./configure --disable-shared
-
-Note that this requires static variants of all the libraries needed for
-linking which may not be available in all systems. Then run the configure
-script as follows:
+In either case, building static binaries requires telling pkg-config the
+static libraries will be needed, and telling configure to disable building
+of shared libraries. This way system libraries will still be linked
+dynamically:
 
 	$ PKG_CONFIG="pkg-config --static" ./configure --disable-shared
 
+Fully static binares can be built by further setting LDFLAGS for the
+configure:
+
+	$ PKG_CONFIG="pkg-config --static" LDFLAGS="--static -static" \
+	  ./configure --disable-shared
+
+Note that this requires static variants of all the libraries needed for
+linking which may not be available in all systems.
+
 Android Cross Compiling and Installing:
 ----------------
 
-- 
2.11.0

