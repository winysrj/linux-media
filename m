Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35228 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162712AbdD3S35 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Apr 2017 14:29:57 -0400
From: Guru Das Srinagesh <gurooodas@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: use logical AND, not bitwise
Date: Sun, 30 Apr 2017 11:29:49 -0700
Message-Id: <1493576989-26048-1-git-send-email-gurooodas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes sparse warning "dubious: x & !y" in logical expression.

Signed-off-by: Guru Das Srinagesh <gurooodas@gmail.com>
---
 .../media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index 34ca534..44b2aff 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
@@ -1658,7 +1658,7 @@ ia_css_binary_find(struct ia_css_binary_descr *descr,
 			candidate->internal.max_height);
 			continue;
 		}
-		if (!candidate->enable.ds && need_ds & !(xcandidate->num_output_pins > 1)) {
+		if (!candidate->enable.ds && need_ds && !(xcandidate->num_output_pins > 1)) {
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
 				"ia_css_binary_find() [%d] continue: !%d && %d\n",
 				__LINE__, candidate->enable.ds, (int)need_ds);
-- 
2.7.4
