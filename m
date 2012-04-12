Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38987 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab2DLMrC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 08:47:02 -0400
Received: by eaaq12 with SMTP id q12so484136eaa.19
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2012 05:47:01 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: patrick.boettcher@dibcom.fr, olivier.grenie@dibcom.fr,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] dib7000p: remove duplicate code and comment
Date: Thu, 12 Apr 2012 14:46:51 +0200
Message-Id: <1334234811-13893-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove duplicate code and comment, probably due to a patch applied twice.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/frontends/dib7000p.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 5ceadc2..3e1eefa 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -2396,11 +2396,6 @@ struct dvb_frontend *dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr,
 	   more common) */
 	st->i2c_master.gated_tuner_i2c_adap.dev.parent = i2c_adap->dev.parent;
 
-	/* FIXME: make sure the dev.parent field is initialized, or else
-	   request_firmware() will hit an OOPS (this should be moved somewhere
-	   more common) */
-	st->i2c_master.gated_tuner_i2c_adap.dev.parent = i2c_adap->dev.parent;
-
 	dibx000_init_i2c_master(&st->i2c_master, DIB7000P, st->i2c_adap, st->i2c_addr);
 
 	/* init 7090 tuner adapter */
-- 
1.7.0.4

