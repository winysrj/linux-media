Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:36307 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab0FUIxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 04:53:31 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Manu Abraham <abraham.manu@gmail.com>,
	"Ozan ?a?layan" <ozan@pardus.org.tr>,
	Manu Abraham <manu@linuxtv.org>, stable@kernel.org
Subject: [PATCH] Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to make modules auto-loadable
Date: Mon, 21 Jun 2010 10:52:56 +0200
Message-Id: <1277110376-6993-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Ozan ?a?layan <ozan@pardus.org.tr> for pointing it out

From: Manu Abraham <abraham.manu@gmail.com>

Signed-off-by: Manu Abraham <manu@linuxtv.org>
[bjorn@mork.no: imported from http://jusst.de/hg/mantis-v4l-dvb/raw-rev/3731f71ed6bf]
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: stable@kernel.org
---
This patch is so obviously correct that I do not know how to write it differently.

It is copied from the mercurial repostory at http://jusst.de/hg/mantis-v4l-dvb/
where it has been resting for more than 4 months. I certainly hope everyone is
OK with me just forwarding it like this...  My only agenda is a fully functional
mantis driver in the kernel.

This patch does nothing but add all the relevant device id's for these two drivers, so
I consider it material for stable as well.

Bjørn

 drivers/media/dvb/mantis/hopper_cards.c |    2 ++
 drivers/media/dvb/mantis/mantis_cards.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index d073c61..1bf03ac 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -250,6 +250,8 @@ static struct pci_device_id hopper_pci_table[] = {
 	{ }
 };
 
+MODULE_DEVICE_TABLE(pci, hopper_pci_table);
+
 static struct pci_driver hopper_pci_driver = {
 	.name		= DRIVER_NAME,
 	.id_table	= hopper_pci_table,
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index 16f1708..64970cf 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -280,6 +280,8 @@ static struct pci_device_id mantis_pci_table[] = {
 	{ }
 };
 
+MODULE_DEVICE_TABLE(pci, mantis_pci_table);
+
 static struct pci_driver mantis_pci_driver = {
 	.name		= DRIVER_NAME,
 	.id_table	= mantis_pci_table,
-- 
1.7.1

