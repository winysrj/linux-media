Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE52C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AC5920645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AC5920645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbeLMJvZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:25 -0500
Received: from mga04.intel.com ([192.55.52.120]:43354 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbeLMJvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="101204859"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2018 01:51:22 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id C53DE20FC2;
        Thu, 13 Dec 2018 11:51:21 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNeJ-0003uJ-Gz; Thu, 13 Dec 2018 11:51:19 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 22/22] staging/ipu3-imgu: Add MAINTAINERS entry
Date:   Thu, 13 Dec 2018 11:51:07 +0200
Message-Id: <20181213095107.14894-23-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add a MAINTAINERS entry for the ImgU driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e9f1710ed13e..9ed5cff35e075 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7587,6 +7587,14 @@ S:	Maintained
 F:	drivers/media/pci/intel/ipu3/
 F:	Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 
+INTEL IPU3 CSI-2 IMGU DRIVER
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/staging/media/ipu3/
+F:	Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
+F:	Documentation/media/v4l-drivers/ipu3.rst
+
 INTEL IXP4XX QMGR, NPE, ETHERNET and HSS SUPPORT
 M:	Krzysztof Halasa <khalasa@piap.pl>
 S:	Maintained
-- 
2.11.0

