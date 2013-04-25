Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759389Ab3DYSgH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 14:36:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Olivier Grenie <olivier.grenie@parrot.com>,
	Patrick Boettcher <patrick.boettcher@parrot.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/5] [media] dib8000: warning fix: declare internal functions as static
Date: Thu, 25 Apr 2013 15:35:45 -0300
Message-Id: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/dib8000.c:2412:5: warning: no previous prototype for 'dib8000_wait_lock' [-Wmissing-prototypes]
drivers/media/dvb-frontends/dib8000.c:2688:5: warning: no previous prototype for 'dib8000_get_symbol_duration' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/dib8000.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 1d719cc..d065a72 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2409,7 +2409,8 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	state->isdbt_cfg_loaded = 0;
 }
 
-u32 dib8000_wait_lock(struct dib8000_state *state, u32 internal, u32 wait0_ms, u32 wait1_ms, u32 wait2_ms)
+static u32 dib8000_wait_lock(struct dib8000_state *state, u32 internal,
+			     u32 wait0_ms, u32 wait1_ms, u32 wait2_ms)
 {
 	u32 value;
 	u16 reg = 11; /* P_search_end0 start addr */
@@ -2685,7 +2686,8 @@ static void dib8000_set_frequency_offset(struct dib8000_state *state)
 }
 
 static u16 LUT_isdbt_symbol_duration[4] = { 26, 101, 63 };
-u32 dib8000_get_symbol_duration(struct dib8000_state *state)
+
+static u32 dib8000_get_symbol_duration(struct dib8000_state *state)
 {
 	u16 i;
 
-- 
1.8.1.4

