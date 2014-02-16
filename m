Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52041 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaBPKQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 05:16:27 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so10359411lbv.5
        for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 02:16:25 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH] nuvoton-cir: Activate PNP device when probing
Date: Sun, 16 Feb 2014 12:16:02 +0200
Message-Id: <1392545762-14205-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On certain motherboards (mainly Intel NUC series) bios keeps the
Nuvoton CIR device disabled at boot.

This patch adds a call to kernel PNP layer to activate the device if it
is not already activated. This will improve the chances of the PNP probe
actually succeeding on Intel NUC platforms.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index b41e52e..b81325d 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -985,6 +985,12 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 		goto exit_free_dev_rdev;
 
 	ret = -ENODEV;
+	/* activate pnp device */
+	if (pnp_activate_dev(pdev) < 0) {
+		dev_err(&pdev->dev, "Could not activate PNP device!\n");
+		goto exit_free_dev_rdev;
+	}
+
 	/* validate pnp resources */
 	if (!pnp_port_valid(pdev, 0) ||
 	    pnp_port_len(pdev, 0) < CIR_IOREG_LENGTH) {
-- 
1.8.3.2

