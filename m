Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:41970
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751987AbcGAC3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 22:29:14 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media][cxd2841er] fix compilation warning
Date: Thu, 30 Jun 2016 22:28:57 -0400
Message-Id: <1467340137-3057-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

function cxd2841er_init_stats should return int value

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 8705b0a..22c6836 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3422,6 +3422,7 @@ static int cxd2841er_init_stats(struct dvb_frontend *fe)
 	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->post_bit_error.len = 1;
 	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	return 0;
 }
 
 
-- 
2.7.4

