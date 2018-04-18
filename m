Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50623 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbeDRESj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 00:18:39 -0400
Received: from mail-pl0-f72.google.com ([209.85.160.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1f8eYI-0000c0-4n
        for linux-media@vger.kernel.org; Wed, 18 Apr 2018 04:18:38 +0000
Received: by mail-pl0-f72.google.com with SMTP id h32-v6so320036pld.15
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 21:18:38 -0700 (PDT)
From: Kai Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain;
        charset=us-ascii;
        delsp=yes;
        format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: UVC1.5 webcam does not work on XPS 9370
Message-Id: <0FC16BF5-9F8C-4076-8AC6-3BA1060A0995@canonical.com>
Date: Wed, 18 Apr 2018 12:18:32 +0800
Cc: walter.garcia@upf.edu,
        Mario Limonciello <mario.limonciello@dell.com>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The Realtek 0bda:58f4 webcam which XPS 9370 uses doesn't work [1], not sure  
if it's because Linux doesn't support UVC1.5:

[    2.174138] Linux video capture interface: v2.00
[    2.182580] usbcore: registered new interface driver btusb
[    2.188376] uvcvideo: Found UVC 1.50 device Integrated_Webcam_HD  
(0bda:58f4)
[    2.189001] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported.  
Enabling workaround.
[    2.189426] uvcvideo: Failed to query (129) UVC probe control : -75  
(exp. 34).
[    2.189429] uvcvideo: Failed to initialize the device (-5).
[    2.190336] uvcvideo: Unknown video format  
00000032-0002-0010-8000-00aa00389b71
[    2.190341] uvcvideo: Found UVC 1.50 device Integrated_Webcam_HD  
(0bda:58f4)
[    2.190925] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported.  
Enabling workaround.
[    2.191183] uvcvideo: Failed to query (129) UVC probe control : -75  
(exp. 34).
[    2.191186] uvcvideo: Failed to initialize the device (-5).
[    2.191214] usbcore: registered new interface driver uvcvideo
[    2.191214] USB Video Class driver (1.1.1)

The Realtek webcam (0bda:58f4) has another firmware that supports UVC1.0,  
so the current solution is swapping the entire screen for the laptop.

Eventually UVC1.5 will be supported by Linux, so I am wondering if this is  
really because UVC1.5?

Kai-Heng

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1763748
