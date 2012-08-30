Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41622 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2H3L1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 07:27:23 -0400
Received: by lbbgj3 with SMTP id gj3so414366lbb.19
        for <linux-media@vger.kernel.org>; Thu, 30 Aug 2012 04:27:22 -0700 (PDT)
Message-ID: <503F4E19.1050700@gmail.com>
Date: Thu, 30 Aug 2012 13:27:21 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: tda8290 regression fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Ever since 2.6.26 or so (where there was a code reorg) I had to carry 
this patch.
Without it the received signal is noisy, and the card worked fine prior 
to the code
reorg. This patch is a hack, mostly as a result of my inability to 
follow the code
paths (and bisect failing). I'd be more than willing to test whatever 
the proper
patch might be prior to any mainlining.

Thanks,
/Anders



$ cat /TV_CARD.diff
diff --git a/drivers/media/common/tuners/tda8290.c 
b/drivers/media/common/tuners/tda8290.c
index 064d14c..498cc7b 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)

                 dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
                            priv->i2c_props.adap, &priv->cfg);
+               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new 
0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
                 priv->cfg.switch_addr = priv->i2c_props.addr;
+               priv->cfg.switch_addr = 0xc2 / 2;
+               tuner_info("ANDERS: new 0x%02x\n",priv->cfg.switch_addr);
+
         }
         if (fe->ops.tuner_ops.init)
                 fe->ops.tuner_ops.init(fe);

