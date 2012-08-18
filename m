Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24530 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2HRQAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 12:00:44 -0400
Date: Sat, 18 Aug 2012 18:58:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Luis Henriques <luis.henriques@canonical.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] rc: divide by zero bugs in s_tx_carrier()
Message-ID: <20120818155850.GA11819@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"carrier" comes from a get_user() in ir_lirc_ioctl().  We need to test
that it's not zero before using it as a divisor.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 647dd95..d05ac15 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -881,10 +881,13 @@ static int ene_set_tx_mask(struct rc_dev *rdev, u32 tx_mask)
 static int ene_set_tx_carrier(struct rc_dev *rdev, u32 carrier)
 {
 	struct ene_device *dev = rdev->priv;
-	u32 period = 2000000 / carrier;
+	u32 period;
 
 	dbg("TX: attempt to set tx carrier to %d kHz", carrier);
+	if (carrier == 0)
+		return -EINVAL;
 
+	period = 2000000 / carrier;
 	if (period && (period > ENE_CIRMOD_PRD_MAX ||
 			period < ENE_CIRMOD_PRD_MIN)) {
 
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 699eef3..2ea913a 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -517,6 +517,9 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	struct nvt_dev *nvt = dev->priv;
 	u16 val;
 
+	if (carrier == 0)
+		return -EINVAL;
+
 	nvt_cir_reg_write(nvt, 1, CIR_CP);
 	val = 3000000 / (carrier) - 1;
 	nvt_cir_reg_write(nvt, val & 0xff, CIR_CC);
