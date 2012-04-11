Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39949 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2DKIXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 04:23:48 -0400
Received: by eaaq12 with SMTP id q12so131633eaa.19
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2012 01:23:47 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: fix v2.6.35_i2c_new_probed_device backport patch
Date: Wed, 11 Apr 2012 10:23:38 +0200
Message-Id: <1334132618-20124-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch:
http://patchwork.linuxtv.org/patch/10486/
collides with the v2.6.35_i2c_new_probed_device backport patch.
Fix it and rebase it on the new media_build tree.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/v2.6.35_i2c_new_probed_device.patch |   46 ++++++++++++------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/backports/v2.6.35_i2c_new_probed_device.patch b/backports/v2.6.35_i2c_new_probed_device.patch
index d998814..4026dc9 100644
--- a/backports/v2.6.35_i2c_new_probed_device.patch
+++ b/backports/v2.6.35_i2c_new_probed_device.patch
@@ -2,14 +2,14 @@
  drivers/media/video/bt8xx/bttv-input.c    |    2 +-
  drivers/media/video/cx18/cx18-i2c.c       |    2 +-
  drivers/media/video/cx23885/cx23885-i2c.c |    5 +++--
- drivers/media/video/em28xx/em28xx-cards.c |    2 +-
+ drivers/media/video/em28xx/em28xx-input.c |    2 +-
  drivers/media/video/ivtv/ivtv-i2c.c       |    6 +++---
  drivers/media/video/v4l2-common.c         |    3 +--
  6 files changed, 10 insertions(+), 10 deletions(-)
 
---- linux.orig/drivers/media/video/bt8xx/bttv-input.c
-+++ linux/drivers/media/video/bt8xx/bttv-input.c
-@@ -399,7 +399,7 @@ void __devinit init_bttv_i2c_ir(struct b
+--- a/drivers/media/video/bt8xx/bttv-input.c
++++ b/drivers/media/video/bt8xx/bttv-input.c
+@@ -401,7 +401,7 @@ void __devinit init_bttv_i2c_ir(struct bttv *btv)
  		 * That's why we probe 0x1a (~0x34) first. CB
  		 */
  
@@ -18,9 +18,9 @@
  		return;
  	}
  
---- linux.orig/drivers/media/video/cx18/cx18-i2c.c
-+++ linux/drivers/media/video/cx18/cx18-i2c.c
-@@ -104,7 +104,7 @@ static int cx18_i2c_new_ir(struct cx18 *
+--- a/drivers/media/video/cx18/cx18-i2c.c
++++ b/drivers/media/video/cx18/cx18-i2c.c
+@@ -104,7 +104,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
  		break;
  	}
  
@@ -29,9 +29,9 @@
  	       -1 : 0;
  }
  
---- linux.orig/drivers/media/video/cx23885/cx23885-i2c.c
-+++ linux/drivers/media/video/cx23885/cx23885-i2c.c
-@@ -344,7 +344,8 @@ int cx23885_i2c_register(struct cx23885_
+--- a/drivers/media/video/cx23885/cx23885-i2c.c
++++ b/drivers/media/video/cx23885/cx23885-i2c.c
+@@ -345,7 +345,8 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
  	} else
  		printk(KERN_WARNING "%s: i2c bus %d register FAILED\n",
  			dev->name, bus->nr);
@@ -41,7 +41,7 @@
  	/* Instantiate the IR receiver device, if present */
  	if (0 == bus->i2c_rc) {
  		struct i2c_board_info info;
-@@ -359,7 +360,7 @@ int cx23885_i2c_register(struct cx23885_
+@@ -360,7 +361,7 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
  		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list,
  				      i2c_probe_func_quick_read);
  	}
@@ -50,9 +50,9 @@
  	return bus->i2c_rc;
  }
  
---- linux.orig/drivers/media/video/em28xx/em28xx-cards.c
-+++ linux/drivers/media/video/em28xx/em28xx-cards.c
-@@ -2454,7 +2454,7 @@ void em28xx_register_i2c_ir(struct em28x
+--- a/drivers/media/video/em28xx/em28xx-input.c
++++ b/drivers/media/video/em28xx/em28xx-input.c
+@@ -429,7 +429,7 @@ static void em28xx_register_i2c_ir(struct em28xx *dev)
  
  	if (dev->init_data.name)
  		info.platform_data = &dev->init_data;
@@ -60,10 +60,10 @@
 +	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
  }
  
- void em28xx_card_setup(struct em28xx *dev)
---- linux.orig/drivers/media/video/ivtv/ivtv-i2c.c
-+++ linux/drivers/media/video/ivtv/ivtv-i2c.c
-@@ -186,7 +186,7 @@ static int ivtv_i2c_new_ir(struct ivtv *
+ /**********************************************************
+--- a/drivers/media/video/ivtv/ivtv-i2c.c
++++ b/drivers/media/video/ivtv/ivtv-i2c.c
+@@ -186,7 +186,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
  			return -1;
  		memset(&info, 0, sizeof(struct i2c_board_info));
  		strlcpy(info.type, type, I2C_NAME_SIZE);
@@ -72,7 +72,7 @@
  							   == NULL ? -1 : 0;
  	}
  
-@@ -230,7 +230,7 @@ static int ivtv_i2c_new_ir(struct ivtv *
+@@ -230,7 +230,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
  	info.platform_data = init_data;
  	strlcpy(info.type, type, I2C_NAME_SIZE);
  
@@ -81,7 +81,7 @@
  	       -1 : 0;
  }
  
-@@ -257,7 +257,7 @@ struct i2c_client *ivtv_i2c_new_ir_legac
+@@ -257,7 +257,7 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
  
  	memset(&info, 0, sizeof(struct i2c_board_info));
  	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
@@ -90,9 +90,9 @@
  }
  
  int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
---- linux.orig/drivers/media/video/v4l2-common.c
-+++ linux/drivers/media/video/v4l2-common.c
-@@ -316,8 +316,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_
+--- a/drivers/media/video/v4l2-common.c
++++ b/drivers/media/video/v4l2-common.c
+@@ -319,8 +319,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
  
  	/* Create the i2c client */
  	if (info->addr == 0 && probe_addrs)
-- 
1.7.0.4

