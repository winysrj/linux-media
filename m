Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34922 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935477AbdCXSZr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 14:25:47 -0400
Received: by mail-wm0-f65.google.com with SMTP id z133so2223216wmb.2
        for <linux-media@vger.kernel.org>; Fri, 24 Mar 2017 11:25:40 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 02/12] [media] dvb-frontends/stv0367: print CPAMP status only if stv_debug is enabled
Date: Fri, 24 Mar 2017 19:23:58 +0100
Message-Id: <20170324182408.25996-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170324182408.25996-1-d.scheller.oss@gmail.com>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The CPAMP log lines generated in stv0367_ter_check_cpamp() are printed
everytime tuning succeeds or fails, quite cluttering the normal kernel log.
Use dprintk() instead of printk(KERN_ERR...) so that if the information is
needed, it'll be printed when the stv_debug modparam is enabled.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index fc80934..0064d9d 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1262,9 +1262,9 @@ stv0367_ter_signal_type stv0367ter_check_cpamp(struct stv0367_state *state,
 	dprintk("******last CPAMPvalue= %d at wd=%d\n", CPAMPvalue, wd);
 	if (CPAMPvalue < CPAMPMin) {
 		CPAMPStatus = FE_TER_NOCPAMP;
-		printk(KERN_ERR "CPAMP failed\n");
+		dprintk("%s: CPAMP failed\n", __func__);
 	} else {
-		printk(KERN_ERR "CPAMP OK !\n");
+		dprintk("%s: CPAMP OK !\n", __func__);
 		CPAMPStatus = FE_TER_CPAMPOK;
 	}
 
-- 
2.10.2
