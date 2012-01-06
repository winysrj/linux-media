Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38146 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab2AFQ6B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 11:58:01 -0500
Received: by yenm11 with SMTP id m11so745640yen.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 08:58:01 -0800 (PST)
Date: Fri, 6 Jan 2012 10:57:56 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@sig21.net>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>
Subject: [PATCH] [media] flexcop: CodingStyle fix: don't use "if ((ret =
 foo()) < 0)"
Message-ID: <20120106165756.GB15740@elie.hsd1.il.comcast.net>
References: <E1RjBAD-0006Us-QZ@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1RjBAD-0006Us-QZ@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lift assignments from "if" conditionals for readability.  No change
in functionality intended.

Suggested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Mauro Carvalho Chehab wrote:

> Subject: [media] flexcop: handle errors from dvb_net_init
[...]
> [mchehab@redhat.com: CodingStyle fix: don't use  "if ((ret = foo()) < 0)"]

Here's a patch to take care of the other instances of that construct
in the same file.

 drivers/media/dvb/b2c2/flexcop.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/b2c2/flexcop.c b/drivers/media/dvb/b2c2/flexcop.c
index 4d3caca466fd..b1e8c99f469b 100644
--- a/drivers/media/dvb/b2c2/flexcop.c
+++ b/drivers/media/dvb/b2c2/flexcop.c
@@ -86,7 +86,8 @@ static int flexcop_dvb_init(struct flexcop_device *fc)
 	fc->demux.stop_feed = flexcop_dvb_stop_feed;
 	fc->demux.write_to_decoder = NULL;
 
-	if ((ret = dvb_dmx_init(&fc->demux)) < 0) {
+	ret = dvb_dmx_init(&fc->demux);
+	if (ret < 0) {
 		err("dvb_dmx failed: error %d", ret);
 		goto err_dmx;
 	}
@@ -96,23 +97,27 @@ static int flexcop_dvb_init(struct flexcop_device *fc)
 	fc->dmxdev.filternum = fc->demux.feednum;
 	fc->dmxdev.demux = &fc->demux.dmx;
 	fc->dmxdev.capabilities = 0;
-	if ((ret = dvb_dmxdev_init(&fc->dmxdev, &fc->dvb_adapter)) < 0) {
+	ret = dvb_dmxdev_init(&fc->dmxdev, &fc->dvb_adapter);
+	if (ret < 0) {
 		err("dvb_dmxdev_init failed: error %d", ret);
 		goto err_dmx_dev;
 	}
 
-	if ((ret = fc->demux.dmx.add_frontend(&fc->demux.dmx, &fc->hw_frontend)) < 0) {
+	ret = fc->demux.dmx.add_frontend(&fc->demux.dmx, &fc->hw_frontend);
+	if (ret < 0) {
 		err("adding hw_frontend to dmx failed: error %d", ret);
 		goto err_dmx_add_hw_frontend;
 	}
 
 	fc->mem_frontend.source = DMX_MEMORY_FE;
-	if ((ret = fc->demux.dmx.add_frontend(&fc->demux.dmx, &fc->mem_frontend)) < 0) {
+	ret = fc->demux.dmx.add_frontend(&fc->demux.dmx, &fc->mem_frontend);
+	if (ret < 0) {
 		err("adding mem_frontend to dmx failed: error %d", ret);
 		goto err_dmx_add_mem_frontend;
 	}
 
-	if ((ret = fc->demux.dmx.connect_frontend(&fc->demux.dmx, &fc->hw_frontend)) < 0) {
+	ret = fc->demux.dmx.connect_frontend(&fc->demux.dmx, &fc->hw_frontend);
+	if (ret < 0) {
 		err("connect frontend failed: error %d", ret);
 		goto err_connect_frontend;
 	}
@@ -260,7 +265,8 @@ int flexcop_device_initialize(struct flexcop_device *fc)
 	flexcop_hw_filter_init(fc);
 	flexcop_smc_ctrl(fc, 0);
 
-	if ((ret = flexcop_dvb_init(fc)))
+	ret = flexcop_dvb_init(fc);
+	if (ret)
 		goto error;
 
 	/* i2c has to be done before doing EEProm stuff -
@@ -278,7 +284,8 @@ int flexcop_device_initialize(struct flexcop_device *fc)
 	} else
 		warn("reading of MAC address failed.\n");
 
-	if ((ret = flexcop_frontend_init(fc)))
+	ret = flexcop_frontend_init(fc);
+	if (ret)
 		goto error;
 
 	flexcop_device_name(fc,"initialization of","complete");
-- 
1.7.8.2

