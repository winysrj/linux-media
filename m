Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32813 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdCGTJO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 14:09:14 -0500
Received: by mail-wr0-f196.google.com with SMTP id g10so1427788wrg.0
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 11:07:24 -0800 (PST)
Received: from dvbdev.wuest.de (ip-178-201-73-185.hsi08.unitymediagroup.de. [178.201.73.185])
        by smtp.gmail.com with ESMTPSA id m186sm13760369wmd.21.2017.03.07.10.58.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Mar 2017 10:58:30 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/13] [media] dvb-frontends/stv0367: print CPAMP status only if stv_debug is enabled
Date: Tue,  7 Mar 2017 19:57:16 +0100
Message-Id: <20170307185727.564-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170307185727.564-1-d.scheller.oss@gmail.com>
References: <20170307185727.564-1-d.scheller.oss@gmail.com>
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
