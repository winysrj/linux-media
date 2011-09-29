Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16870 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1I2GKh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 02:10:37 -0400
Date: Thu, 29 Sep 2011 09:10:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <Patrick.Boettcher@dibcom.fr>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	Jesper Juhl <jj@chaosbits.net>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] dib9000: release a lock on error
Message-ID: <20110929061006.GB4104@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This lock should be released as well on the error path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index e276b11..660f806 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -2169,6 +2169,7 @@ static int dib9000_read_ber(struct dvb_frontend *fe, u32 * ber)
 	DibAcquireLock(&state->demod_lock);
 	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
+		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
 		goto error;
 	}
