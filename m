Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:64880 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752540AbdBUOqw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 09:46:52 -0500
Received: from be1.lrz ([178.11.204.81]) by mrelayeu.kundenserver.de (mreue104
 [212.227.15.183]) with ESMTPSA (Nemesis) id 0MTxeT-1cpEFs0wQj-00Qn0e for
 <linux-media@vger.kernel.org>; Tue, 21 Feb 2017 15:46:49 +0100
Received: from [192.168.7.210] (helo=be10)
        by be1.lrz with esmtp (Exim 4.84_2)
        (envelope-from <7eggert@online.de>)
        id 1cgBiJ-0000PW-Lj
        for linux-media@vger.kernel.org; Tue, 21 Feb 2017 14:46:48 +0000
Date: Tue, 21 Feb 2017 15:46:39 +0100 (CET)
From: Bodo Eggert <7eggert@online.de>
To: linux-media@vger.kernel.org
Subject: Problem: saa7113 (saa7115) vs. "conrad usb grabber usb-472"
Message-ID: <alpine.DEB.2.11.1702211334170.11273@be10>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

System: Debian Jessie x64. (Using qv4l2).

I've got a USB video grabber called "conrad usb grabber usb-472", 
essentially it's a no-name-branding. It's recognized as saa7113 by the 
saa7115 driver.

The device has one video input (chinch, yellow) and a stereo input (red 
and white). The driver does recognize three video inputs 
(green/yellow/red), neither of them works: No frame recognized. I verified 
the camera to supply a correct signal.

Trying to use MMIO, qv4l2 will hang and needs to be killed.
Trying to use read(), I get a black screen.

(Sorry if this isn't the correct list.

I'm OK with just throwing the thing away, but if fixing it is an option, 
I'll help.)

uname -a
Linux be10 3.16.0-4-amd64 #1 SMP Debian 3.16.39-1 (2016-12-30) x86_64 
GNU/Linux


lsusb:
Bus 003 Device 002: ID 0573:0400 Zoran Co. Personal Media Division (Nogatech) D-Link V100

dmesg:
[ 7518.194350] usb 3-2: new full-speed USB device number 2 using ohci-pci
[ 7518.371408] usb 3-2: New USB device found, idVendor=0573, idProduct=0400
[ 7518.371420] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 7519.217042] usbvision_probe: D-Link V100 found
[ 7519.217461] USBVision[0]: registered USBVision Video device video1 [v4l2]
[ 7519.217505] usbcore: registered new interface driver usbvision
[ 7519.217507] USBVision USB Video Device Driver for Linux : 0.9.11
[ 7519.902857] saa7115 5-0025: saa7113 found @ 0x4a (usbvision-3-2)
