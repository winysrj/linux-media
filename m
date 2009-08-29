Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:46255 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZH2S0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 14:26:21 -0400
Received: by ewy2 with SMTP id 2so2963981ewy.17
        for <linux-media@vger.kernel.org>; Sat, 29 Aug 2009 11:26:22 -0700 (PDT)
Message-ID: <4A997415.7010407@gmail.com>
Date: Sat, 29 Aug 2009 20:31:49 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] V4L/DVB (12098): dereference of state->internal in fe_stv0900_error
 stv0900_init_internal()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

state->internal allocation may fail as well as the allocation of
stv0900_first_inode or new_node->next_inode in append_internal().

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this the right thing to do if temp_int == NULL?

diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index 1da045f..b0aaf90 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1407,7 +1407,14 @@ static enum fe_stv0900_error stv0900_init_internal(struct dvb_frontend *fe,
 		return STV0900_NO_ERROR;
 	} else {
 		state->internal = kmalloc(sizeof(struct stv0900_internal), GFP_KERNEL);
+		if (state->internal == NULL)
+			return STV0900_INVALID_HANDLE;
 		temp_int = append_internal(state->internal);
+		if (temp_int == NULL) {
+			kfree(state->internal);
+			state->internal == NULL;
+			return STV0900_INVALID_HANDLE;
+		}
 		state->internal->dmds_used = 1;
 		state->internal->i2c_adap = state->i2c_adap;
 		state->internal->i2c_addr = state->config->demod_address;
