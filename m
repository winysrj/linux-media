Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42261 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HSJu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 05:50:26 -0400
Date: Thu, 19 Aug 2010 11:50:04 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: pvrusb2: remove unneeded NULL checks
Message-ID: <20100819095004.GN645@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

We dereference "maskptr" unconditionally at the start of the function
and also inside the call to parse_tlist() towards the end of the
function.  This function is called from store_val_any() and it always
passes a non-NULL pointer. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
index 1b992b8..55ea914 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
@@ -513,7 +513,7 @@ int pvr2_ctrl_sym_to_value(struct pvr2_ctrl *cptr,
 			if (ret >= 0) {
 				ret = pvr2_ctrl_range_check(cptr,*valptr);
 			}
-			if (maskptr) *maskptr = ~0;
+			*maskptr = ~0;
 		} else if (cptr->info->type == pvr2_ctl_bool) {
 			ret = parse_token(ptr,len,valptr,boolNames,
 					  ARRAY_SIZE(boolNames));
@@ -522,7 +522,7 @@ int pvr2_ctrl_sym_to_value(struct pvr2_ctrl *cptr,
 			} else if (ret == 0) {
 				*valptr = (*valptr & 1) ? !0 : 0;
 			}
-			if (maskptr) *maskptr = 1;
+			*maskptr = 1;
 		} else if (cptr->info->type == pvr2_ctl_enum) {
 			ret = parse_token(
 				ptr,len,valptr,
@@ -531,7 +531,7 @@ int pvr2_ctrl_sym_to_value(struct pvr2_ctrl *cptr,
 			if (ret >= 0) {
 				ret = pvr2_ctrl_range_check(cptr,*valptr);
 			}
-			if (maskptr) *maskptr = ~0;
+			*maskptr = ~0;
 		} else if (cptr->info->type == pvr2_ctl_bitmask) {
 			ret = parse_tlist(
 				ptr,len,maskptr,valptr,
