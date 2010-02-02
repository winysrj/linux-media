Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757052Ab0BBWlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 17:41:20 -0500
Message-Id: <201002022240.o12MepBf018922@imap1.linux-foundation.org>
Subject: [patch 7/7] drivers/media/dvb/frontends/stv090x.c: fix use-uninitlalised
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	manu@linuxtv.org, mchehab@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 02 Feb 2010 14:40:51 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

Mad guess.

Cc: Manu Abraham <manu@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stv090x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised drivers/media/dvb/frontends/stv090x.c
--- a/drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised
+++ a/drivers/media/dvb/frontends/stv090x.c
@@ -2047,7 +2047,7 @@ static int stv090x_chk_tmg(struct stv090
 	u32 reg;
 	s32 tmg_cpt = 0, i;
 	u8 freq, tmg_thh, tmg_thl;
-	int tmg_lock;
+	int tmg_lock = 0;
 
 	freq = STV090x_READ_DEMOD(state, CARFREQ);
 	tmg_thh = STV090x_READ_DEMOD(state, TMGTHRISE);
_
