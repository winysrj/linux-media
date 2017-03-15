Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33056 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdCOGAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 02:00:06 -0400
Date: Wed, 15 Mar 2017 14:55:58 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] staging: atomisp: remove useless #ifdef ISP2401 on top
 of atomisp_cmd.c
Message-ID: <20170315055558.GA8601@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no reason to have "#ifdef ISP2401" condition
on top of atomisp_cmd.c file

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 6160119..82e7382 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -1,6 +1,3 @@
-#ifdef ISP2401
-
-#endif
 /*
  * Support for Medifield PNW Camera Imaging ISP subsystem.
  *
-- 
1.9.1
