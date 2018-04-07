Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:37480 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751093AbeDGJiy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Apr 2018 05:38:54 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.17] cec: fix smatch error
Message-ID: <c9927424-9467-cdec-60bc-10feaf518164@xs4all.nl>
Date: Sat, 7 Apr 2018 11:38:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/cec/cec-pin-error-inj.c:231
cec_pin_error_inj_parse_line() error: uninitialized symbol 'pos'.

The tx-add-bytes command didn't check for the presence of an argument, and
also didn't check that it was > 0.

This should fix this error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
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
