Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:47398 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab0CXNRs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 09:17:48 -0400
From: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>, stable@kernel.org
Subject: [PATCH v2] V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"
Date: Wed, 24 Mar 2010 14:17:38 +0100
Message-Id: <1269436658-20370-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
References: <1269428277-6709-1-git-send-email-bjorn@mork.no> <201003241325.52864@orion.escape-edv.de>
In-Reply-To: <201003241325.52864@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Never call dvb_frontend_detach if we failed to attach a frontend. This fixes
the following oops:

[    8.172997] DVB: registering new adapter (TT-Budget S2-1600 PCI)
[    8.209018] adapter has MAC addr = 00:d0:5c:cc:a7:29
[    8.328665] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    8.328753] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    8.562047] DVB: Unable to find symbol stv090x_attach()
[    8.562117] BUG: unable to handle kernel NULL pointer dereference at 000000ac
[    8.562239] IP: [<e08b04a3>] dvb_frontend_detach+0x4/0x67 [dvb_core]

Ref http://bugs.debian.org/575207

Also clean up if we are unable to register the tuner and LNB drivers

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: stable@kernel.org
Reported-by: Fladischer Michael <FladischerMichael@fladi.at>
---
Oliver Endriss <o.endriss@gmx.de> writes:

> Could you please extend your patch in a way
> that it will also catch, if
> - dvb_attach(stv6110x_attach,...)
> - dvb_attach(isl6423_attach,...)
> fail?

OK.  Attempting, although I have no clue whether such failures are really
fatal or not...

This is version 2 of this patch, adding cleanup in case we fail to register
the two submodules used by this card/frontend.  I'm not certain that this 
additional cleanup is appropriate for stable as any failure to register 
these will be handled cleanly AFAICS.  But I have no way to test this.

This patch should apply cleanly to 2.6.32, 2.6.33, 2.6.34-rc2

This does not apply cleanly to git://linuxtv.org/v4l-dvb.git master.  I will 
followup with a similar patch for that branch

Please apply to stable if appropriate.  If not, please apply version 1
of the patch, which fixes only the oops condition.



 drivers/media/dvb/ttpci/budget.c |   42 ++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index e48380c..4666c1e 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -627,25 +627,29 @@ static void frontend_init(struct budget *budget)
 						 &tt1600_stv6110x_config,
 						 &budget->i2c_adap);
 
-				tt1600_stv090x_config.tuner_init	  = ctl->tuner_init;
-				tt1600_stv090x_config.tuner_set_mode	  = ctl->tuner_set_mode;
-				tt1600_stv090x_config.tuner_set_frequency = ctl->tuner_set_frequency;
-				tt1600_stv090x_config.tuner_get_frequency = ctl->tuner_get_frequency;
-				tt1600_stv090x_config.tuner_set_bandwidth = ctl->tuner_set_bandwidth;
-				tt1600_stv090x_config.tuner_get_bandwidth = ctl->tuner_get_bandwidth;
-				tt1600_stv090x_config.tuner_set_bbgain	  = ctl->tuner_set_bbgain;
-				tt1600_stv090x_config.tuner_get_bbgain	  = ctl->tuner_get_bbgain;
-				tt1600_stv090x_config.tuner_set_refclk	  = ctl->tuner_set_refclk;
-				tt1600_stv090x_config.tuner_get_status	  = ctl->tuner_get_status;
-
-				dvb_attach(isl6423_attach,
-					budget->dvb_frontend,
-					&budget->i2c_adap,
-					&tt1600_isl6423_config);
-
-			} else {
-				dvb_frontend_detach(budget->dvb_frontend);
-				budget->dvb_frontend = NULL;
+				if (ctl) {
+					tt1600_stv090x_config.tuner_init	  = ctl->tuner_init;
+					tt1600_stv090x_config.tuner_set_mode	  = ctl->tuner_set_mode;
+					tt1600_stv090x_config.tuner_set_frequency = ctl->tuner_set_frequency;
+					tt1600_stv090x_config.tuner_get_frequency = ctl->tuner_get_frequency;
+					tt1600_stv090x_config.tuner_set_bandwidth = ctl->tuner_set_bandwidth;
+					tt1600_stv090x_config.tuner_get_bandwidth = ctl->tuner_get_bandwidth;
+					tt1600_stv090x_config.tuner_set_bbgain	  = ctl->tuner_set_bbgain;
+					tt1600_stv090x_config.tuner_get_bbgain	  = ctl->tuner_get_bbgain;
+					tt1600_stv090x_config.tuner_set_refclk	  = ctl->tuner_set_refclk;
+					tt1600_stv090x_config.tuner_get_status	  = ctl->tuner_get_status;
+
+					if (dvb_attach(isl6423_attach,
+						       budget->dvb_frontend,
+						       &budget->i2c_adap,
+						       &tt1600_isl6423_config) == NULL) {
+						printk("%s: No Intersil ISL6423 found!\n", __func__);
+						goto error_out;
+					}
+				} else {
+					printk("%s: No STV6110(A) Silicon Tuner found!\n", __func__);
+					goto error_out;
+				}
 			}
 		}
 		break;
-- 
1.5.6.5

