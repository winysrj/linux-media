Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:20720 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbZE0Swl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 14:52:41 -0400
Message-ID: <4A1D8C95.60604@oracle.com>
Date: Wed, 27 May 2009 11:55:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Matt Doran <matt.doran@papercut.com>, linux-media@vger.kernel.org
Subject: [PATCH v2] Re: videodev: Unknown symbol i2c_unregister_device (in
 kernels older than 2.6.26)
References: <4A19D3D9.9010800@papercut.com> <20090527154107.6b79a160@pedra.chehab.org>
In-Reply-To: <20090527154107.6b79a160@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Mon, 25 May 2009 09:10:17 +1000
> Matt Doran <matt.doran@papercut.com> escreveu:
> 
>> Hi there,
>>
>> I tried using the latest v4l code on an Mythtv box running 2.6.20, but 
>> the v4l videodev module fails to load with the following warnings:
>>
>>     videodev: Unknown symbol i2c_unregister_device
>>     v4l2_common: Unknown symbol v4l2_device_register_subdev
>>
>>
>> It seems the "i2c_unregister_device" function was added in 2.6.26.   
>> References to this function in v4l2-common.c are enclosed in an ifdef like:
>>
>>     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
>>
>>
>> However in "v4l2_device_unregister()" in v4l2-device.c, there is a 
>> reference to "i2c_unregister_device" without any ifdefs.   I am running 
>> a pretty old kernel, but I'd guess anyone running 2.6.25 or earlier will 
>> have this problem.   It seems this code was added by Mauro 3 weeks ago 
>> in this rev:
>>
>>     http://linuxtv.org/hg/v4l-dvb/rev/87afa7a4ccdf
> 
> I've just applied a patch at the tree that should fix this issue. It adds
> several tests and the code, but, hopefully, it should be possible even to use
> the IR's with kernels starting from 2.6.16.


Hi Mauro,
If you are referring to my recent patch, it needs a modification to be like
other places in drivers/media/video.  Patch below applies on top of the
previous one.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix v4l2-device usage of i2c_unregister_device() and handle the case of
CONFIG_I2C=m & CONFIG_MEDIA_VIDEO=y.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/v4l2-device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090527.orig/drivers/media/video/v4l2-device.c
+++ linux-next-20090527/drivers/media/video/v4l2-device.c
@@ -85,7 +85,7 @@ void v4l2_device_unregister(struct v4l2_
 	/* Unregister subdevs */
 	list_for_each_entry_safe(sd, next, &v4l2_dev->subdevs, list) {
 		v4l2_device_unregister_subdev(sd);
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
 		if (sd->flags & V4L2_SUBDEV_FL_IS_I2C) {
 			struct i2c_client *client = v4l2_get_subdevdata(sd);
 


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
