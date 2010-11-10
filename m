Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48460 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab0KJM32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:29:28 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hong Liu <hong.liu@intel.com>, Alan Cox <alan@linux.intel.com>,
	Anantha Narayanan <anantha.narayanan@intel.com>,
	Andres Salomon <dilinger@queued.net>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: [PATCH] i2c: Remove obsolete cleanup for clientdata
Date: Wed, 10 Nov 2010 13:28:19 +0100
Message-Id: <1289392100-32668-1-git-send-email-w.sang@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit. This is obsolete meanwhile, so fix it and hope the word will spread.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

Like last time I suggest to collect acks from the driver authors and merge it
vie Jean's i2c-tree.

 drivers/media/video/imx074.c          |    2 --
 drivers/media/video/ov6650.c          |    2 --
 drivers/misc/apds9802als.c            |    1 -
 drivers/staging/olpc_dcon/olpc_dcon.c |    3 ---
 4 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 380e459..27b5dfd 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -451,7 +451,6 @@ static int imx074_probe(struct i2c_client *client,
 	ret = imx074_video_probe(icd, client);
 	if (ret < 0) {
 		icd->ops = NULL;
-		i2c_set_clientdata(client, NULL);
 		kfree(priv);
 		return ret;
 	}
@@ -468,7 +467,6 @@ static int imx074_remove(struct i2c_client *client)
 	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
-	i2c_set_clientdata(client, NULL);
 	client->driver = NULL;
 	kfree(priv);
 
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index b7cfeab..2dd5298 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -1176,7 +1176,6 @@ static int ov6650_probe(struct i2c_client *client,
 
 	if (ret) {
 		icd->ops = NULL;
-		i2c_set_clientdata(client, NULL);
 		kfree(priv);
 	}
 
@@ -1187,7 +1186,6 @@ static int ov6650_remove(struct i2c_client *client)
 {
 	struct ov6650 *priv = to_ov6650(client);
 
-	i2c_set_clientdata(client, NULL);
 	kfree(priv);
 	return 0;
 }
diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index f9b91ba..abe3d21 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -251,7 +251,6 @@ static int apds9802als_probe(struct i2c_client *client,
 
 	return res;
 als_error1:
-	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return res;
 }
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 75aa7a36..f286a4c 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -733,7 +733,6 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
  edev:
 	platform_device_unregister(dcon_device);
 	dcon_device = NULL;
-	i2c_set_clientdata(client, NULL);
  eirq:
 	free_irq(DCON_IRQ, &dcon_driver);
  einit:
@@ -757,8 +756,6 @@ static int dcon_remove(struct i2c_client *client)
 		platform_device_unregister(dcon_device);
 	cancel_work_sync(&dcon_work);
 
-	i2c_set_clientdata(client, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.3

