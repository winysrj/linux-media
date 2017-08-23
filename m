Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38239 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754136AbdHWQKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 12:10:08 -0400
Received: by mail-wm0-f65.google.com with SMTP id l19so547376wmi.5
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 09:10:07 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 2/5] [media] ddbridge: fix teardown/deregistration order in ddb_input_detach()
Date: Wed, 23 Aug 2017 18:09:59 +0200
Message-Id: <20170823161002.25459-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170823161002.25459-1-d.scheller.oss@gmail.com>
References: <20170823161002.25459-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Brought to attention by Matthias Schwarzott <zzam@gentoo.org> by fixing
possible use-after-free faults in some demod drivers:

In ddb_input_detach(), the i2c_client is unregistered and removed before
dvb frontends are unregistered and detached. While no use-after-free issue
was observed so far, there is another issue with this:

dvb->attached keeps track of the state of the input/output registration,
and the i2c_client unregistration takes place only if everything was
successful (dvb->attached == 0x31). If for some reason an error occurred
during the frontend setup, that value stays at 0x20. In the following
error handling and cleanup, ddb_input_detach() will skip down to that
state, leaving the i2c_client registered, causing refcount issues.

Fix this by moving the i2c_client deregistration down to case 0x20.

Cc: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 2464bde1c432..281b6739b0c1 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1255,11 +1255,6 @@ static void dvb_input_detach(struct ddb_input *input)
 
 	switch (dvb->attached) {
 	case 0x31:
-		client = dvb->i2c_client[0];
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
 		if (dvb->fe2)
 			dvb_unregister_frontend(dvb->fe2);
 		if (dvb->fe)
@@ -1273,6 +1268,12 @@ static void dvb_input_detach(struct ddb_input *input)
 		dvb->fe = dvb->fe2 = NULL;
 		/* fallthrough */
 	case 0x20:
+		client = dvb->i2c_client[0];
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
+
 		dvb_net_release(&dvb->dvbnet);
 		/* fallthrough */
 	case 0x12:
-- 
2.13.0
