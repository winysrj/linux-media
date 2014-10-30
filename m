Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49127 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904AbaJ3Kn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 06:43:26 -0400
Received: by mail-lb0-f178.google.com with SMTP id f15so4531205lbj.9
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 03:43:24 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] si2157: add support for SYS_DVBC_ANNEX_B
Date: Thu, 30 Oct 2014 12:43:16 +0200
Message-Id: <1414665796-22123-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the property for delivery system also in case of SYS_DVBC_ANNEX_B. This behaviour is observed in the sniffs taken with Hauppauge HVR-955Q Windows driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index cf97142..b086b87 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -250,6 +250,9 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	case SYS_ATSC:
 			delivery_system = 0x00;
 			break;
+	case SYS_DVBC_ANNEX_B:
+			delivery_system = 0x10;
+			break;
 	case SYS_DVBT:
 	case SYS_DVBT2: /* it seems DVB-T and DVB-T2 both are 0x20 here */
 			delivery_system = 0x20;
-- 
1.9.1

