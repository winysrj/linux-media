Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36201 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933381AbdKAVGK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 11/26] media: qt1010: fix bogus warnings
Date: Wed,  1 Nov 2017 17:05:48 -0400
Message-Id: <416f9d2487dfef857372eec1e7a5677aac3aeb1e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at qt1010_init_meas1() and qt1010_init_meas2()
are too complex for static analizers to identify that
some vars are always be initialized.

That causes smatch to produce the following warnings:
	drivers/media/tuners/qt1010.c:248 qt1010_init_meas1() error: uninitialized symbol 'val2'.
	drivers/media/tuners/qt1010.c:282 qt1010_init_meas2() error: uninitialized symbol 'val'.

So, add annotations to prevent those bogus warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/qt1010.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index ee33b7cc7682..b92be882ab3c 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -224,7 +224,7 @@ static int qt1010_set_params(struct dvb_frontend *fe)
 static int qt1010_init_meas1(struct qt1010_priv *priv,
 			     u8 oper, u8 reg, u8 reg_init_val, u8 *retval)
 {
-	u8 i, val1, val2;
+	u8 i, val1, uninitialized_var(val2);
 	int err;
 
 	qt1010_i2c_oper_t i2c_data[] = {
@@ -259,7 +259,7 @@ static int qt1010_init_meas1(struct qt1010_priv *priv,
 static int qt1010_init_meas2(struct qt1010_priv *priv,
 			    u8 reg_init_val, u8 *retval)
 {
-	u8 i, val;
+	u8 i, uninitialized_var(val);
 	int err;
 	qt1010_i2c_oper_t i2c_data[] = {
 		{ QT1010_WR, 0x07, reg_init_val },
-- 
2.13.6
