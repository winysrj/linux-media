Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:33907 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966644AbcCPLDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 07:03:00 -0400
Received: by mail-lb0-f194.google.com with SMTP id vk4so3113767lbb.1
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 04:02:59 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] ds3000: return meaningful return codes
Date: Wed, 16 Mar 2016 13:02:50 +0200
Message-Id: <1458126171-13871-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ds3000 driver returned 1 as an error code in many places.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/ds3000.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index e8fc032..addffc3 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -458,7 +458,7 @@ static int ds3000_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 		break;
 	default:
-		return 1;
+		return -EINVAL;
 	}
 
 	if (state->config->set_lock_led)
@@ -528,7 +528,7 @@ static int ds3000_read_ber(struct dvb_frontend *fe, u32* ber)
 			*ber = 0xffffffff;
 		break;
 	default:
-		return 1;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -623,7 +623,7 @@ static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
 				snr_reading, *snr);
 		break;
 	default:
-		return 1;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -661,7 +661,7 @@ static int ds3000_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 		state->prevUCBS2 = _ucblocks;
 		break;
 	default:
-		return 1;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -754,7 +754,7 @@ static int ds3000_send_diseqc_msg(struct dvb_frontend *fe,
 		data |= 0x80;
 		ds3000_writereg(state, 0xa2, data);
 
-		return 1;
+		return -ETIMEDOUT;
 	}
 
 	data = ds3000_readreg(state, 0xa2);
@@ -808,7 +808,7 @@ static int ds3000_diseqc_send_burst(struct dvb_frontend *fe,
 		data |= 0x80;
 		ds3000_writereg(state, 0xa2, data);
 
-		return 1;
+		return -ETIMEDOUT;
 	}
 
 	data = ds3000_readreg(state, 0xa2);
@@ -951,7 +951,7 @@ static int ds3000_set_frontend(struct dvb_frontend *fe)
 			ds3000_writereg(state, 0xfe, 0x98);
 		break;
 	default:
-		return 1;
+		return -EINVAL;
 	}
 
 	/* enable 27MHz clock output */
-- 
1.9.1

