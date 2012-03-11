Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:36283 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753551Ab2CKSGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 14:06:20 -0400
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1S6mn1-0001hz-6f
	for linux-media@vger.kernel.org; Sun, 11 Mar 2012 10:42:39 -0700
Message-ID: <4F5CE40C.6040706@seiner.com>
Date: Sun, 11 Mar 2012 10:42:36 -0700
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: saa7115: black image
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an embedded platform with a Hauppage USB Live video capture 
dongle.  I recently upgraded to 3.0.12 and now I get no image at all - a 
nice pure black is all I get.

I am sure that the dongle is getting a signal.  This same hardware used 
to work with an older 2.6 kernel.

Partial lsmod:

root@anchor:/etc# lsmod
Module                  Size  Used by    Not tainted
saa7115                11296  0
usbvision              48704  0
v4l2_common             4336  2 saa7115,usbvision
videodev               62768  3 saa7115,usbvision,v4l2_common
i2c_core               12240  5 
saa7115,usbvision,v4l2_common,videodev,i2c_dev

[   33.640000] usbcore: registered new interface driver usb-storage
[   33.644000] USB Mass Storage support registered.
[   33.708000] Linux video capture interface: v2.00
[   34.084000] usbvision_probe: Hauppauge WinTV USB Live Pro (NTSC M/N) 
found
[   34.092000] USBVision[0]: registered USBVision Video device video0 [v4l2]
[   34.100000] usbcore: registered new interface driver usbvision
[   34.104000] USBVision USB Video Device Driver for Linux : 0.9.10

and this shows up every time the device is opened:

[  219.772000] saa7115 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a 
(usbvision-3-1)

I can't help but think I am missing a module, or firmware, or 
something.... But with no messages to go on it's a bit of a mystery.

And yes, I've tried different inputs on the dongle; 0 is the composite 
in and 1 is the s-video.  I'm using input 0.

-- 
Honoring our vets.

http://www.bataanmarch.com/

