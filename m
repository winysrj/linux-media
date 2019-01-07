Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A02BC43612
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CF4C2147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfAGLKz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:10:55 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52070 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbfAGLKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:10:55 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 4C245634C80;
        Mon,  7 Jan 2019 13:09:44 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, bingbu.cao@intel.com
Subject: [PATCH 1/2] MAINTAINERS: Update reviewers for ipu3-cio2
Date:   Mon,  7 Jan 2019 13:10:52 +0200
Message-Id: <20190107111053.5708-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190107111053.5708-1-sakari.ailus@linux.intel.com>
References: <20190107111053.5708-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove Jian Xu from the driver's reviewers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e6b8a746b53f..0216fbedae23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7589,7 +7589,6 @@ M:	Yong Zhi <yong.zhi@intel.com>
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 M:	Bingbu Cao <bingbu.cao@intel.com>
 R:	Tian Shu Qiu <tian.shu.qiu@intel.com>
-R:	Jian Xu Zheng <jian.xu.zheng@intel.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/pci/intel/ipu3/
-- 
2.11.0

