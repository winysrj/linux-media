Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35246 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdBRBVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 20:21:11 -0500
Received: by mail-it0-f44.google.com with SMTP id 203so38288207ith.0
        for <linux-media@vger.kernel.org>; Fri, 17 Feb 2017 17:21:10 -0800 (PST)
Received: from [192.168.2.215] (bras-vprn-mtrlpq0806w-lp140-01-70-26-206-103.dsl.bell.ca. [70.26.206.103])
        by smtp.gmail.com with ESMTPSA id p19sm3842612iod.48.2017.02.17.17.21.09
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Feb 2017 17:21:09 -0800 (PST)
To: LMML <linux-media@vger.kernel.org>
From: Bill Atwood <williamatwood41@gmail.com>
Subject: cx231xx: disagrees about version of symbol videobuf_streamoff
Message-ID: <6cf94272-11f4-8c04-ceca-6096822d9859@gmail.com>
Date: Fri, 17 Feb 2017 20:21:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have downloaded the V4L git tree and complied it (apparently) 
successfully.  I did "sudo make install", and (at the end) I see the 
message that several items of firmware are installed in /lib/firmware.  
v4l-cx231xx-avcore-01.fw is one of those:

-rw-r--r-- 1 root root  16382 Feb 17 17:46 v4l-cx231xx-avcore-01.fw

Kernel version: 4.4.0-62-generic

OS version: Ubuntu 16.04.2 LTS
(64-bit)

My device (Hauppauge WinTV-HVR-955Q) is recognized by the kernel:

Feb 17 17:54:58 willow kernel: [    1.858780] usb 2-2: New USB device 
found, idVendor=2040, idProduct=b123
Feb 17 17:54:58 willow kernel: [    1.858783] usb 2-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Feb 17 17:54:58 willow kernel: [    1.858785] usb 2-2: Product: 
Hauppauge Device
Feb 17 17:54:58 willow kernel: [    1.858787] usb 2-2: Manufacturer: 
Hauppauge
Feb 17 17:54:58 willow kernel: [    1.858789] usb 2-2: SerialNumber: 
4035560228

However, once the kernel starts processing the software that must be 
present for the 955Q, it issues a series of messages, of which this is 
the first pair:

Feb 17 17:54:58 willow kernel: [   11.491848] cx231xx: disagrees about 
version of symbol videobuf_streamoff

Feb 17 17:54:58 willow kernel: [   11.491852] cx231xx: Unknown symbol 
videobuf_streamoff (err -22)

This pair then repeats going through a large number of unresolved symbols.

I built exactly the same software for a 32-bit machine a few days ago, 
and it installed the device successfully.  I was able to do a channel 
scan with the device, so it was clearly working.  (I did not try to 
watch LiveTV, because the display capabilities of the 32-bit processor 
were not sufficient.)

The sha-256 sum for the firmware in my 32-bit machine is

09a39c139d8e47ebfa2e7f64472e7165dff66359277ca02bcfdcd79f515764ef

and the date is Apr 25 2016.

The sha-256 sum for the firmware in my 64-bit machine is

c2a75fc710f51c778abe7c7e8b54ed5686b17811dd203d1de3070d3df70d70f6

and (as noted above) the date is Feb 17 17:46 (i.e., the time when the 
"sudo make install" command was run).

The sha-256 sum for the file on 
https://www.linuxtv.org/downloads/firmware/ is identical to the sha-256 
sum for the firmware in my 64-bit machine.


The OSes for both the 32-bit machine and the 64-bit machine were built 
as clean installs from downloaded Ubuntu 16.04 LTS .iso files, and 
allowed to update to 16.04.2 (i.e., all updates applied) before I 
attempted to install MythTV and the linux-media drivers.


I did find an old reference to this "unresolved symbols" issue on the 
web, but it dates from 2008, and does not seem pertinent to the problem 
that I am having.


Does anyone have any suggestions for how to fix this?


   Bill
