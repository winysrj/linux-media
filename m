Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32842 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752869AbdC2QnT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:19 -0400
Received: by mail-wr0-f193.google.com with SMTP id u18so4575628wrc.0
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:18 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 02/13] [media] dvb-frontends/stv0367: print CPAMP status only if stv_debug is enabled
Date: Wed, 29 Mar 2017 18:43:02 +0200
Message-Id: <20170329164313.14636-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
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
