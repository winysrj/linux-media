Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm3.telefonica.net ([213.4.138.3]:61314 "EHLO
	IMPaqm3.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0AHXVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 18:21:07 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: Problem with gspca and zc3xx
Date: Sat, 9 Jan 2010 00:15:31 +0100
MIME-Version: 1.0
Message-Id: <201001090015.31357.jareguero@telefonica.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When capturing with mplayer I have this erros and the bottom of the image is 
black.

[mjpeg @ 0xd2f300]error y=29 x=0                           
[mjpeg @ 0xd2f300]mjpeg_decode_dc: bad vlc: 0:0 (0x2c565b0)
[mjpeg @ 0xd2f300]error dc                                 
[mjpeg @ 0xd2f300]error y=29 x=0                           
[mjpeg @ 0xd2f300]mjpeg_decode_dc: bad vlc: 0:0 (0x2c565b0)
[mjpeg @ 0xd2f300]error dc                                 
[mjpeg @ 0xd2f300]error y=29 x=0                           
[mjpeg @ 0xd2f300]mjpeg_decode_dc: bad vlc: 0:0 (0x2c565b0)
[mjpeg @ 0xd2f300]error dc                                 
[mjpeg @ 0xd2f300]error y=29 x=0                           
[mjpeg @ 0xd2f300]mjpeg_decode_dc: bad vlc: 0:0 (0x2c565b0)
[mjpeg @ 0xd2f300]error dc                                 
[mjpeg @ 0xd2f300]error y=29 x=0                           
[mjpeg @ 0xd2f300]mjpeg_decode_dc: bad vlc: 0:0 (0x2c565b0)
[mjpeg @ 0xd2f300]error dc                                 
[mjpeg @ 0xd2f300]error y=29 x=0                           
[mjpeg @ 0xd2f300]mjpeg_decode_dc: bad vlc: 0:0 (0x2c565b0)
[mjpeg @ 0xd2f300]error dc                                 
.....................

dmesg:

gspca: main v2.8.0 registered                
gspca: probing 046d:08dd
zc3xx: Sensor MC501CB
gspca: video0 created
gspca: probing 046d:08dd
gspca: intf != 0
gspca: probing 046d:08dd
gspca: intf != 0
usbcore: registered new interface driver zc3xx
zc3xx: registered

Jose Alberto
