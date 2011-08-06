Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51330 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1HFIBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 04:01:51 -0400
Date: Sat, 6 Aug 2011 01:01:51 -0700
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] dib9000: return error code on failure
Message-ID: <20110806080151.GB28348@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ret = -EIO needs to be before the goto.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index a085588..01e6b0c 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -1167,8 +1167,8 @@ static int dib9000_fw_get_channel(struct dvb_frontend *fe, struct dvb_frontend_p
 
 	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
-		goto error;
 		ret = -EIO;
+		goto error;
 	}
 
 	dib9000_risc_mem_read(state, FE_MM_R_CHANNEL_UNION,
