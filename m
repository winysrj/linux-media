Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm33-vm3.bullet.mail.ir2.yahoo.com ([212.82.97.108]:56298 "EHLO
	nm33-vm3.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbbL2Qev convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 11:34:51 -0500
From: =?ISO-8859-1?Q?Jos=E9_David_Moreno_Ju=E1rez?=
	<jose.david@morenojuarez.nom.es>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] cx88-dvb: Changed tuner associated with board Hauppauge HVR-4000 from TUNER_PHILIPS_FMD1216ME_MK3 to TUNER_PHILIPS_FMD1216MEX_MK3
Date: Tue, 29 Dec 2015 17:26:41 +0100
Message-ID: <2691391.45DzHjqa9H@sisifo>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The correct tuner for the board Hauppauge HVR-4000 seems to be FMD1216MEX MK3 
instead of FMD1216ME MK3. The tuner is identified as such by tveeprom:
	Dec 28 23:01:15 [kernel] tveeprom 8-0050: tuner model is Philips 
FMD1216MEX (idx 133, type 78)

This patch fixes a longstanding warning message issued by tuner-simple:
	Dec 28 23:01:15 [kernel] tuner-simple 8-0061: couldn't set type to 63. 
Using 78 (Philips FMD1216MEX MK3 Hybrid Tuner) instead

It has been successfully tested against kernel 4.1.12.



Signed-off-by: José David Moreno Juárez <jose.david@morenojuarez.nom.es>
---
 drivers/media/pci/cx88/cx88-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-
dvb.c
index afb2075..ac2ad00 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1474,7 +1474,7 @@ static int dvb_register(struct cx8802_dev *dev)
 			if (!dvb_attach(simple_tuner_attach,
 					fe1->dvb.frontend,
 					&dev->core->i2c_adap,
-					0x61, TUNER_PHILIPS_FMD1216ME_MK3))
+					0x61, TUNER_PHILIPS_FMD1216MEX_MK3))
 				goto frontend_detach;
 		}
 		break;
-- 
2.4.10
