Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERNvq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 11/13] staging: media: atomisp: putting NULs in the wrong place
Date: Thu, 18 May 2017 15:50:20 +0200
Message-Id: <20170518135022.6069-12-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We're putting the NUL terminators one space beyond where they belong.
This doesn't show up in testing because all but the callers put a NUL in
the correct place themselves.  LOL.  It causes a static checker warning
about buffer overflows.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../pci/atomisp2/css2400/hive_isp_css_include/string_support.h        | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
index 74b5a1c7ac9a..c53241a7a281 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
@@ -117,7 +117,7 @@ STORAGE_CLASS_INLINE int strncpy_s(
 
 	/* dest_str is big enough for the len */
 	strncpy(dest_str, src_str, len);
-	dest_str[len+1] = '\0';
+	dest_str[len] = '\0';
 	return 0;
 }
 
@@ -157,7 +157,7 @@ STORAGE_CLASS_INLINE int strcpy_s(
 
 	/* dest_str is big enough for the len */
 	strncpy(dest_str, src_str, len);
-	dest_str[len+1] = '\0';
+	dest_str[len] = '\0';
 	return 0;
 }
 
-- 
2.13.0
