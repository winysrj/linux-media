Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65233 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaJZMBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 08:01:30 -0400
Received: by mail-pa0-f44.google.com with SMTP id bj1so159898pad.31
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 05:01:30 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] dvb-core: set default properties of ISDB-S
Date: Sun, 26 Oct 2014 21:01:14 +0900
Message-Id: <1414324874-16417-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

delsys-fixed props should be set in dvb-core instead of in each driver.
---
 drivers/media/dvb-core/dvb_frontend.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c862ad7..1e9b814 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -962,6 +962,10 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	case SYS_ATSC:
 		c->modulation = VSB_8;
 		break;
+	case SYS_ISDBS:
+		c->symbol_rate = 28860000;
+		c->rolloff = ROLLOFF_35;
+		break;
 	default:
 		c->modulation = QAM_AUTO;
 		break;
@@ -2074,6 +2078,7 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBS:
 	case SYS_TURBO:
+	case SYS_ISDBS:
 		rolloff = 135;
 		break;
 	case SYS_DVBS2:
-- 
2.1.2

