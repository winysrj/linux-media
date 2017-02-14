Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.helmutauer.de ([185.170.112.187]:36086 "EHLO
        v2201612530341454.powersrv.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752203AbdBNHUH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:20:07 -0500
Message-ID: <1e794e8c098312a5060c698aeebf70ea.squirrel@helmutauer.de>
In-Reply-To: <33044ec5031546f79ae9d37565240ed3.squirrel@helmutauer.de>
References: <20170127080622.GA4153@mwanda>
    <ae72e45aeea9d3cbead7c50e1cbe4c5b.squirrel@helmutauer.de>
    <33044ec5031546f79ae9d37565240ed3.squirrel@helmutauer.de>
Date: Tue, 14 Feb 2017 08:20:24 +0100
Subject: [PATCH] [MEDIA] add device IDs to ngene driver
From: "Helmut Auer" <vdr@helmutauer.de>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Author: Helmut Auer <vdr@helmutauer.de>
Date:   Fri Jan 27 09:09:35 2017 +0100

     Adding 2 device ID's to ngene driver.

     Signed-off-by: Helmut Auer <vdr@helmutauer.de>

--- drivers/media/pci/ngene/ngene-cards.c        2016-12-11
20:17:54.000000000 +0100
+++ drivers/media/pci/ngene/ngene-cards.c        2017-01-20
08:46:48.263666132 +0100
@@ -753,6 +753,8 @@
 /****************************************************************************/

 static const struct pci_device_id ngene_id_tbl[] = {
+	NGENE_ID(0x18c3, 0xab04, ngene_info_cineS2),
+	NGENE_ID(0x18c3, 0xab05, ngene_info_cineS2v5),
 	NGENE_ID(0x18c3, 0xabc3, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xabc4, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xdb01, ngene_info_satixS2),
