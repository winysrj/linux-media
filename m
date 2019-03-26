Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9855CC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 09:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6741120863
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 09:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfCZJ1O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:27:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:1588 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfCZJ1O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 05:27:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 02:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="217618540"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 26 Mar 2019 02:27:12 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id ADD60200E2;
        Tue, 26 Mar 2019 11:27:11 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1h8iM0-0002qB-VJ; Tue, 26 Mar 2019 11:26:45 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/1] MAINTAINERS: Fix files for obsolete SoC camera framework
Date:   Tue, 26 Mar 2019 11:26:44 +0200
Message-Id: <20190326092644.10881-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The SoC camera was moved to the staging tree but we missed updating
MAINTAINERS. Do that now.

Reported-by: Joe Perches <joe@perches.com>
Fixes: 280de94a6519 ("media: soc_camera: Move to the staging tree")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Thanks, Joe, for reporting this!

 MAINTAINERS | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e17ebf70b5480..c6c15de0583f2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14325,9 +14325,8 @@ SOC-CAMERA V4L2 SUBSYSTEM
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Orphan
-F:	include/media/soc*
-F:	drivers/media/i2c/soc_camera/
-F:	drivers/media/platform/soc_camera/
+F:	include/media/soc_camera.h
+F:	drivers/staging/media/soc_camera/
 
 SOCIONEXT SYNQUACER I2C DRIVER
 M:	Ard Biesheuvel <ard.biesheuvel@linaro.org>
-- 
2.11.0

