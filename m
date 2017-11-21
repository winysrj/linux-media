Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58854 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdKUPHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 10:07:47 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Scheller <d.scheller@gmx.net>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-frontends/stv0367: remove redundant self assignment of temporary
Date: Tue, 21 Nov 2017 15:07:45 +0000
Message-Id: <20171121150745.18211-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The self assignment of temporary is redundant and can be removed.
Detected using coccinelle.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/stv0367.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index f3529df8211d..ebad100d913f 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1547,7 +1547,6 @@ static int stv0367ter_read_ber(struct dvb_frontend *fe, u32 *ber)
 	} else if (abc == 0x7) {
 		if (Errors <= 4) {
 			temporary = (Errors * 1000000000) / (8 * (1 << 14));
-			temporary =  temporary;
 		} else if (Errors <= 42) {
 			temporary = (Errors * 100000000) / (8 * (1 << 14));
 			temporary = temporary * 10;
@@ -1625,7 +1624,6 @@ static u32 stv0367ter_get_per(struct stv0367_state *state)
 	else if (abc == 0x9) {
 		if (Errors <= 4) {
 			temporary = (Errors * 1000000000) / (8 * (1 << 8));
-			temporary =  temporary;
 		} else if (Errors <= 42) {
 			temporary = (Errors * 100000000) / (8 * (1 << 8));
 			temporary = temporary * 10;
-- 
2.14.1
