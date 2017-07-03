Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35524 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755472AbdGCRVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 13:21:11 -0400
Received: by mail-wr0-f194.google.com with SMTP id z45so45400036wrb.2
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 10:21:10 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v3 02/10] [media] dvb-frontends/stv0910: Fix possible buffer overflow
Date: Mon,  3 Jul 2017 19:20:55 +0200
Message-Id: <20170703172104.27283-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170703172104.27283-1-d.scheller.oss@gmail.com>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes smatch error:

  drivers/media/dvb-frontends/stv0910.c:715 dvbs2_nbch() error: buffer overflow 'nbch[fectype]' 2 <= 28

Also, fixes the nbch array table by adding the DUMMY_PLF element at the top
to match the enums (table element order was off by one before).

Patch sent upstream aswell.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
---
 drivers/media/dvb-frontends/stv0910.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 9dfcaf5e067f..85439d3b725e 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -671,6 +671,7 @@ static int get_bit_error_rate_s(struct stv *state, u32 *bernumerator,
 static u32 dvbs2_nbch(enum dvbs2_mod_cod mod_cod, enum dvbs2_fectype fectype)
 {
 	static u32 nbch[][2] = {
+		{    0,     0}, /* DUMMY_PLF */
 		{16200,  3240}, /* QPSK_1_4, */
 		{21600,  5400}, /* QPSK_1_3, */
 		{25920,  6480}, /* QPSK_2_5, */
@@ -703,7 +704,7 @@ static u32 dvbs2_nbch(enum dvbs2_mod_cod mod_cod, enum dvbs2_fectype fectype)
 
 	if (mod_cod >= DVBS2_QPSK_1_4 &&
 	    mod_cod <= DVBS2_32APSK_9_10 && fectype <= DVBS2_16K)
-		return nbch[fectype][mod_cod];
+		return nbch[mod_cod][fectype];
 	return 64800;
 }
 
-- 
2.13.0
