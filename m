Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36039 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbcCJB1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 20:27:51 -0500
Received: by mail-io0-f194.google.com with SMTP id m184so6749365iof.3
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2016 17:27:51 -0800 (PST)
Date: Thu, 10 Mar 2016 09:28:38 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
Cc: "Olli Salonen" <olli.salonen@iki.fi>
References: <1457563108-17017-1-git-send-email-olli.salonen@iki.fi>
Subject: Re: [PATCH 2/2] smipcie: MAC address printout formatting
Message-ID: <201603100928354688232@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Max Nibble<nibble.max@gmail.com>

On 2016-03-10 06:39:27, Olli Salonen <olli.salonen@iki.fi> wrote:
>Modify the printout for MAC address to be more vendor agnostic.
>Print also the port number.
>
>Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>---
> drivers/media/pci/smipcie/smipcie-main.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
>index 993a2d1..4a9275a 100644
>--- a/drivers/media/pci/smipcie/smipcie-main.c
>+++ b/drivers/media/pci/smipcie/smipcie-main.c
>@@ -716,7 +716,8 @@ static int smi_fe_init(struct smi_port *port)
> 	/* init MAC.*/
> 	ret = smi_read_eeprom(&dev->i2c_bus[0], 0xc0, mac_ee, 16);
> 	dev_info(&port->dev->pci_dev->dev,
>-		"DVBSky SMI PCIe MAC= %pM\n", mac_ee + (port->idx)*8);
>+		"%s port %d MAC: %pM\n", dev->info->name,
>+		port->idx, mac_ee + (port->idx)*8);
> 	memcpy(adap->proposed_mac, mac_ee + (port->idx)*8, 6);
> 	return ret;
> }
>-- 
>1.9.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

