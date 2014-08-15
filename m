Return-path: <linux-media-owner@vger.kernel.org>
Received: from frv151.fwdcdn.com ([212.42.77.151]:60103 "EHLO
	frv150.fwdcdn.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbaHOTlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 15:41:24 -0400
Message-ID: <1408130600.4103.2.camel@ubuntu>
Subject: [PATCH] media: stv0367: fix frontend modulation initialization with
 FE_CAB_MOD_QAM256
From: Maks Naumov <maksqwe1@ukr.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Fri, 15 Aug 2014 12:23:20 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maks Naumov <maksqwe1@ukr.net>
---
 drivers/media/dvb-frontends/stv0367.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 59b6e66..0dcfb8b 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -3165,7 +3165,7 @@ static int stv0367cab_get_frontend(struct dvb_frontend *fe)
 	case FE_CAB_MOD_QAM128:
 		p->modulation = QAM_128;
 		break;
-	case QAM_256:
+	case FE_CAB_MOD_QAM256:
 		p->modulation = QAM_256;
 		break;
 	default:
-- 
1.9.1



