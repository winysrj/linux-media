Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:60154 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CIVNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 16:13:53 -0500
Date: Tue, 9 Mar 2010 22:13:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/media: drop redundant memset
Message-ID: <Pine.LNX.4.64.1003092213280.4974@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

The region set by the call to memset is immediately overwritten by the
subsequent call to memcpy.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3,e4;
@@

- memset(e1,e2,e3);
  memcpy(e1,e4,e3);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/dvb/bt8xx/dst.c |    2 --
 1 file changed, 2 deletions(-)

diff -u -p a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -930,7 +930,6 @@ static int dst_fw_ver(struct dst_state *
 		dprintk(verbose, DST_INFO, 1, "Unsupported Command");
 		return -1;
 	}
-	memset(&state->fw_version, '\0', 8);
 	memcpy(&state->fw_version, &state->rxbuffer, 8);
 	dprintk(verbose, DST_ERROR, 1, "Firmware Ver = %x.%x Build = %02x, on %x:%x, %x-%x-20%02x",
 		state->fw_version[0] >> 4, state->fw_version[0] & 0x0f,
@@ -1053,7 +1052,6 @@ static int dst_get_tuner_info(struct dst
 			goto force;
 		}
 	}
-	memset(&state->board_info, '\0', 8);
 	memcpy(&state->board_info, &state->rxbuffer, 8);
 	if (state->type_flags & DST_TYPE_HAS_MULTI_FE) {
 		dprintk(verbose, DST_ERROR, 1, "DST type has TS=188");
