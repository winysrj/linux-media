Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:45342 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab0CXK6K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 06:58:10 -0400
From: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>, stable@kernel.org,
	575207@bugs.debian.org
Subject: [PATCH] V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"
Date: Wed, 24 Mar 2010 11:57:57 +0100
Message-Id: <1269428277-6709-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Never call dvb_frontend_detach if we failed to attach a frontend. This fixes
the following oops, which will be triggered by a missing stv090x module:

[    8.172997] DVB: registering new adapter (TT-Budget S2-1600 PCI)
[    8.209018] adapter has MAC addr = 00:d0:5c:cc:a7:29
[    8.328665] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    8.328753] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    8.562047] DVB: Unable to find symbol stv090x_attach()
[    8.562117] BUG: unable to handle kernel NULL pointer dereference at 000000ac
[    8.562239] IP: [<e08b04a3>] dvb_frontend_detach+0x4/0x67 [dvb_core]


Ref http://bugs.debian.org/575207


Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: stable@kernel.org
Cc: 575207@bugs.debian.org
---
This patch should apply cleanly to 2.6.32, 2.6.33, 2.6.34-rc2 and with an 
offset to git://linuxtv.org/v4l-dvb.git

Please apply to all of them


 drivers/media/dvb/ttpci/budget.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index e48380c..95a463c 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -643,9 +643,6 @@ static void frontend_init(struct budget *budget)
 					&budget->i2c_adap,
 					&tt1600_isl6423_config);
 
-			} else {
-				dvb_frontend_detach(budget->dvb_frontend);
-				budget->dvb_frontend = NULL;
 			}
 		}
 		break;
-- 
1.5.6.5

