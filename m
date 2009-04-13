Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62679 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbZDMFbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 01:31:18 -0400
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KI000AAPXYIVF@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 14:30:18 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KI000DU2XYIJH@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Apr 2009 14:30:18 +0900 (KST)
Date: Mon, 13 Apr 2009 14:30:18 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: About the radio-si470x driver for I2C interface
In-reply-to: <49E29962.5010209@samsung.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: klimov.linux@gmail.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com
Message-id: <49E2CDEA.4080409@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
 <4e1455be0904011754l2c51cf2fi6336d07d591cbb71@mail.gmail.com>
 <49D4180B.4040805@samsung.com> <200904122256.12305.tobias.lorenz@gmx.net>
 <49E29962.5010209@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4/13/2009 10:46 AM, Joonyoung Shim wrote:
> On 4/13/2009 5:56 AM, Tobias Lorenz wrote:
>> Hi Joonyoung,
>>
>> Hi Alexey,
>>
>> I've split the driver into a couple of segments:
>>
>> - radio-si470x-common.c is for common functions
>>
>> - radio-si470x-usb.c are the usb support functions
>>
>> - radio-si470x-i2c.c is an untested prototyped file for your i2c support
>> functions
>>
>> - radio-si470x.h is a header file with everything required by the c-files
>>
>> I hope this is a basis we can start on with i2c support. What do you think?
>>
>> The URL is:
>>
>> http://linuxtv.org/hg/~tlorenz/v4l-dvb
> 
> It looks good, i will test with implementing the i2c functions.

I compiled getting your source from above URL, but i could not compile because
of supporting only usb compilation at Makefile.
I suggest to modify at Kconfig and Makefile like following patch.
What do you think?


diff -r 43d455adb02c linux/drivers/media/radio/Makefile
--- a/linux/drivers/media/radio/Makefile	Sun Apr 12 22:51:40 2009 +0200
+++ b/linux/drivers/media/radio/Makefile	Mon Apr 13 14:31:05 2009 +0900
@@ -17,7 +17,7 @@
 obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
 obj-$(CONFIG_RADIO_MAESTRO) += radio-maestro.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
-obj-$(CONFIG_USB_SI470X) += si470x/
+obj-$(CONFIG_RADIO_SI470X) += si470x/
 obj-$(CONFIG_USB_MR800) += radio-mr800.o
 obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
 
diff -r 43d455adb02c linux/drivers/media/radio/si470x/Kconfig
--- a/linux/drivers/media/radio/si470x/Kconfig	Sun Apr 12 22:51:40 2009 +0200
+++ b/linux/drivers/media/radio/si470x/Kconfig	Mon Apr 13 14:31:05 2009 +0900
@@ -1,6 +1,10 @@
+config RADIO_SI470X
+	tristate "Silicon Labs Si470x FM Radio Receiver support"
+	depends on VIDEO_V4L2
+
 config USB_SI470X
 	tristate "Silicon Labs Si470x FM Radio Receiver support with USB"
-	depends on USB && VIDEO_V4L2
+	depends on USB && RADIO_SI470X
 	---help---
 	  This is a driver for USB devices with the Silicon Labs SI470x
 	  chip. Currently these devices are known to work:
@@ -25,7 +29,7 @@
 
 config I2C_SI470X
 	tristate "Silicon Labs Si470x FM Radio Receiver support with I2C"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && RADIO_SI470X
 	---help---
 	  This is a driver for I2C devices with the Silicon Labs SI470x
 	  chip.
diff -r 43d455adb02c linux/drivers/media/radio/si470x/Makefile
--- a/linux/drivers/media/radio/si470x/Makefile	Sun Apr 12 22:51:40 2009 +0200
+++ b/linux/drivers/media/radio/si470x/Makefile	Mon Apr 13 14:31:05 2009 +0900
@@ -2,8 +2,8 @@
 # Makefile for radios with Silicon Labs Si470x FM Radio Receivers
 #
 
-radio-si470x-objs	:= radio-si470x-usb.o radio-si470x-common.o
-radio-si470x-i2c-objs	:= radio-si470x-i2c.o radio-si470x-common.o
+si470x-usb-objs	:= radio-si470x-usb.o radio-si470x-common.o
+si470x-i2c-objs	:= radio-si470x-i2c.o radio-si470x-common.o
 
-obj-$(CONFIG_USB_SI470X) += radio-si470x.o
-obj-$(CONFIG_I2C_SI470X) += radio-si470x-i2c.o
+obj-$(CONFIG_USB_SI470X) += si470x-usb.o
+obj-$(CONFIG_I2C_SI470X) += si470x-i2c.o


> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

