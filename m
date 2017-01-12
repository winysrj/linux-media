Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35929 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdALPci (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 10:32:38 -0500
Received: by mail-pf0-f196.google.com with SMTP id b22so3989651pfd.3
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2017 07:32:38 -0800 (PST)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] gp8psk: make local symbol gp8psk_fe_ops static
Date: Thu, 12 Jan 2017 15:32:29 +0000
Message-Id: <20170112153229.21309-1-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/media/usb/dvb-usb/gp8psk.c:281:28: warning:
 symbol 'gp8psk_fe_ops' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/usb/dvb-usb/gp8psk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 2360e7e..7dc3bdd 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -278,7 +278,7 @@ static int gp8psk_fe_reload(void *priv)
 	return gp8psk_bcm4500_reload(d);
 }
 
-const struct gp8psk_fe_ops gp8psk_fe_ops = {
+static const struct gp8psk_fe_ops gp8psk_fe_ops = {
 	.in = gp8psk_fe_in,
 	.out = gp8psk_fe_out,
 	.reload = gp8psk_fe_reload,

