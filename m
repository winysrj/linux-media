Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18359 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdEOJ6U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 05:58:20 -0400
Date: Mon, 15 May 2017 12:56:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/2] staging/atomisp: one char read beyond end of string
Message-ID: <20170515095658.fuopb2q7rtfvjypo@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
