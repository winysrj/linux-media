Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERNvl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Guru Das Srinagesh <gurooodas@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/13] staging: media: atomisp: use logical AND, not bitwise
Date: Thu, 18 May 2017 15:50:11 +0200
Message-Id: <20170518135022.6069-3-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guru Das Srinagesh <gurooodas@gmail.com>

Fixes sparse warning "dubious: x & !y" in logical expression.

Signed-off-by: Guru Das Srinagesh <gurooodas@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index a8b93a756e41..ae0b229c9fb8 100644
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
2.13.0
