Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44221 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752494AbdK2TIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:51 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/22] media: ix2505v: get rid of /** comments
Date: Wed, 29 Nov 2017 14:08:22 -0500
Message-Id: <99823b61eea8e30149953092ab3611597ec9d0e3.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned:

  drivers/media/dvb-frontends/ix2505v.c:24: warning: cannot understand function prototype: 'int ix2505v_debug; '
  drivers/media/dvb-frontends/ix2505v.c:59: warning: No description found for parameter 'state'
  drivers/media/dvb-frontends/ix2505v.c:128: warning: No description found for parameter 'fe'

None of the comments there are kernel-doc. So, remove them with:

	perl -pi -e 's,\/\*\*,/*,g' drivers/media/dvb-frontends/ix2505v.c

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/ix2505v.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index 534b24fa2b95..965012ad5c59 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Driver for Sharp IX2505V (marked B0017) DVB-S silicon tuner
  *
  * Copyright (C) 2010 Malcolm Priestley
@@ -36,7 +36,7 @@ struct ix2505v_state {
 	u32 frequency;
 };
 
-/**
+/*
  *  Data read format of the Sharp IX2505V B0017
  *
  *  byte1:   1   |   1   |   0   |   0   |   0   |  MA1  |  MA0  |  1
@@ -99,7 +99,7 @@ static void ix2505v_release(struct dvb_frontend *fe)
 
 }
 
-/**
+/*
  *  Data write format of the Sharp IX2505V B0017
  *
  *  byte1:   1   |   1   |   0   |   0   |   0   | 0(MA1)| 0(MA0)|  0
-- 
2.14.3
