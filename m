Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42226 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753051AbeDLPYT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 07/17] media: cec: fix smatch error
Date: Thu, 12 Apr 2018 11:23:59 -0400
Message-Id: <af0480e284b471bc42919865d3008bb6e451d45d.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

drivers/media/cec/cec-pin-error-inj.c:231
cec_pin_error_inj_parse_line() error: uninitialized symbol 'pos'.

The tx-add-bytes command didn't check for the presence of an argument, and
also didn't check that it was > 0.

This should fix this error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/cec/cec-pin-error-inj.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/cec-pin-error-inj.c b/drivers/media/cec/cec-pin-error-inj.c
index aaa899a175ce..7132a2758bd3 100644
--- a/drivers/media/cec/cec-pin-error-inj.c
+++ b/drivers/media/cec/cec-pin-error-inj.c
@@ -203,16 +203,18 @@ bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line)
 		mode_mask = CEC_ERROR_INJ_MODE_MASK << mode_offset;
 		arg_idx = cec_error_inj_cmds[i].arg_idx;
 
-		if (mode_offset == CEC_ERROR_INJ_RX_ARB_LOST_OFFSET ||
-		    mode_offset == CEC_ERROR_INJ_TX_ADD_BYTES_OFFSET)
-			is_bit_pos = false;
-
 		if (mode_offset == CEC_ERROR_INJ_RX_ARB_LOST_OFFSET) {
 			if (has_op)
 				return false;
 			if (!has_pos)
 				pos = 0x0f;
+			is_bit_pos = false;
+		} else if (mode_offset == CEC_ERROR_INJ_TX_ADD_BYTES_OFFSET) {
+			if (!has_pos || !pos)
+				return false;
+			is_bit_pos = false;
 		}
+
 		if (arg_idx >= 0 && is_bit_pos) {
 			if (!has_pos || pos >= 160)
 				return false;
-- 
2.14.3
