Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36604 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758064AbeDXNTy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:19:54 -0400
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: fix va1j5jf8007t_get_frontend_algo()'s return type
Date: Tue, 24 Apr 2018 15:19:49 +0200
Message-Id: <20180424131951.6423-1-luc.vanoostenryck@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The method dvb_frontend_ops::get_frontend_algo() is defined as
returning an 'enum dvbfe_algo', but the implementation in this
driver returns an 'int'.

Fix this by returning 'enum dvbfe_algo' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/media/pci/pt1/va1j5jf8007t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/pt1/va1j5jf8007t.c b/drivers/media/pci/pt1/va1j5jf8007t.c
index a52984a6f..588ee5d9f 100644
--- a/drivers/media/pci/pt1/va1j5jf8007t.c
+++ b/drivers/media/pci/pt1/va1j5jf8007t.c
@@ -88,7 +88,7 @@ static int va1j5jf8007t_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
-static int va1j5jf8007t_get_frontend_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo va1j5jf8007t_get_frontend_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
-- 
2.17.0
