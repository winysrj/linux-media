Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943Ab3DYSf7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 14:35:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Olivier Grenie <olivier.grenie@parrot.com>,
	Patrick Boettcher <patrick.boettcher@parrot.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/5] [media] dib8000: fix a warning
Date: Thu, 25 Apr 2013 15:35:48 -0300
Message-Id: <1366914949-32587-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
References: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/dib8000.c: In function 'dib8000_wait_lock':
drivers/media/dvb-frontends/dib8000.c:3972:1: warning: 'value' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/media/dvb-frontends/dib8000.c:2419:6: note: 'value' was declared here

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/dib8000.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 57863d3..a54182d 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2416,19 +2416,19 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 static u32 dib8000_wait_lock(struct dib8000_state *state, u32 internal,
 			     u32 wait0_ms, u32 wait1_ms, u32 wait2_ms)
 {
-	u32 value;
-	u16 reg = 11; /* P_search_end0 start addr */
+	u32 value = 0;	/* P_search_end0 wait time */
+	u16 reg = 11;	/* P_search_end0 start addr */
 
 	for (reg = 11; reg < 16; reg += 2) {
 		if (reg == 11) {
 			if (state->revision == 0x8090)
-				value = internal * wait1_ms; /* P_search_end0 wait time */
+				value = internal * wait1_ms;
 			else
-				value = internal * wait0_ms; /* P_search_end0 wait time */
+				value = internal * wait0_ms;
 		} else if (reg == 13)
-			value = internal * wait1_ms; /* P_search_end0 wait time */
+			value = internal * wait1_ms;
 		else if (reg == 15)
-			value = internal * wait2_ms; /* P_search_end0 wait time */
+			value = internal * wait2_ms;
 		dib8000_write_word(state, reg, (u16)((value >> 16) & 0xffff));
 		dib8000_write_word(state, (reg + 1), (u16)(value & 0xffff));
 	}
-- 
1.8.1.4

