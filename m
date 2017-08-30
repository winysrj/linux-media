Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:51663 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751306AbdH3HVM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 03:21:12 -0400
Subject: [PATCH 3/6] [media] cx24116: Delete an unnecessary variable
 initialisation in cx24116_writeregN()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Message-ID: <7af2ff80-ee62-d2d1-77af-35f34976780b@users.sourceforge.net>
Date: Wed, 30 Aug 2017 09:21:07 +0200
MIME-Version: 1.0
In-Reply-To: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 08:10:38 +0200

The variable "ret" will eventually be set to an appropriate value
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/cx24116.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 69c156443b50..54f09a5a5075 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -221,7 +221,7 @@ static int cx24116_writereg(struct cx24116_state *state, int reg, int data)
 static int cx24116_writeregN(struct cx24116_state *state, int reg,
 			     const u8 *data, u16 len)
 {
-	int ret = -EREMOTEIO;
+	int ret;
 	struct i2c_msg msg;
 	u8 *buf;
 
-- 
2.14.1
