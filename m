Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:33710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1EIS20 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 14:28:26 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	=?UTF-8?q?Juan=20Jes=C3=BAs=20Garc=C3=ADa=20de=20Soria?=
	<skandalfo@gmail.com>
Subject: [PATCH v2] [media] ite-cir: make IR receive work after resume
Date: Mon,  9 May 2011 14:28:21 -0400
Message-Id: <1304965701-24912-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1304953686-21805-1-git-send-email-jarod@redhat.com>
References: <1304953686-21805-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Just recently acquired an Asus Eee Box PC with an onboard IR receiver
driven by ite-cir (ITE8713 sub-variant). Works out of the box with the
ite-cir driver in 2.6.39, but stops working after a suspend/resume
cycle. Its fixed by simply reinitializing registers after resume,
similar to what's done in the nuvoton-cir driver. I've not tested with
any other ITE variant, but code inspection suggests this should be safe
on all variants.

Reported-by: Stephan Raue <sraue@openelec.tv>
CC: Juan Jesús García de Soria <skandalfo@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
v2: fix copy/paste thinko

 drivers/media/rc/ite-cir.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 43908a7..253837e 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1684,6 +1684,8 @@ static int ite_resume(struct pnp_dev *pdev)
 		/* wake up the transmitter */
 		wake_up_interruptible(&dev->tx_queue);
 	} else {
+		/* reinitialize hardware config registers */
+		dev->params.init_hardware(dev);
 		/* enable the receiver */
 		dev->params.enable_rx(dev);
 	}
-- 
1.7.1

