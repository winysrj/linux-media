Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:42587 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdLZXiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 18:38:06 -0500
Received: by mail-wr0-f196.google.com with SMTP id w107so9724046wrb.9
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 15:38:06 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 3/4] [media] dvb-frontends/stv0910: field and register access helpers
Date: Wed, 27 Dec 2017 00:37:58 +0100
Message-Id: <20171226233759.16116-4-d.scheller.oss@gmail.com>
In-Reply-To: <20171226233759.16116-1-d.scheller.oss@gmail.com>
References: <20171226233759.16116-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add a write_field() function that acts as helper to update specific bits
specified in the field defines (FSTV0910_*) in stv0910_regs.h, which was
recently updated to carry the missing offset values. With that, add the
SET_FIELD(), SET_REG() and GET_REG() macros that wrap the write_field(),
write_reg() and read_reg() functions to allow for making all demod
access code cleaner.

The write_field() function is annotated with __maybe_unused temporarily
to silence eventual compile warnings.

Picked up from the dddvb upstream, with the macro names made uppercase
so they are distinguishable as such.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 06d2587125dd..5fed22685e28 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -194,6 +194,34 @@ static int write_shared_reg(struct stv *state, u16 reg, u8 mask, u8 val)
 	return status;
 }
 
+static int __maybe_unused write_field(struct stv *state, u32 field, u8 val)
+{
+	int status;
+	u8 shift, mask, old, new;
+
+	status = read_reg(state, field >> 16, &old);
+	if (status)
+		return status;
+	mask = field & 0xff;
+	shift = (field >> 12) & 0xf;
+	new = ((val << shift) & mask) | (old & ~mask);
+	if (new == old)
+		return 0;
+	return write_reg(state, field >> 16, new);
+}
+
+#define SET_FIELD(_reg, _val)					\
+	write_field(state, state->nr ? FSTV0910_P2_##_reg :	\
+		    FSTV0910_P1_##_reg, _val)
+
+#define SET_REG(_reg, _val)					\
+	write_reg(state, state->nr ? RSTV0910_P2_##_reg :	\
+		  RSTV0910_P1_##_reg, _val)
+
+#define GET_REG(_reg, _val)					\
+	read_reg(state, state->nr ? RSTV0910_P2_##_reg :	\
+		 RSTV0910_P1_##_reg, _val)
+
 static const struct slookup s1_sn_lookup[] = {
 	{   0,    9242  }, /* C/N=   0dB */
 	{   5,    9105  }, /* C/N= 0.5dB */
-- 
2.13.6
