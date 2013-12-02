Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:34070 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3LBXPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Dec 2013 18:15:05 -0500
From: Jingoo Han <jg1.han@samsung.com>
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 15/39] media: pci: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:15:04 +0900
Message-id: <002401ceefb4$55175fb0$ff461f10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/media/pci/cx25821/cx25821-alsa.c |    2 +-
 drivers/media/pci/cx25821/cx25821-core.c |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 6e91e84..b1e08c3 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -618,7 +618,7 @@ static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static DEFINE_PCI_DEVICE_TABLE(cx25821_audio_pci_tbl) = {
+static const struct pci_device_id cx25821_audio_pci_tbl[] = {
 	{0x14f1, 0x0920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index b762c5b..e81173c 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1361,7 +1361,7 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 	kfree(dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cx25821_pci_tbl) = {
+static const struct pci_device_id cx25821_pci_tbl[] = {
 	{
 		/* CX25821 Athena */
 		.vendor = 0x14f1,
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 77edc11..e5cfb6c 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1303,7 +1303,7 @@ static int sta2x11_vip_resume(struct pci_dev *pdev)
 
 #endif
 
-static DEFINE_PCI_DEVICE_TABLE(sta2x11_vip_pci_tbl) = {
+static const struct pci_device_id sta2x11_vip_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_VIP)},
 	{0,}
 };
-- 
1.7.10.4


