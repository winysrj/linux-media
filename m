Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757095Ab0BBWlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 17:41:20 -0500
Message-Id: <201002022240.o12MeokZ018918@imap1.linux-foundation.org>
Subject: [patch 6/7] drivers/media/dvb/frontends/stv090x.c: fix use-uninitialised
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	manu@linuxtv.org, mchehab@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 02 Feb 2010 14:40:50 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/dvb/frontends/stv090x.c: In function 'stv090x_blind_search':
drivers/media/dvb/frontends/stv090x.c:1967: warning: 'coarse_fail' may be used uninitialized in this function

Cc: Manu Abraham <manu@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stv090x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised drivers/media/dvb/frontends/stv090x.c
--- a/drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised
+++ a/drivers/media/dvb/frontends/stv090x.c
@@ -1964,7 +1964,8 @@ static int stv090x_blind_search(struct s
 	u32 agc2, reg, srate_coarse;
 	s32 cpt_fail, agc2_ovflw, i;
 	u8 k_ref, k_max, k_min;
-	int coarse_fail, lock;
+	int coarse_fail = 0;
+	int lock;
 
 	k_max = 110;
 	k_min = 10;
_
