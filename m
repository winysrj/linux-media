Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49837 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757800Ab2AMLQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 06:16:40 -0500
References: <201201131142.33779.hverkuil@xs4all.nl>
In-Reply-To: <201201131142.33779.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Two devices, same USB ID: one needs HID, the other doesn't. How to solve this?
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 13 Jan 2012 06:16:51 -0500
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-input@vger.kernel.org
CC: linux-media <linux-media@vger.kernel.org>
Message-ID: <0ce7bf77-b04f-49e2-8cbe-9c01d17a5cf1@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>Hi!
>
>I've made a video4linux driver for the USB Keene FM Transmitter. See:
>
>http://www.amazon.co.uk/Keene-Electronics-USB-FM-Transmitter/dp/B003GCHPDY/ref=sr_1_1?ie=UTF8&qid=1326450476&sr=8-1
>
>The driver code is here:
>
>http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/keene
>
>Unfortunately this device has exactly the same USB ID as the Logitech
>AudioHub
>USB speaker (http://www.logitech.com/en-us/439/3503).
>
>The AudioHub has HID support for volume keys, but the FM transmitter
>needs
>a custom V4L2 driver instead.
>
>I've attached the full lsusb -v output of both devices, but this is the
>diff of
>the two:
>
>$ diff keene.txt audiohub.txt -u
>--- keene.txt   2012-01-13 11:10:48.265399953 +0100
>+++ audiohub.txt        2012-01-13 11:09:45.185398935 +0100
>@@ -1,5 +1,5 @@
> 
>-Bus 007 Device 009: ID 046d:0a0e Logitech, Inc. 
>+Bus 003 Device 004: ID 046d:0a0e Logitech, Inc. 
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>@@ -12,7 +12,7 @@
>   idProduct          0x0a0e 
>   bcdDevice            1.00
>   iManufacturer           1 HOLTEK 
>-  iProduct                2 B-LINK USB Audio  
>+  iProduct                2 AudioHub Speaker
>   iSerial                 0 
>   bNumConfigurations      1
>   Configuration Descriptor:
>@@ -22,9 +22,8 @@
>     bNumInterfaces          3
>     bConfigurationValue     1
>     iConfiguration          0 
>-    bmAttributes         0xa0
>+    bmAttributes         0x80
>       (Bus Powered)
>-      Remote Wakeup
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>@@ -152,7 +151,7 @@
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>-          wDescriptorLength      22
>+          wDescriptorLength      31
>          Report Descriptors: 
>            ** UNAVAILABLE **
>       Endpoint Descriptor:
>
>As you can see, the differences are very small.
>
>In my git tree I worked around it by adding the USB ID to the ignore
>list
>if the Keene driver is enabled, and ensuring that the Keene driver is
>disabled by default.
>
>But is there a better method to do this? At least the iProduct strings
>are
>different, is that something that can be tested in hid-core.c?
>
>Regards,
>
>	Hans

Maybe it doesn't matter, but what do the Report Descriptors look like?

http://www.slashdev.ca/2010/05/08/get-usb-report-descriptor-with-linux/

Regards,
Andy
