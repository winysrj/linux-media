Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50423 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaKHRPQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 12:15:16 -0500
Received: from [192.168.178.20] ([79.215.146.165]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0LtlG5-1YCpBn1atB-011A4n for
 <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 18:15:14 +0100
Message-ID: <545E4FA1.9010509@gmx.de>
Date: Sat, 08 Nov 2014 18:15:13 +0100
From: Jan Tisje <jan.tisje@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Technisat DVB-S2 USB: reduced buffer sizes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I reduced the buffer size in order to make this driver work on my NAS
station. It's an arm system and thus only has limited resources.

I compiled and ran with kernel 3.16.3 for some weeks and now compiled
and booted kernel 3.17.2 today.
Without this patch the device doesn't work at all, in both kernel versions.

This is what Antti Palosaar crope@iki.fi wrote:
> If I didn't remember wrong, that means allocated buffers are 8 * 32 * 2048 = 524288 bytes. 
> It sounds rather big for my taste. Probably even wrong. IIRC USB2.0 frames are 1024 and there could be 1-3 frames. 
> You could use lsusb with all verbosity levels to see if it is 1024/2048/3072. And set value according to that info.
> So I would recommend .count = 6, .framesperurb = 8, .framesize = 1024 


I only changed one value because this was sufficient to make it work.

I believe these sizes correspond to the output of lsusb -v
But to be honest: I don't have any idea of what this all is about. USB
wasn't invented yet when I studied computer science. ;)
maybe someone knows better.

    Interface Descriptor:
      bAlternateSetting       0
      Endpoint Descriptor:
        bEndpointAddress     0x82  EP 2 IN
        wMaxPacketSize     0x0200  1x 512 bytes
      Endpoint Descriptor:
        bEndpointAddress     0x81  EP 1 IN
        wMaxPacketSize     0x0200  1x 512 bytes
      Endpoint Descriptor:
        bEndpointAddress     0x01  EP 1 OUT
        wMaxPacketSize     0x0200  1x 512 bytes
    Interface Descriptor:
      bAlternateSetting       1
      Endpoint Descriptor:
        bEndpointAddress     0x82  EP 2 IN
        wMaxPacketSize     0x0c00  2x 1024 bytes
          Transfer Type            Isochronous
      Endpoint Descriptor:
        bEndpointAddress     0x81  EP 1 IN
        wMaxPacketSize     0x0200  1x 512 bytes
      Endpoint Descriptor:
        bEndpointAddress     0x01  EP 1 OUT
        wMaxPacketSize     0x0200  1x 512 bytes


This is the first kernel patch I submitted. I hope everything is fine.

Jan


diff -uNr linux-3.17.2.orig/drivers/media/usb/dvb-usb/technisat-usb2.c
linux-3.17.2/drivers/media/usb/dvb-usb/technisat-usb2.c
--- linux-3.17.2.orig/drivers/media/usb/dvb-usb/technisat-usb2.c
2014-10-30 17:43:25.000000000 +0100
+++ linux-3.17.2/drivers/media/usb/dvb-usb/technisat-usb2.c
2014-11-08 17:31:18.716668708 +0100
@@ -708,7 +708,7 @@
                                .endpoint = 0x2,
                                .u = {
                                        .isoc = {
-                                               .framesperurb = 32,
+                                               .framesperurb = 8,
                                                .framesize = 2048,
                                                .interval = 1,
