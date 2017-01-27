Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.helmutauer.de ([185.170.112.187]:38776 "EHLO
        v2201612530341454.powersrv.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754280AbdA0Ic3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 03:32:29 -0500
Message-ID: <ae72e45aeea9d3cbead7c50e1cbe4c5b.squirrel@helmutauer.de>
In-Reply-To: <20170127080622.GA4153@mwanda>
References: <20170127080622.GA4153@mwanda>
Date: Fri, 27 Jan 2017 09:15:31 +0100
Subject: [patch] [media] add device IDs to ngene
From: vdr@helmutauer.de
To: linux-media@vger.kernel.org
Cc: "Mauro Carvalho Chehab" <mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Author: Helmut Auer <vdr@xxx.de>
Date:   Fri Jan 27 09:09:35 2017 +0100

    Adding 2 device ID's to ngene driver.

    Signed-off-by: Helmut Auer <vdr@xxx.de>

diff --git a/drivers/media/pci/ngene/ngene-cards.c
b/drivers/media/pci/ngene/ngene-cards.c
index 423e8c8..88815bd 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -753,6 +753,8 @@ static const struct ngene_info ngene_info_terratec = {
 /****************************************************************************/

 static const struct pci_device_id ngene_id_tbl[] = {
+       NGENE_ID(0x18c3, 0xab04, ngene_info_cineS2),
+       NGENE_ID(0x18c3, 0xab05, ngene_info_cineS2v5),
        NGENE_ID(0x18c3, 0xabc3, ngene_info_cineS2),
        NGENE_ID(0x18c3, 0xabc4, ngene_info_cineS2),
        NGENE_ID(0x18c3, 0xdb01, ngene_info_satixS2),


