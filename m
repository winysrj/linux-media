Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:52834 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab3H3CY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:24:29 -0400
Message-ID: <5220021C.2050700@asianux.com>
Date: Fri, 30 Aug 2013 10:23:24 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: [PATCH] media: usb: b2c2: Kconfig: add PCI dependancy to DVB_B2C2_FLEXCOP_USB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB_B2C2_FLEXCOP_USB need depend on PCI, or can not pass compiling with
allmodconfig for h8300.

The related error:

  drivers/media/usb/b2c2/flexcop-usb.c: In function 'flexcop_usb_transfer_exit':
  drivers/media/usb/b2c2/flexcop-usb.c:393:3: error: implicit declaration of function 'pci_free_consistent' [-Werror=implicit-function-declaration]
     pci_free_consistent(NULL,
     ^
  drivers/media/usb/b2c2/flexcop-usb.c: In function 'flexcop_usb_transfer_init':
  drivers/media/usb/b2c2/flexcop-usb.c:410:2: error: implicit declaration of function 'pci_alloc_consistent' [-Werror=implicit-function-declaration]
    fc_usb->iso_buffer = pci_alloc_consistent(NULL,
    ^
  drivers/media/usb/b2c2/flexcop-usb.c:410:21: warning: assignment makes pointer from integer without a cast [enabled by default]
    fc_usb->iso_buffer = pci_alloc_consistent(NULL,
                       ^
  cc1: some warnings being treated as errors


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/media/usb/b2c2/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/b2c2/Kconfig b/drivers/media/usb/b2c2/Kconfig
index 17d3583..06fdf30 100644
--- a/drivers/media/usb/b2c2/Kconfig
+++ b/drivers/media/usb/b2c2/Kconfig
@@ -1,6 +1,6 @@
 config DVB_B2C2_FLEXCOP_USB
 	tristate "Technisat/B2C2 Air/Sky/Cable2PC USB"
-	depends on DVB_CORE && I2C
+	depends on DVB_CORE && I2C && PCI
 	help
 	  Support for the Air/Sky/Cable2PC USB1.1 box (DVB/ATSC) by Technisat/B2C2,
 
-- 
1.7.7.6
