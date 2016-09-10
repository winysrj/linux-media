Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:59002 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753413AbcIJQwQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 12:52:16 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] [media] mb86a20s: always initialize a return value
Date: Sat, 10 Sep 2016 18:49:01 +0200
Message-Id: <20160910164901.2901-1-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In mb86a20s_read_status_and_stats(), when mb86a20s_read_status() fails,
the function returns the value in variable rc without initializing it
first. Fix this by propagating the error code from variable status_nr.

This bug has been found using clang and -Wsometimes-uninitialized
warning flag.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/media/dvb-frontends/mb86a20s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 41325328a22e..eca07432645e 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1971,6 +1971,7 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 	if (status_nr < 0) {
 		dev_err(&state->i2c->dev,
 			"%s: Can't read frontend lock status\n", __func__);
+		rc = status_nr;
 		goto error;
 	}
 
-- 
2.9.3

