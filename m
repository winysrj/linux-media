Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52351 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdGULGi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 07:06:38 -0400
From: Colin King <colin.king@canonical.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: dvb-frontends/stv0910: make various local variables static
Date: Fri, 21 Jul 2017 12:06:35 +0100
Message-Id: <20170721110635.23610-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The list stvlist and arrays padc_lookup, s1_sn_lookup and s2_sn_lookup
do not need to be in global scope, so make them all static.

Cleans up a bunch of smatch warnings:
symbol 'padc_lookup' was not declared. Should it be static?
symbol 's1_sn_lookup' was not declared. Should it be static?
symbol 's2_sn_lookup' was not declared. Should it be static?
symbol 'stvlist' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/stv0910.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 7e8a460449c5..bae1da3fdb2d 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -34,7 +34,7 @@
 #define BER_SRC_S    0x20
 #define BER_SRC_S2   0x20
 
-LIST_HEAD(stvlist);
+static LIST_HEAD(stvlist);
 
 enum receive_mode { RCVMODE_NONE, RCVMODE_DVBS, RCVMODE_DVBS2, RCVMODE_AUTO };
 
@@ -207,7 +207,7 @@ static int write_shared_reg(struct stv *state, u16 reg, u8 mask, u8 val)
 	return status;
 }
 
-struct slookup s1_sn_lookup[] = {
+static struct slookup s1_sn_lookup[] = {
 	{   0,    9242  },  /*C/N=  0dB*/
 	{   5,    9105  },  /*C/N=0.5dB*/
 	{  10,    8950  },  /*C/N=1.0dB*/
@@ -264,7 +264,7 @@ struct slookup s1_sn_lookup[] = {
 	{  510,    425  }   /*C/N=51.0dB*/
 };
 
-struct slookup s2_sn_lookup[] = {
+static struct slookup s2_sn_lookup[] = {
 	{  -30,  13950  },  /*C/N=-2.5dB*/
 	{  -25,  13580  },  /*C/N=-2.5dB*/
 	{  -20,  13150  },  /*C/N=-2.0dB*/
@@ -327,7 +327,7 @@ struct slookup s2_sn_lookup[] = {
 	{  510,    463  },  /*C/N=51.0dB*/
 };
 
-struct slookup padc_lookup[] = {
+static struct slookup padc_lookup[] = {
 	{    0,  118000 }, /* PADC=+0dBm  */
 	{ -100,  93600  }, /* PADC=-1dBm  */
 	{ -200,  74500  }, /* PADC=-2dBm  */
-- 
2.11.0
