Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62941 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaDMVr6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Apr 2014 17:47:58 -0400
Received: from [192.168.1.56] ([84.26.254.29]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MWSwU-1WSQrv09t4-00XchH for
 <linux-media@vger.kernel.org>; Sun, 13 Apr 2014 23:47:57 +0200
Message-ID: <534B060C.8060109@gmx.net>
Date: Sun, 13 Apr 2014 23:47:56 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [Developers] I know how to make this Digivox work, could v4l-dvb
 be patched for it?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device: http://linuxtv.org/wiki/index.php/MSI_DigiVox_Trio

In the "making it work" section I already described it: you just need to 
threat this device exactly as if it's a Terratec H5.

Something as simple as adding:

  { USB_DEVICE(0xeb1a, 0x2885),    /* MSI Digivox Trio */
             .driver_info = EM2884_BOARD_TERRATEC_H5 },

to linux/drivers/media/usb/em28xx/em28xx-cards.c is sufficient. This is 
probably a slightly ugly way to do it, but I've been using this solution 
for half a year and haven't found any problems with it.

What needs to be done in order to get a change like this (or maybe one 
that looks slighty more neat) into the official v4l-dvb?

Best regards,

P. van Gaans
