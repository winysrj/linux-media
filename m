Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3CUSp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 14:45:28 -0400
Date: Thu, 21 Mar 2013 15:45:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Janne Grunau <j@jannau.net>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] media: fix hdpvr build warning
Message-ID: <20130321154509.46ad14e3@redhat.com>
In-Reply-To: <513F769D.6040306@infradead.org>
References: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg>
	<513F769D.6040306@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 Mar 2013 11:40:29 -0700
Randy Dunlap <rdunlap@infradead.org> escreveu:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build warning in hdpvr:
> 
> drivers/media/usb/hdpvr/hdpvr-video.c: warning: "CONFIG_I2C_MODULE" is not defined [-Wundef]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Janne Grunau <j@jannau.net>

>From time to time, people used to write those checks wrong. So,
we're now using a macro to avoid those problems (IS_ENABLED). The better
is to also use it here.

-

[PATCH] Use the proper check for I2C support

As reported by Geert Uytterhoeven <geert@linux-m68k.org>:

	drivers/media/usb/hdpvr/hdpvr-video.c: warning: "CONFIG_I2C_MODULE" is not defined [-Wundef]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index da6b779..554d2eb 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -1238,7 +1238,7 @@ static void hdpvr_device_release(struct video_device *vdev)
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	/* deregister I2C adapter */
-#if defined(CONFIG_I2C) || (CONFIG_I2C_MODULE)
+#if IS_ENABLED(CONFIG_I2C)
 	mutex_lock(&dev->i2c_mutex);
 	i2c_del_adapter(&dev->i2c_adapter);
 	mutex_unlock(&dev->i2c_mutex);

Cheers,
Mauro
