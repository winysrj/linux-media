Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:48629 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab1IHIwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:52:53 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca [147.11.189.40])
	by mail.windriver.com (8.14.3/8.14.3) with ESMTP id p888qqDq021566
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 8 Sep 2011 01:52:52 -0700 (PDT)
Message-ID: <4E6883AC.9010900@windriver.com>
Date: Thu, 8 Sep 2011 16:58:20 +0800
From: "corp\\KChen" <keqiang.chen@windriver.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: SI470X Radio /  ADS Instant FM Music in linux
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Manager,

I am debugging a platform with SI470x FM radio module(Usb interface).
The linux kernel version is 2.6.35.7.
I have configured the linux kernel and it can recognize this module.
But there are some abnormal log and I cant scan the FM channel normally.

The log list as below, Would you like help me?

//--------------Log start 
----------------------\|/-------------------------------------
usb 1-1.3: new full speed USB device using ehci-omap and address 4
usb 1-1.3: New USB device found, idVendor=06e1, idProduct=a155
usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.3: Product: ADS InstantFM Music
usb 1-1.3: Manufacturer: ADS TECH

4:1:1: endpoint lacks sample rate attribute bit, cannot 
set.                       // This is the first abnormal point.

radio-si470x 1-1.3:1.2: DeviceID=0x1242 ChipID=0x0a0f
radio-si470x 1-1.3:1.2: software version 0, hardware version 7
radio-si470x 1-1.3:1.2: This driver is known to work with software 
version 7,       //
radio-si470x 1-1.3:1.2: but the device has software version 
0.                              //This is the second abnormal point.
radio-si470x 1-1.3:1.2: If you have some trouble using this driver,
radio-si470x 1-1.3:1.2: please report to V4L ML at 
linux-media@vger.kernel.org

//-----------------Log end 
---------------------/|\----------------------------------------
Note:
The device is bought from US but it is marked "Made in China".
It is bought in one month.

Thanks

KeQiang.Chen.
