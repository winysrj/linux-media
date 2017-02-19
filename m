Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35238 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbdBSRjQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 12:39:16 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] pci: mantis: constify mb86a16_config structure
Date: Sun, 19 Feb 2017 23:09:06 +0530
Message-Id: <1487525946-5683-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare mb86a16_config structure as const as it is either passed as
an argument to the function dvb_attach or is dereferenced. dvb_attach
calls its first argument on the rest of its arguments. The first argument
of dvb_attach in the changed case is mb86a16_attach and the parameter of
this function to which the object reference is passed is of type
const. So, mb86a16_config structures having this property can be made
const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/mantis/mantis_vp1034.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/mantis/mantis_vp1034.c b/drivers/media/pci/mantis/mantis_vp1034.c
index 3b19285..e4972ff 100644
--- a/drivers/media/pci/mantis/mantis_vp1034.c
+++ b/drivers/media/pci/mantis/mantis_vp1034.c
@@ -36,7 +36,7 @@
 #include "mantis_vp1034.h"
 #include "mantis_reg.h"
 
-static struct mb86a16_config vp1034_mb86a16_config = {
+static const struct mb86a16_config vp1034_mb86a16_config = {
 	.demod_address	= 0x08,
 	.set_voltage	= vp1034_set_voltage,
 };
-- 
1.9.1
