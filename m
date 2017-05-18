Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754754AbdERNv1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Fabrizio Perria <fabrizio.perria@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/13] staging: media: atomisp: Fix unnecessary initialization of static
Date: Thu, 18 May 2017 15:50:12 +0200
Message-Id: <20170518135022.6069-4-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabrizio Perria <fabrizio.perria@gmail.com>

Fix checkpatch warning: removed unnecessary initialization of
static variable "skip_fwload" to 0 in source atomisp_v4l2.c

Signed-off-by: Fabrizio Perria <fabrizio.perria@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index e3fdbdba0b34..a0478077a012 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -51,7 +51,7 @@
 /* G-Min addition: pull this in from intel_mid_pm.h */
 #define CSTATE_EXIT_LATENCY_C1  1
 
-static uint skip_fwload = 0;
+static uint skip_fwload;
 module_param(skip_fwload, uint, 0644);
 MODULE_PARM_DESC(skip_fwload, "Skip atomisp firmware load");
 
-- 
2.13.0
