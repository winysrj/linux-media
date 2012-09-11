Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:37104 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2IKLLu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 07:11:50 -0400
Date: Tue, 11 Sep 2012 14:11:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v3] [media] rc: divide by zero bugs in s_tx_carrier()
Message-ID: <20120911111124.GA22259@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909222629.GA28355@pequod.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"carrier" comes from a get_user() in ir_lirc_ioctl().  We need to test
that it's not zero before using it as a divisor.  It might have been
nice to test for this ir_lirc_ioctl() but the mceusb driver uses zero to
disable carrier modulation.

The bug in redrat3 is a little more subtle.  The ->carrier is passed to
mod_freq_to_val() which uses it as a divisor.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: tried to add the check to ir_lirc_ioctl() but that doesn't work.
v3: the same as v1 except that I've added a fix for redrat3 as well.

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
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 2878b0e..bf8bc74 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -890,6 +890,9 @@ static int redrat3_set_tx_carrier(struct rc_dev *rcdev, u32 carrier)
 	struct device *dev = rr3->dev;
 
 	rr3_dbg(dev, "Setting modulation frequency to %u", carrier);
+	if (carrier == 0)
+		return -EINVAL;
+
 	rr3->carrier = carrier;
 
 	return carrier;

