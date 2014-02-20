Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49205 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaBTJbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 04:31:23 -0500
Received: by mail-ea0-f171.google.com with SMTP id f15so775006eak.30
        for <linux-media@vger.kernel.org>; Thu, 20 Feb 2014 01:31:21 -0800 (PST)
Received: from [192.168.1.100] (93-45-234-219.ip104.fastwebnet.it. [93.45.234.219])
        by mx.google.com with ESMTPSA id j42sm11416265eep.21.2014.02.20.01.31.18
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 20 Feb 2014 01:31:20 -0800 (PST)
Message-ID: <5305CB65.5000706@gmail.com>
Date: Thu, 20 Feb 2014 10:31:17 +0100
From: Caterpillar <caterpillar86@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: tvtime and Pinnacle PCTV 72e
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. I am writing to you because I am helping a Fedora user that has
problems using tvtime with its Pinnacle Systems, Inc. PCTV 72e [DiBcom
DiB7000PC]
Before he asked for my help, the user said he managed to work the card
with its webcam, but not with the DBV-T Pinnacle card (USB).
He says also to have a PCI DVB-S card installed in the system.

by default settings, if he executes tvtime from bash, he will get

|||=========================================||
$ tvtime
Running tvtime 1.0.2.
Reading configuration from /etc/tvtime/tvtime.xml
Reading configuration from /home/italman71/.tvtime/tvtime.xml
videoinput: Cannot open capture device /dev/device0: File o directory non esistente
mixer: find error: Successo
mixer: Can't open mixer default, mixer volume and mute unavailable.
mixer: Can't open device default/Line, mixer volume and mute unavailable.
|||=========================================||

but as you can see from ls /dev/ ( http://pastebin.com/vGYaD1mY ) there
is not a |/dev/device0 but other interesting devices like video0,
video1, v4l, dvb

He did some unsuccessfull tries, for example
|

|||=========================================||
$ tvtime --device /dev/video1
Running tvtime 1.0.2.
Reading configuration from /etc/tvtime/tvtime.xml
Reading configuration from /home/italman71/.tvtime/tvtime.xml
mixer: find error: Successo
mixer: Can't open mixer default, mixer volume and mute unavailable.
mixer: Can't open device default/Line, mixer volume and mute unavailable.
Thank you for using tvtime.
||||=========================================||


it gave to the user a black screen, so I told him to try video0, but it seemed to be the output of computer webcam
|
||=========================================||
||tvtime --device /dev/video0
Running tvtime 1.0.2.
Reading configuration from /etc/tvtime/tvtime.xml
Reading configuration from /home/italman71/.tvtime/tvtime.xml
videoinput: Driver won't tell us its norm: ioctl non appropriata per il device
videoinput: Can't get tuner info: ioctl non appropriata per il device

    Your capture card driver: uvcvideo [UVC Camera (046d:081d)/usb-0000:00:12.2-1/200192]
    does not support full size studio-quality images required by tvtime.
    This is true for many low-quality webcams.  Please select a
    different video device for tvtime to use with the command line
    option --device.

mixer: find error: Successo
mixer: Can't open mixer default, mixer volume and mute unavailable.
mixer: Can't open device default/Line, mixer volume and mute unavailable.
Thank you for using tvtime
=========================================


At this point I don't know what I can do to manage to work the device with tvtime. Do you have any suggestions? Downhere you can find a lot of useful infos collected from the system

||||lspci http://pastebin.com/Q2bdZiSq| 
|ls /dev/ http://pastebin.com/vGYaD1mY
lsusb http://pastebin.com/gFSKZcME
lsmod http://pastebin.com/QpYUai90tree /dev/dvb http://pastebin.com/Sf0vewWc
dmesg|grep DiBhttp://pastebin.com/a7M0HwRA
dmesg|grep Pinnacle http://pastebin.com/zzDcKfN4
dmesg|tail http://pastebin.com/gsimDTAd


Thank you for your time
