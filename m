Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43648 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752120AbdHBQq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 12:46:56 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
        Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 2/2] cx231xx: fix use-after-free when unregistering the i2c_client for the dvb demod
Date: Wed,  2 Aug 2017 18:46:00 +0200
Message-Id: <20170802164600.19553-3-zzam@gentoo.org>
In-Reply-To: <20170802164600.19553-1-zzam@gentoo.org>
References: <20170802164600.19553-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling i2c_unregister_device for a demod driver destroys the frontend object.
Later it is accessed by calling dvb_unregister_frontend and
dvb_frontend_detach.

In some cases this leads to a general protection fault with this
callstack:

  dvb_unregister_frontend+0x25/0x50 [dvb_core]
  dvb_fini+0xdb/0x160 [cx231xx_dvb]
  cx231xx_unregister_extension+0x3d/0xb0 [cx231xx]
  cx231xx_dvb_unregister+0x10/0x809 [cx231xx_dvb]
  SyS_delete_module+0x18a/0x240
  ? exit_to_usermode_loop+0x7b/0x80
  entry_SYSCALL_64_fastpath+0x17/0x98

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index ee3eeeb600f8..c18bb33e060e 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -585,6 +585,9 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	dvb_dmxdev_release(&dvb->dmxdev);
 	dvb_dmx_release(&dvb->demux);
+	dvb_unregister_frontend(dvb->frontend);
+	dvb_frontend_detach(dvb->frontend);
+	dvb_unregister_adapter(&dvb->adapter);
 	/* remove I2C tuner */
 	client = dvb->i2c_client_tuner;
 	if (client) {
@@ -597,9 +600,6 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
 	}
-	dvb_unregister_frontend(dvb->frontend);
-	dvb_frontend_detach(dvb->frontend);
-	dvb_unregister_adapter(&dvb->adapter);
 }
 
 static int dvb_init(struct cx231xx *dev)
-- 
2.13.3
