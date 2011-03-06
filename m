Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33399 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1CFNlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 08:41:42 -0500
Date: Sun, 6 Mar 2011 16:41:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [media] stv0367: typo in function parameter
Message-ID: <20110306134123.GP3416@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The CellsCoeffs arrays are [3][6][5] not [2][6][5].

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index 7117ce9..ec9de40 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -1046,7 +1046,7 @@ static u32 stv0367ter_get_mclk(struct stv0367_state *state, u32 ExtClk_Hz)
 }
 
 static int stv0367ter_filt_coeff_init(struct stv0367_state *state,
-				u16 CellsCoeffs[2][6][5], u32 DemodXtal)
+				u16 CellsCoeffs[3][6][5], u32 DemodXtal)
 {
 	int i, j, k, freq;
 
