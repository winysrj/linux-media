Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36531 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751478AbdHDLNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 07:13:53 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] winbond-cir: buffer overrun during transmit
Date: Fri,  4 Aug 2017 12:13:51 +0100
Message-Id: <20170804111351.16734-2-sean@mess.org>
In-Reply-To: <20170804111351.16734-1-sean@mess.org>
References: <20170804111351.16734-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We're reading beyond the buffer before checking its length.

BUG: KASAN: slab-out-of-bounds in wbcir_irq_tx

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index ea7be6d35ff8..a18eb232ed81 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -429,7 +429,7 @@ wbcir_irq_tx(struct wbcir_data *data)
 		bytes[used] = byte;
 	}
 
-	while (data->txbuf[data->txoff] == 0 && data->txoff != data->txlen)
+	while (data->txoff != data->txlen && data->txbuf[data->txoff] == 0)
 		data->txoff++;
 
 	if (used == 0) {
-- 
2.13.3
