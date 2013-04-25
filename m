Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943Ab3DYSgB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 14:36:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Olivier Grenie <olivier.grenie@parrot.com>,
	Patrick Boettcher <patrick.boettcher@parrot.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/5] dib0090: Fix a warning at dib0090_set_EFUSE
Date: Thu, 25 Apr 2013 15:35:49 -0300
Message-Id: <1366914949-32587-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
References: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check if the values for c, h and n are within the range is
always true, as, if one of this values is out of range, the
previous "if" clauses will default to a value within the
range.

That fixes the following warning:

	drivers/media/dvb-frontends/dib0090.c: In function 'dib0090_set_EFUSE':
	drivers/media/dvb-frontends/dib0090.c:1545:5: warning: comparison is always true due to limited range of data type [-Wtype-limits]

and makes the code easier to read.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/dib0090.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index f9916b8..3ee22ff 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -1540,13 +1540,9 @@ static void dib0090_set_EFUSE(struct dib0090_state *state)
 		if ((n >= POLY_MAX) || (n <= POLY_MIN))
 			n = 3;
 
-		if ((c >= CAP_VALUE_MIN) && (c <= CAP_VALUE_MAX)
-				&& (h >= HR_MIN) && (h <= HR_MAX)
-				&& (n >= POLY_MIN) && (n <= POLY_MAX)) {
-			dib0090_write_reg(state, 0x13, (h << 10));
-			e2 = (n << 11) | ((h >> 2)<<6) | c;
-			dib0090_write_reg(state, 0x2, e2); /* Load the BB_2 */
-		}
+		dib0090_write_reg(state, 0x13, (h << 10));
+		e2 = (n << 11) | ((h >> 2)<<6) | c;
+		dib0090_write_reg(state, 0x2, e2); /* Load the BB_2 */
 	}
 }
 
-- 
1.8.1.4

