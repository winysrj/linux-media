Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37975 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbeCCT04 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 14:26:56 -0500
Date: Sun, 4 Mar 2018 00:56:29 +0530
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: alan@linux.intel.com
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: [PATCH] staging: media: Remove unnecessary semicolon
Message-ID: <20180303192629.GA5198@seema-Inspiron-15-3567>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary semicolon found using semicolon.cocci Coccinelle
script.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 .../media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
index 5faa89a..7562bea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
@@ -196,7 +196,7 @@ enum ia_css_err ia_css_frame_map(struct ia_css_frame **frame,
 						  attribute, context);
 		if (me->data == mmgr_NULL)
 			err = IA_CSS_ERR_INVALID_ARGUMENTS;
-	};
+	}
 
 	if (err != IA_CSS_SUCCESS) {
 		sh_css_free(me);
-- 
2.7.4
