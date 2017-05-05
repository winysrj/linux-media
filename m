Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36686 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbdEEAcK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 20:32:10 -0400
From: Fabrizio Perria <fabrizio.perria@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>, Arnd Bergmann <arnd@arndb.de>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Fabrizio Perria <fabrizio.perria@gmail.com>
Subject: [PATCH] staging: media: atomisp: Fix unnecessary initialization of static
Date: Thu,  4 May 2017 20:31:15 -0400
Message-Id: <1493944307-22082-1-git-send-email-fabrizio.perria@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix checkpatch warning: removed unnecessary initialization of
static variable "skip_fwload" to 0 in source atomisp_v4l2.c

Signed-off-by: Fabrizio Perria <fabrizio.perria@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index e3fdbdb..a047807 100644
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
1.9.1
