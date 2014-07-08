Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:39396 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852AbaGHRZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 13:25:21 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1] xc2028: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 19:25:17 +0200
Message-Id: <1404840317-29960-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/tuners/tuner-xc2028.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 6ef93ee..565eeeb 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1489,7 +1489,6 @@ struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
 	case 0:
 		/* memory allocation failure */
 		goto fail;
-		break;
 	case 1:
 		/* new tuner instance */
 		priv->ctrl.max_len = 13;
-- 
1.8.4.5

