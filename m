Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29439C43444
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECCE02147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfAGLKz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:10:55 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52072 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726906AbfAGLKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:10:55 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 60ED5634C83;
        Mon,  7 Jan 2019 13:09:44 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, bingbu.cao@intel.com
Subject: [PATCH 2/2] ipu3-cio2, dw9714: Remove Jian Xu's e-mail
Date:   Mon,  7 Jan 2019 13:10:53 +0200
Message-Id: <20190107111053.5708-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190107111053.5708-1-sakari.ailus@linux.intel.com>
References: <20190107111053.5708-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Jian Xu has left the company. Remove his e-mail address that no longer
works.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/dw9714.c               | 2 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 26d83693a681..3f0b082f863f 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -267,7 +267,7 @@ static struct i2c_driver dw9714_i2c_driver = {
 module_i2c_driver(dw9714_i2c_driver);
 
 MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
-MODULE_AUTHOR("Jian Xu Zheng <jian.xu.zheng@intel.com>");
+MODULE_AUTHOR("Jian Xu Zheng");
 MODULE_AUTHOR("Yuning Pu <yuning.pu@intel.com>");
 MODULE_AUTHOR("Jouni Ukkonen <jouni.ukkonen@intel.com>");
 MODULE_AUTHOR("Tommi Franttila <tommi.franttila@intel.com>");
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 447baaebca44..eaf9661d30e3 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -2047,7 +2047,7 @@ module_pci_driver(cio2_pci_driver);
 
 MODULE_AUTHOR("Tuukka Toivonen <tuukka.toivonen@intel.com>");
 MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
-MODULE_AUTHOR("Jian Xu Zheng <jian.xu.zheng@intel.com>");
+MODULE_AUTHOR("Jian Xu Zheng");
 MODULE_AUTHOR("Yuning Pu <yuning.pu@intel.com>");
 MODULE_AUTHOR("Yong Zhi <yong.zhi@intel.com>");
 MODULE_LICENSE("GPL v2");
-- 
2.11.0

