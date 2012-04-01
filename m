Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40808 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2DAPyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:03 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 05/11] Slightly more friendly debugging output.
Date: Sun,  1 Apr 2012 17:53:45 +0200
Message-Id: <1333295631-31866-5-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

Say what address we read/write from/to. This is useful when trying
to trace where the debug output comes from, and which accesses
fail, if any.

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_hif.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/dvb/mantis/mantis_hif.c
index 10c68df..1210cda 100644
--- a/drivers/media/dvb/mantis/mantis_hif.c
+++ b/drivers/media/dvb/mantis/mantis_hif.c
@@ -91,8 +91,9 @@ int mantis_hif_read_mem(struct mantis_ca *ca, u32 addr)
 	struct mantis_pci *mantis = ca->ca_priv;
 	u32 hif_addr = 0, data, count = 4;
 
-	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Read", mantis->num);
+	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Read of 0x%x", mantis->num, addr);
 	mutex_lock(&ca->ca_lock);
+
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAIOM;
 	hif_addr |=  MANTIS_HIF_STATUS;
@@ -110,7 +111,7 @@ int mantis_hif_read_mem(struct mantis_ca *ca, u32 addr)
 	}
 	data = mmread(MANTIS_GPIF_DIN);
 	mutex_unlock(&ca->ca_lock);
-	dprintk(MANTIS_DEBUG, 1, "Mem Read: 0x%02x", data);
+	dprintk(MANTIS_DEBUG, 1, "Mem Read: 0x%02x from 0x%02x", data, addr);
 	return (data >> 24) & 0xff;
 }
 
@@ -148,7 +149,7 @@ int mantis_hif_read_iom(struct mantis_ca *ca, u32 addr)
 	struct mantis_pci *mantis = ca->ca_priv;
 	u32 data, hif_addr = 0;
 
-	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Read", mantis->num);
+	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Read of 0x%x", mantis->num, addr);
 	mutex_lock(&ca->ca_lock);
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr |=  MANTIS_GPIF_PCMCIAIOM;
@@ -166,7 +167,7 @@ int mantis_hif_read_iom(struct mantis_ca *ca, u32 addr)
 		return -EREMOTEIO;
 	}
 	data = mmread(MANTIS_GPIF_DIN);
-	dprintk(MANTIS_DEBUG, 1, "I/O Read: 0x%02x", data);
+	dprintk(MANTIS_DEBUG, 1, "I/O Read: 0x%02x from 0x%02x", data, addr);
 	udelay(50);
 	mutex_unlock(&ca->ca_lock);
 
-- 
1.7.9.5

