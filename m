Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1FIPvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 11:51:18 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	=?UTF-8?q?Juan=20Jes=C3=BAs=20Garc=C3=ADa=20de=20Soria?=
	<skandalfo@gmail.com>, stable@kernel.org
Subject: [PATCH] [media] ite-cir: 8709 needs to use pnp resource 2
Date: Thu,  9 Jun 2011 11:50:22 -0400
Message-Id: <1307634622-10687-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks to the intrepid testing and debugging of Matthijs van Drunen, it
was uncovered that at least some variants of the ITE8709 need to use pnp
resource 2, rather than 0, for things to function properly. Resource 0
has a length of only 1, and if you try to bypass the pnp_port_len check
and use it anyway (with either a length of 1 or 2), the system in
question's trackpad ceased to function.

The circa lirc 0.8.7 lirc_ite8709 driver used resource 2, but the value
was (amusingly) changed to 0 by way of a patch from ITE themselves, so I
don't know if there may be variants where 0 actually *is* correct, but
at least in this case and in the original lirc_ite8709 driver author's
case, it sure looks like 2 is the right value.

This fix should probably be applied to all stable kernels with the
ite-cir driver, lest we nuke more people's trackpads.

Tested-by: Matthijs van Drunen
CC: Juan Jesús García de Soria <skandalfo@gmail.com>
CC: stable@kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ite-cir.c |   12 +++++++++---
 drivers/media/rc/ite-cir.h |    3 +++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index e716b93..ecd3d02 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1347,6 +1347,7 @@ static const struct ite_dev_params ite_dev_descs[] = {
 	{	/* 0: ITE8704 */
 	       .model = "ITE8704 CIR transceiver",
 	       .io_region_size = IT87_IOREG_LENGTH,
+	       .io_rsrc_no = 0,
 	       .hw_tx_capable = true,
 	       .sample_period = (u32) (1000000000ULL / 115200),
 	       .tx_carrier_freq = 38000,
@@ -1371,6 +1372,7 @@ static const struct ite_dev_params ite_dev_descs[] = {
 	{	/* 1: ITE8713 */
 	       .model = "ITE8713 CIR transceiver",
 	       .io_region_size = IT87_IOREG_LENGTH,
+	       .io_rsrc_no = 0,
 	       .hw_tx_capable = true,
 	       .sample_period = (u32) (1000000000ULL / 115200),
 	       .tx_carrier_freq = 38000,
@@ -1395,6 +1397,7 @@ static const struct ite_dev_params ite_dev_descs[] = {
 	{	/* 2: ITE8708 */
 	       .model = "ITE8708 CIR transceiver",
 	       .io_region_size = IT8708_IOREG_LENGTH,
+	       .io_rsrc_no = 0,
 	       .hw_tx_capable = true,
 	       .sample_period = (u32) (1000000000ULL / 115200),
 	       .tx_carrier_freq = 38000,
@@ -1420,6 +1423,7 @@ static const struct ite_dev_params ite_dev_descs[] = {
 	{	/* 3: ITE8709 */
 	       .model = "ITE8709 CIR transceiver",
 	       .io_region_size = IT8709_IOREG_LENGTH,
+	       .io_rsrc_no = 2,
 	       .hw_tx_capable = true,
 	       .sample_period = (u32) (1000000000ULL / 115200),
 	       .tx_carrier_freq = 38000,
@@ -1461,6 +1465,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	struct rc_dev *rdev = NULL;
 	int ret = -ENOMEM;
 	int model_no;
+	int io_rsrc_no;
 
 	ite_dbg("%s called", __func__);
 
@@ -1490,10 +1495,11 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 
 	/* get the description for the device */
 	dev_desc = &ite_dev_descs[model_no];
+	io_rsrc_no = dev_desc->io_rsrc_no;
 
 	/* validate pnp resources */
-	if (!pnp_port_valid(pdev, 0) ||
-	    pnp_port_len(pdev, 0) != dev_desc->io_region_size) {
+	if (!pnp_port_valid(pdev, io_rsrc_no) ||
+	    pnp_port_len(pdev, io_rsrc_no) != dev_desc->io_region_size) {
 		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
 		goto failure;
 	}
@@ -1504,7 +1510,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	}
 
 	/* store resource values */
-	itdev->cir_addr = pnp_port_start(pdev, 0);
+	itdev->cir_addr = pnp_port_start(pdev, io_rsrc_no);
 	itdev->cir_irq = pnp_irq(pdev, 0);
 
 	/* initialize spinlocks */
diff --git a/drivers/media/rc/ite-cir.h b/drivers/media/rc/ite-cir.h
index 16a19f5..aa899a0 100644
--- a/drivers/media/rc/ite-cir.h
+++ b/drivers/media/rc/ite-cir.h
@@ -57,6 +57,9 @@ struct ite_dev_params {
 	/* size of the I/O region */
 	int io_region_size;
 
+	/* IR pnp I/O resource number */
+	int io_rsrc_no;
+
 	/* true if the hardware supports transmission */
 	bool hw_tx_capable;
 
-- 
1.7.1

