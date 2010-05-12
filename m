Return-path: <linux-media-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.158.22]:33064 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab0ELOkw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 10:40:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by ryu.zarb.org (Postfix) with ESMTP id 2E4B73FC30
	for <linux-media@vger.kernel.org>; Wed, 12 May 2010 16:40:51 +0200 (CEST)
Received: from ryu.zarb.org ([127.0.0.1])
	by localhost (ryu.zarb.org [127.0.0.1]) (amavisd-new, port 10025)
	with ESMTP id BZlBAZtbDeFY for <linux-media@vger.kernel.org>;
	Wed, 12 May 2010 16:40:50 +0200 (CEST)
Received: from [192.168.100.101] (unknown [195.7.104.248])
	by ryu.zarb.org (Postfix) with ESMTPSA id 036AB3FC32
	for <linux-media@vger.kernel.org>; Wed, 12 May 2010 16:40:49 +0200 (CEST)
Subject: [PATCH] [budget] Wrong code on init failure
From: Pascal Terjan <pterjan@mandriva.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 12 May 2010 16:40:40 +0200
Message-ID: <1273675240.20854.68.camel@plop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In frontend_init you can read:

    if (budget->dvb_frontend) {
        ctl = dvb_attach(stv6110x_attach,
                         budget->dvb_frontend,
                         &tt1600_stv6110x_config,
                         &budget->i2c_adap);
        tt1600_stv090x_config.tuner_init          = ctl->tuner_init;

[...]

    } else {
        dvb_frontend_detach(budget->dvb_frontend);
        budget->dvb_frontend = NULL;
    }

But if we are in else, budget->dvb_frontend is already NULL...

I guess the else part could better apply to a test on ctl before using
it
---
 drivers/media/dvb/ttpci/budget.c |   39 +++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index 9fdf26c..14adf27 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -627,25 +627,26 @@ static void frontend_init(struct budget *budget)
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
+					dvb_attach(isl6423_attach,
+						budget->dvb_frontend,
+						&budget->i2c_adap,
+						&tt1600_isl6423_config);
+				} else {
+					dvb_frontend_detach(budget->dvb_frontend);
+					budget->dvb_frontend = NULL;
+				}
 			}
 		}
 		break;
-- 
1.7.1


