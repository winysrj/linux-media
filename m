Return-path: <linux-media-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:54840 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933950AbdKPKvX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 05:51:23 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] media: dvb_frontend: Fix uninitialized error in dvb_frontend_handle_ioctl()
Date: Thu, 16 Nov 2017 11:51:20 +0100
Message-Id: <1510829480-24760-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With gcc-4.1.2:

    drivers/media/dvb-core/dvb_frontend.c: In function ‘dvb_frontend_handle_ioctl’:
    drivers/media/dvb-core/dvb_frontend.c:2110: warning: ‘err’ may be used uninitialized in this function

Indeed, there are 13 cases where err is used initialized if one of the
dvb_frontend_ops is not implemented.

Preinitialize err to -EOPNOTSUPP like before to fix this.

Fixes: d73dcf0cdb95a47f ("media: dvb_frontend: cleanup ioctl handling logic")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 3ad83359098bde79..9eff8ce60d535379 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2107,7 +2107,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, err;
+	int i, err = -ENOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-- 
2.7.4
