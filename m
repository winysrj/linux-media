Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32922 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdFGNo4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 09:44:56 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: davinci_vpfe Fix resource leaks in error paths.
Date: Wed,  7 Jun 2017 19:14:34 +0530
Message-Id: <dfa3e12e94585ea9791b942f2ad6e59b97ac8a8c.1496842864.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free memory, if ipipe_s_config and ipipe_g_config are not successful.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 6a3434c..b6994ee 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1286,15 +1286,20 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 			if (to && from && size) {
 				if (copy_from_user(to, from, size)) {
 					rval = -EFAULT;
+					kfree(params);
 					break;
 				}
 				rval = module_if->set(ipipe, to);
-				if (rval)
+				if (rval) {
+					kfree(params);
 					goto error;
+				}
 			} else if (to && !from && size) {
 				rval = module_if->set(ipipe, NULL);
-				if (rval)
+				if (rval) {
+					kfree(params);
 					goto error;
+				}
 			}
 			kfree(params);
 		}
@@ -1328,10 +1333,13 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 
 			if (to && from && size) {
 				rval = module_if->get(ipipe, from);
-				if (rval)
+				if (rval) {
+					kfree(params);
 					goto error;
+				}
 				if (copy_to_user(to, from, size)) {
 					rval = -EFAULT;
+					kfree(params);
 					break;
 				}
 			}
-- 
1.9.1
