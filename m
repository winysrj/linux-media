Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:60218 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdBWTBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 14:01:22 -0500
Date: Thu, 23 Feb 2017 20:00:30 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
        linux-media@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [media] rc: raw decoder for keymap protocol is not
 loaded on register
Message-ID: <20170223190030.GA10739@camel2.lan>
References: <20170222230052.GA17047@gofer.mess.org>
 <1487805109-17432-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487805109-17432-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 22, 2017 at 11:11:49PM +0000, Sean Young wrote:
> When the protocol is set via the sysfs protocols attribute, the
> decoder is loaded. However, when it is not when a device is first
> plugged in or registered.
> 
> Fixes: acc1c3c ("[media] media: rc: load decoder modules on-demand")
> 
> Signed-off-by: Sean Young <sean@mess.org>

Tested-by: Matthias Reichl <hias@horus.com>

I've tested the backported patch below successfully on RPi3 with
kernel 4.10 and decoder modules are loading fine again:

# dmesg | grep "IR "
[    3.526404] Registered IR keymap rc-hauppauge
[    3.590875] lirc_dev: IR Remote Control driver registered, major 242
[    3.600602] IR RC5(x/sz) protocol handler initialized
[    3.602111] IR LIRC bridge handler initialized

Thanks a lot for fixing this so quickly!

so long,

Hias

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index dedaf38..9a397da 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1441,6 +1441,7 @@ int rc_register_device(struct rc_dev *dev)
 	int attr = 0;
 	int minor;
 	int rc;
+	u64 rc_type;
 
 	if (!dev || !dev->map_name)
 		return -EINVAL;
@@ -1526,14 +1527,18 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_input;
 	}
 
+	rc_type = BIT_ULL(rc_map->rc_type);
+
 	if (dev->change_protocol) {
-		u64 rc_type = (1ll << rc_map->rc_type);
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;
 		dev->enabled_protocols = rc_type;
 	}
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_load_modules(&rc_type);
+
 	/* Allow the RC sysfs nodes to be accessible */
 	atomic_set(&dev->initialized, 1);
 
