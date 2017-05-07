Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.CARNet.hr ([161.53.123.6]:35097 "EHLO mail.carnet.hr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbdEHB3Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 21:29:24 -0400
From: Valentin Vidic <Valentin.Vidic@CARNet.hr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Valentin Vidic <Valentin.Vidic@CARNet.hr>
Date: Sun,  7 May 2017 09:57:37 +0200
Message-Id: <20170507075737.20142-1-Valentin.Vidic@CARNet.hr>
Subject: [PATCH] staging: media/atomisp: drop unused qos variable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes a sparse warning:

drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c:35:5: warning: symbol 'qos' was not declared. Should it be static?

Signed-off-by: Valentin Vidic <Valentin.Vidic@CARNet.hr>
---
 drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index a6c0f5f8c3f8..b01463361943 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -32,7 +32,6 @@ static DEFINE_SPINLOCK(msgbus_lock);
 
 static struct pci_dev *pci_root;
 static struct pm_qos_request pm_qos;
-int qos;
 
 #define DW_I2C_NEED_QOS	(platform_is(INTEL_ATOM_BYT))
 
-- 
2.11.0
