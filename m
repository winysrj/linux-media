Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51563 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbaJaNT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:19:58 -0400
Received: by mail-pa0-f47.google.com with SMTP id kx10so7708171pab.20
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:19:57 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2] dvb-core: set default properties of ISDB-S
Date: Fri, 31 Oct 2014 22:19:39 +0900
Message-Id: <1414761579-1311-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c862ad7..95d6296 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -962,6 +962,11 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	case SYS_ATSC:
 		c->modulation = VSB_8;
 		break;
+	case SYS_ISDBS:
+		c->symbol_rate = 28860000;
+		c->rolloff = ROLLOFF_35;
+		c->bandwidth_hz = c->symbol_rate / 100 * 135;
+		break;
 	default:
 		c->modulation = QAM_AUTO;
 		break;
@@ -2074,6 +2079,7 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBS:
 	case SYS_TURBO:
+	case SYS_ISDBS:
 		rolloff = 135;
 		break;
 	case SYS_DVBS2:
-- 
2.1.3

