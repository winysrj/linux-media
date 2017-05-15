Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19981 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbdEOKBj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 06:01:39 -0400
Date: Mon, 15 May 2017 13:01:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Binderman <dcb314@hotmail.com>,
        Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/2] staging/atomisp: one char read beyond end of string
Message-ID: <20170515100116.mdjkkzxx355irtwq@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0801MB18654EFD46513A845BBD4BAD9CE00@HE1PR0801MB1865.eurprd08.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should verify that "ix < max_len" before we test whether we have
reached the NUL terminator.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
