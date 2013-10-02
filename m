Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39098 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3JBWJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 18:09:32 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so1666353wid.2
        for <linux-media@vger.kernel.org>; Wed, 02 Oct 2013 15:09:31 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: mkrufky@linuxtv.org
Cc: crope@iki.fi, linux-media@vger.kernel.org, mchehab@infradead.org,
	Luis Alves <ljalvs@gmail.com>
Subject: [PATCH 2/2] cx24117: Removed from cx23885 the no longer needed frontend pointer from the dvb_attach function.
Date: Wed,  2 Oct 2013 23:09:27 +0100
Message-Id: <1380751767-4891-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx23885 changes: to be used against mkrufky/cx24117 branch

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 34120db..0549205 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1058,20 +1058,13 @@ static int dvb_register(struct cx23885_tsport *port)
 		case 1:
 			fe0->dvb.frontend = dvb_attach(cx24117_attach,
 					&tbs_cx24117_config,
-					&i2c_bus->i2c_adap, NULL);
+					&i2c_bus->i2c_adap);
 			break;
 		/* PORT C */
 		case 2:
-			/* use fe1 pointer as temporary holder */
-			/* for the first frontend */
-			fe1 = videobuf_dvb_get_frontend(
-				&port->dev->ts1.frontends, 1);
-
 			fe0->dvb.frontend = dvb_attach(cx24117_attach,
 					&tbs_cx24117_config,
-					&i2c_bus->i2c_adap, fe1->dvb.frontend);
-			/* we're done, so clear fe1 pointer */
-			fe1 = NULL;
+					&i2c_bus->i2c_adap);
 			break;
 		}
 		break;
-- 
1.7.9.5

