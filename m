Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65501 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdK2TIw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:52 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH 08/22] media: netup_unidvb: fix a bad kernel-doc markup
Date: Wed, 29 Nov 2017 14:08:26 -0500
Message-Id: <f7469ec9bf32f13642c8e63761263417cd8b0fe4.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a bad kernel-doc markup, producing the following warnings:

  drivers/media/pci/netup_unidvb/netup_unidvb_core.c:85: warning: bad line: 			Bits [0-7]:	DMA packet size, 188 bytes
  drivers/media/pci/netup_unidvb/netup_unidvb_core.c:86: warning: bad line: 			Bits [16-23]:	packets count in block, 128 packets
  drivers/media/pci/netup_unidvb/netup_unidvb_core.c:87: warning: bad line: 			Bits [24-31]:	blocks count, 8 blocks
  drivers/media/pci/netup_unidvb/netup_unidvb_core.c:89: warning: bad line: 			For example, value of 375000000 equals to 3 sec

Fix that, and use a list for the bits option, in order for it
to be better format, if we add it to a driver's documentation
file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 11829c0fa138..509d69e6ca4a 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -82,11 +82,11 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
  * @start_addr_lo:	DMA ring buffer start address, lower part
  * @start_addr_hi:	DMA ring buffer start address, higher part
  * @size:		DMA ring buffer size register
-			Bits [0-7]:	DMA packet size, 188 bytes
-			Bits [16-23]:	packets count in block, 128 packets
-			Bits [24-31]:	blocks count, 8 blocks
+ *			* Bits [0-7]:	DMA packet size, 188 bytes
+ *			* Bits [16-23]:	packets count in block, 128 packets
+ *			* Bits [24-31]:	blocks count, 8 blocks
  * @timeout:		DMA timeout in units of 8ns
-			For example, value of 375000000 equals to 3 sec
+ *			For example, value of 375000000 equals to 3 sec
  * @curr_addr_lo:	Current ring buffer head address, lower part
  * @curr_addr_hi:	Current ring buffer head address, higher part
  * @stat_pkt_received:	Statistic register, not tested
-- 
2.14.3
