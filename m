Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaCCTh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 14:37:57 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] [media] Update CARDLIST.cx23885
Date: Mon,  3 Mar 2014 16:37:16 -0300
Message-Id: <1393875438-1916-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393875438-1916-1-git-send-email-m.chehab@samsung.com>
References: <1393875438-1916-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some boards got added there. Update the cardlist to reflect the
current status.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/video4linux/CARDLIST.cx23885 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/video4linux/CARDLIST.cx23885 b/Documentation/video4linux/CARDLIST.cx23885
index 9f056d512e35..fc009d0ee7d6 100644
--- a/Documentation/video4linux/CARDLIST.cx23885
+++ b/Documentation/video4linux/CARDLIST.cx23885
@@ -31,10 +31,13 @@
  30 -> NetUP Dual DVB-T/C-CI RF                            [1b55:e2e4]
  31 -> Leadtek Winfast PxDVR3200 H XC4000                  [107d:6f39]
  32 -> MPX-885
- 33 -> Mygica X8507                                        [14f1:8502]
+ 33 -> Mygica X8502/X8507 ISDB-T                           [14f1:8502]
  34 -> TerraTec Cinergy T PCIe Dual                        [153b:117e]
  35 -> TeVii S471                                          [d471:9022]
  36 -> Hauppauge WinTV-HVR1255                             [0070:2259]
  37 -> Prof Revolution DVB-S2 8000                         [8000:3034]
  38 -> Hauppauge WinTV-HVR4400                             [0070:c108,0070:c138,0070:c12a,0070:c1f8]
  39 -> AVerTV Hybrid Express Slim HC81R                    [1461:d939]
+ 40 -> TurboSight TBS 6981                                 [6981:8888]
+ 41 -> TurboSight TBS 6980                                 [6980:8888]
+ 42 -> Leadtek Winfast PxPVR2200                           [107d:6f21]
-- 
1.8.5.3

