Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40756 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1KLP4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:56:37 -0500
Received: by mail-wy0-f174.google.com with SMTP id 15so4693629wyh.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:56:37 -0800 (PST)
Message-ID: <4ebe9734.d4c7e30a.6b0e.ffff9414@mx.google.com>
Subject: [PATCH 7/7] af9013 empty buffer overflow command.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 15:56:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This command is present in other Afatech devices zeroing bit 7
seems to force streaming output even if it isn't one.

I was considering timing it out, but it seems to have no harmful effect
on streaming output.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/af9013.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 6a5b40c..fbf6bca 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -1094,7 +1094,10 @@ static int af9013_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	}
 
 	ret = af9013_update_statistics(fe);
-
+	if (ret)
+		goto error;
+	/* Force empty stream buffer if overflow */
+	ret = af9013_write_reg_bits(state, 0xd500, 7, 1, 0);
 error:
 	return ret;
 }
-- 
1.7.5.4





