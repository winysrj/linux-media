Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.194]:43046 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaHQF2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Aug 2014 01:28:44 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] si2157: Add support for delivery system SYS_ATSC
Date: Sun, 17 Aug 2014 08:24:49 +0300
Message-Id: <1408253089-9487-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the property for delivery system also in case of SYS_ATSC. This 
behaviour is observed in the sniffs taken with Hauppauge HVR-955Q 
Windows driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 6c53edb..3b86d59 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -239,6 +239,9 @@ static int si2157_set_params(struct dvb_frontend *fe)
 		bandwidth = 0x0f;
 
 	switch (c->delivery_system) {
+	case SYS_ATSC:
+			delivery_system = 0x00;
+			break;
 	case SYS_DVBT:
 	case SYS_DVBT2: /* it seems DVB-T and DVB-T2 both are 0x20 here */
 			delivery_system = 0x20;
-- 
1.9.1

