Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERNvo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/13] staging: media: atomisp: one char read beyond end of string
Date: Thu, 18 May 2017 15:50:19 +0200
Message-Id: <20170518135022.6069-11-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We should verify that "ix < max_len" before we test whether we have
reached the NUL terminator.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../pci/atomisp2/css2400/hive_isp_css_include/string_support.h       | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
index 568631698a3d..74b5a1c7ac9a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/string_support.h
@@ -72,9 +72,8 @@ static size_t strnlen_s(
 		return 0;
 	}
 
-	for (ix=0;
-		((src_str[ix] != '\0') && (ix< max_len));
-		++ix) /*Nothing else to do*/;
+	for (ix = 0; ix < max_len && src_str[ix] != '\0'; ix++)
+		;
 
 	/* On Error, it will return src_size == max_len*/
 	return ix;
-- 
2.13.0
