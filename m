Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54653 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752623AbcL2RYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 12:24:05 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] b2c2: fix spelling mistake: "Contunuity" -> "Continuity"
Date: Thu, 29 Dec 2016 17:23:15 +0000
Message-Id: <20161229172315.22614-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in deb_chk message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/b2c2/flexcop-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index 99ce284..6e60dec 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -157,7 +157,7 @@ static irqreturn_t flexcop_pci_isr(int irq, void *dev_id)
 	if (v.irq_20c.Data_receiver_error)
 		deb_chk("data receiver error\n");
 	if (v.irq_20c.Continuity_error_flag)
-		deb_chk("Contunuity error flag is set\n");
+		deb_chk("Continuity error flag is set\n");
 	if (v.irq_20c.LLC_SNAP_FLAG_set)
 		deb_chk("LLC_SNAP_FLAG_set is set\n");
 	if (v.irq_20c.Transport_Error)
-- 
2.10.2

