Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388764AbeHGNVQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 09:21:16 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] media: rtl28xxu: be sure that it won't go past the array size
Date: Tue,  7 Aug 2018 07:07:24 -0400
Message-Id: <53cc785104d19c86defea0a9473f07c392390453.1533640042.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smatch warns that the RC query code could go past the array size:

	drivers/media/usb/dvb-usb-v2/rtl28xxu.c:1757 rtl2832u_rc_query() error: buffer overflow 'buf' 128 <= 130
	drivers/media/usb/dvb-usb-v2/rtl28xxu.c:1758 rtl2832u_rc_query() error: buffer overflow 'buf' 128 <= 130

The driver logic gets the length of the IR RX buffer with:

        ret = rtl28xxu_rd_reg(d, IR_RX_BC, &buf[0]);
	...
        len = buf[0];

In thesis, this could range between 0 and 255 [1].

While this should never happen in practice, due to hardware limits,
smatch is right when it complains about that, as there's nothing at
the logic that would prevent it. So, if for whatever reason, buf[0]
gets filled by rtl28xx read functions with a value bigger than 128,
it will go past the array.

So, add an explicit check.

[1] I've no idea why smatch thinks that the maximum value is 130.
I double-checked the code several times. Was unable to find any
reason for assuming 130. Perhaps smatch is not properly parsing
u8 here?

Fixes: b5cbaa43a676 ("[media] rtl28xx: initial support for rtl2832u")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c76e78f9638a..a970224a94bd 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1732,7 +1732,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		goto exit;
 
 	ret = rtl28xxu_rd_reg(d, IR_RX_BC, &buf[0]);
-	if (ret)
+	if (ret || buf[0] > sizeof(buf))
 		goto err;
 
 	len = buf[0];
-- 
2.17.1
