Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40355 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2HYVq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 17:46:56 -0400
Subject: [PATCH 1/8] winbond-cir: correctness fix
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jwilson@redhat.com, mchehab@redhat.com, sean@mess.org
Date: Sat, 25 Aug 2012 23:46:52 +0200
Message-ID: <20120825214652.22603.81980.stgit@localhost.localdomain>
In-Reply-To: <20120825214520.22603.37194.stgit@localhost.localdomain>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a minor correctness fix for the duration calculation in
winbond-cir (the read value should be incremented by one).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/winbond-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 54ee348..29e6769 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -358,7 +358,7 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
 		rawir.pulse = irdata & 0x80 ? false : true;
-		rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
+		rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 10);
 		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 

