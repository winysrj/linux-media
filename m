Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:34453 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbcCIWim (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 17:38:42 -0500
Received: by mail-lb0-f193.google.com with SMTP id vk4so6566375lbb.1
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2016 14:38:41 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] smipcie: MAC address printout formatting
Date: Thu, 10 Mar 2016 00:38:28 +0200
Message-Id: <1457563108-17017-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1457563108-17017-1-git-send-email-olli.salonen@iki.fi>
References: <1457563108-17017-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify the printout for MAC address to be more vendor agnostic.
Print also the port number.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/smipcie/smipcie-main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
index 993a2d1..4a9275a 100644
--- a/drivers/media/pci/smipcie/smipcie-main.c
+++ b/drivers/media/pci/smipcie/smipcie-main.c
@@ -716,7 +716,8 @@ static int smi_fe_init(struct smi_port *port)
 	/* init MAC.*/
 	ret = smi_read_eeprom(&dev->i2c_bus[0], 0xc0, mac_ee, 16);
 	dev_info(&port->dev->pci_dev->dev,
-		"DVBSky SMI PCIe MAC= %pM\n", mac_ee + (port->idx)*8);
+		"%s port %d MAC: %pM\n", dev->info->name,
+		port->idx, mac_ee + (port->idx)*8);
 	memcpy(adap->proposed_mac, mac_ee + (port->idx)*8, 6);
 	return ret;
 }
-- 
1.9.1

