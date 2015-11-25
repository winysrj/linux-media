Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:33800 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbKYWir (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 17:38:47 -0500
Received: by ykfs79 with SMTP id s79so72690213ykf.1
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2015 14:38:46 -0800 (PST)
Date: Wed, 25 Nov 2015 22:38:43 +0000
From: Joseph Marrero <jmarrero@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH] This patch fixes the following WARNING: Block comments use *
 on the subsequent lines This WARNING was found using the checkpatch tool.
Message-ID: <20151125223843.GA2356@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[PATCH] This patch fixes the following WARNING: 
Block comments use * on the subsequent lines This WARNING was found using the checkpatch tool.

This is my third patch submition, I am following the kernel newbies website. 
While these patches are very basic any feedback is highly apreciated as I would like to continue
to contribute cleanups like this until I learn the process well and feel confortable to move 
into code changes beyond the warnings. 

Thank you in advance.

Signed-off-by: Joseph Marrero <jmarrero@gmail.com>
---
 drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
index 7b7e7b2..3cc9be7 100644
--- a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
+++ b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
@@ -538,7 +538,7 @@ struct vpfe_isif_raw_config {
 };
 
 /**********************************************************************
-      IPIPE API Structures
+*      IPIPE API Structures
 **********************************************************************/
 
 /* IPIPE module configurations */
-- 
2.5.0

