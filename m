Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35832 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdBSR3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 12:29:16 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] cx88: constify mb86a16_config structure
Date: Sun, 19 Feb 2017 22:59:07 +0530
Message-Id: <1487525347-3252-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare mb86a16_config structure as const as it is only passed as
an argument to the function dvb_attach. dvb_attach calls its first
argument on the rest of its arguments. The first argument of
dvb_attach in the changed case is mb86a16_attach and the parameter of
this function to which the object reference is passed is of type
const. So, mb86a16_config structures having this property can be made
const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx88/cx88-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index ddf9067..49a335f 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -306,7 +306,7 @@ static int dntv_live_dvbt_demod_init(struct dvb_frontend *fe)
 	.if2           = 45600,
 };
 
-static struct mb86a16_config twinhan_vp1027 = {
+static const struct mb86a16_config twinhan_vp1027 = {
 	.demod_address  = 0x08,
 };
 
-- 
1.9.1
