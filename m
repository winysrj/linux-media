Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:43542 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbeAEAFS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:05:18 -0500
Received: from homiemail-a116.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 08ABF8ED96
        for <linux-media@vger.kernel.org>; Thu,  4 Jan 2018 16:05:18 -0800 (PST)
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 7/9] lgdt3306a: Set fe ops.release to NULL if probed
Date: Thu,  4 Jan 2018 18:04:17 -0600
Message-Id: <1515110659-20145-8-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If release is part of frontend ops then it is called in the
course of dvb_frontend_detach. The process also decrements
the module usage count. The problem is if the lgdt3306a
driver is reached via i2c_new_device, then when it is
eventually destroyed remove is called, which further
decrements the module usage count to negative. After this
occurs the driver is in a bad state and no longer works.
Also fixed by NULLing out the release callback is a double
kfree of state, which introduces arbitrary oopses/GPF.
This problem is only currently reachable via the em28xx driver.

On disconnect of Hauppauge SoloHD before:

lsmod | grep lgdt3306a
lgdt3306a              28672  -1
i2c_mux                16384  1 lgdt3306a

On disconnect of Hauppauge SoloHD after:

lsmod | grep lgdt3306a
lgdt3306a              28672  0
i2c_mux                16384  1 lgdt3306a

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 6356815..d2477ed 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -2177,6 +2177,7 @@ static int lgdt3306a_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, fe->demodulator_priv);
 	state = fe->demodulator_priv;
+	state->frontend.ops.release = NULL;
 
 	/* create mux i2c adapter for tuner */
 	state->muxc = i2c_mux_alloc(client->adapter, &client->dev,
-- 
2.7.4
