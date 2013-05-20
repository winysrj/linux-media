Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34209 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3ETQd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 12:33:28 -0400
Message-ID: <519A5027.5070505@infradead.org>
Date: Mon, 20 May 2013 09:32:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH -next] media: fix hdpvr kconfig/build errors
References: <20130520144940.a33c311c37824a57dd0c395e@canb.auug.org.au>
In-Reply-To: <20130520144940.a33c311c37824a57dd0c395e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix hdpvr build errors when CONFIG_I2C=m and VIDEO_V4L2=m and
VIDEO_HDPVR=y.

drivers/built-in.o: In function `hdpvr_disconnect':
hdpvr-core.c:(.text+0xef542): undefined reference to `v4l2_device_disconnect'
hdpvr-core.c:(.text+0xef57e): undefined reference to `i2c_del_adapter'
hdpvr-core.c:(.text+0xef58a): undefined reference to `video_unregister_device'
drivers/built-in.o: In function `hdpvr_delete':
(.text+0xef5b9): undefined reference to `video_device_release'
drivers/built-in.o: In function `hdpvr_probe':
hdpvr-core.c:(.text+0xef63a): undefined reference to `v4l2_device_register'
hdpvr-core.c:(.text+0xefd97): undefined reference to `i2c_del_adapter'
drivers/built-in.o: In function `hdpvr_s_ctrl':
hdpvr-video.c:(.text+0xf03c0): undefined reference to `v4l2_ctrl_activate'
drivers/built-in.o: In function `hdpvr_device_release':
hdpvr-video.c:(.text+0xf0470): undefined reference to `v4l2_device_unregister'
hdpvr-video.c:(.text+0xf0479): undefined reference to `v4l2_ctrl_handler_free'
hdpvr-video.c:(.text+0xf048f): undefined reference to `i2c_del_adapter'
drivers/built-in.o: In function `hdpvr_open':
hdpvr-video.c:(.text+0xf0570): undefined reference to `video_devdata'
hdpvr-video.c:(.text+0xf057b): undefined reference to `v4l2_fh_init'
hdpvr-video.c:(.text+0xf0583): undefined reference to `v4l2_fh_add'
drivers/built-in.o: In function `video_drvdata':
hdpvr-video.c:(.text+0xf08a0): undefined reference to `video_devdata'
drivers/built-in.o: In function `vidioc_s_dv_timings':
hdpvr-video.c:(.text+0xf0d34): undefined reference to `v4l_match_dv_timings'
drivers/built-in.o: In function `hdpvr_poll':
hdpvr-video.c:(.text+0xf1455): undefined reference to `v4l2_ctrl_poll'
drivers/built-in.o: In function `hdpvr_release':
hdpvr-video.c:(.text+0xf18f6): undefined reference to `v4l2_fh_release'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1be3): undefined reference to `v4l2_ctrl_handler_init_class'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1c19): undefined reference to `v4l2_ctrl_new_std'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1c42): undefined reference to `v4l2_ctrl_new_std'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1c6b): undefined reference to `v4l2_ctrl_new_std'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1cac): undefined reference to `v4l2_ctrl_new_std'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1cd5): undefined reference to `v4l2_ctrl_new_std'
drivers/built-in.o:(.text+0xf1cfe): more undefined references to `v4l2_ctrl_new_std' follow
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1d75): undefined reference to `v4l2_ctrl_new_std_menu'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1d9e): undefined reference to `v4l2_ctrl_new_std_menu'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1dc3): undefined reference to `v4l2_ctrl_new_std_menu'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1de5): undefined reference to `v4l2_ctrl_new_std_menu'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1e18): undefined reference to `v4l2_ctrl_new_std'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1e4b): undefined reference to `v4l2_ctrl_new_std'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1e90): undefined reference to `v4l2_ctrl_cluster'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1e98): undefined reference to `v4l2_ctrl_handler_setup'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1ec1): undefined reference to `video_device_alloc'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1f85): undefined reference to `__video_register_device'
drivers/built-in.o: In function `hdpvr_register_videodev':
(.text+0xf1fac): undefined reference to `v4l2_ctrl_handler_free'
drivers/built-in.o: In function `hdpvr_register_ir_tx_i2c':
(.text+0xf238f): undefined reference to `i2c_new_device'
drivers/built-in.o: In function `hdpvr_register_ir_rx_i2c':
(.text+0xf2434): undefined reference to `i2c_new_device'
drivers/built-in.o: In function `hdpvr_register_i2c_adapter':
(.text+0xf2514): undefined reference to `i2c_add_adapter'
drivers/built-in.o:(.rodata+0x1b368): undefined reference to `video_ioctl2'
drivers/built-in.o:(.rodata+0x1b690): undefined reference to `v4l2_ctrl_log_status'
drivers/built-in.o:(.rodata+0x1b6f8): undefined reference to `v4l2_ctrl_subscribe_event'
drivers/built-in.o:(.rodata+0x1b700): undefined reference to `v4l2_event_unsubscribe'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/media/usb/hdpvr/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20130520.orig/drivers/media/usb/hdpvr/Kconfig
+++ linux-next-20130520/drivers/media/usb/hdpvr/Kconfig
@@ -1,7 +1,7 @@
 
 config VIDEO_HDPVR
 	tristate "Hauppauge HD PVR support"
-	depends on VIDEO_DEV
+	depends on VIDEO_DEV && VIDEO_V4L2
 	---help---
 	  This is a video4linux driver for Hauppauge's HD PVR USB device.
 
