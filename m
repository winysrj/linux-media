Return-path: <linux-media-owner@vger.kernel.org>
Received: from ks4004239.ip-142-4-213.net ([142.4.213.193]:36184 "EHLO
	mon.libertas-tech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaAIBed (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 20:34:33 -0500
Received: from [198.2.75.28] (helo=vegas.nowhere.ca)
	by mon.libertas-tech.com with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <keith.lawson@libertas-tech.com>)
	id 1W141U-000211-6r
	for linux-media@vger.kernel.org; Wed, 08 Jan 2014 20:03:00 -0500
Received: from www-data by vegas.nowhere.ca with local (Exim 4.80)
	(envelope-from <keith.lawson@libertas-tech.com>)
	id 1W141L-00066j-W7
	for linux-media@vger.kernel.org; Wed, 08 Jan 2014 20:02:52 -0500
To: linux-media@vger.kernel.org
Subject: Support for Empia 2980 video/audio capture chip set
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Jan 2014 20:02:51 -0500
From: Keith Lawson <keith.lawson@libertas-tech.com>
Reply-To: keith.lawson@libertas-tech.com
Message-ID: <1ed89f5b0a32bf26e17cee890a26b012@www.nowhere.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I sent the following message to the linux-usb mailing list and they 
suggested I try here.

I'm trying to get a "Dazzle Video Capture USB V1.0" video capture card 
working on a Linux device but it doesn't look like the chip set is 
supported yet. I believe this card is the next version of the Pinnacle 
VC100 capture card that worked with the em28xx kernel module. The 
hardware vendor that sold the card says that this device has an Empia 
2980 chip set in it so I'm inquiring about support for that chip set. 
I'm just wondering about the best approach for getting the new chip 
supported in the kernel. Is this something the em28xx maintainers would 
naturally address in time or can I assist in getting this into the 
kernel?

Here's dmesg from the Debian box I'm working on:

[ 3198.920619] usb 3-1: new high-speed USB device number 5 usingxhci_hcd
[ 3198.939394] usb 3-1: New USB device found, 
idVendor=1b80,idProduct=e60a
[ 3198.939399] usb 3-1: New USB device strings: Mfr=0, 
Product=1,SerialNumber=2
[ 3198.939403] usb 3-1: Product: Dazzle Video Capture USB Audio Device
[ 3198.939405] usb 3-1: SerialNumber: 0

l440:~$ uname -a
Linux l440 3.10-3-amd64 #1 SMP Debian 3.10.11-1 (2013-09-10) x86_64
GNU/Linux

If this isn't the appropriate list to ask this question please point me 
in the right direction.

Thanks,
Keith
