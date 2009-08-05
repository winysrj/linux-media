Return-path: <linux-media-owner@vger.kernel.org>
Received: from april.london.02.net ([87.194.255.143]:55042 "EHLO
	april.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZHEWoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 18:44:05 -0400
Received: from mail.jennings.homelinux.net (78.86.103.101) by april.london.02.net (8.5.016.1)
        id 4A23ECF80408F332 for linux-media@vger.kernel.org; Wed, 5 Aug 2009 23:37:53 +0100
Received: from localhost (mail [127.0.0.1])
	by mail.jennings.homelinux.net (Postfix) with ESMTP id 62C1C153C14F
	for <linux-media@vger.kernel.org>; Wed,  5 Aug 2009 23:37:53 +0100 (BST)
Received: from mail.jennings.homelinux.net ([127.0.0.1])
	by localhost (mail.jennings.homelinux.net [127.0.0.1]) (amavisd-new, port 10025)
	with ESMTP id 46AUdtZg7ZOE for <linux-media@vger.kernel.org>;
	Wed,  5 Aug 2009 23:37:38 +0100 (BST)
Received: from derek (Derek.localdomain [192.168.1.45])
	by mail.jennings.homelinux.net (Postfix) with ESMTP id AEE37153C14C
	for <linux-media@vger.kernel.org>; Wed,  5 Aug 2009 23:37:38 +0100 (BST)
From: Derek Jennings <derek@jennings.homelinux.net>
To: linux-media@vger.kernel.org
Subject: Hauppauge Nova-T 500 regression in dib0700
Date: Wed, 5 Aug 2009 23:37:37 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052337.37908.derek@jennings.homelinux.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
I have been chasing a problem with my Hauppauge Nova-T 500 Dual DVB-T card and 
think it is the same problem reported here 
http://osdir.com/ml/linux-media/2009-02/msg00948.html

The card worked perfectly with kernel-2.6.27 with firmware 
dvb-usb-dib0700-1.10.fw (I had to rename the firmware to
dvb-usb-dib0700-1.20.fw to get it to load)

With kernel-2.6.29 or 2.6.31 and firmware 1.10 the card would not Lock to the 
signal (using mythtv)
Using firmware 1.20 the card would lock to the signal, but after 1 or 2 
minutes the usb driver would fail

klogd: usb 2-1: new high speed USB device using ehci_hcd and address 2
klogd: usb 2-1: New USB device found, idVendor=2040, idProduct=9950
klogd: usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
klogd: usb 2-1: Product: WinTV Nova-DT
klogd: usb 2-1: Manufacturer: Hauppauge
klogd: usb 2-1: SerialNumber: 4028965283
klogd: usb 2-1: configuration #1 chosen from 1 choice
klogd: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
klogd: dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
klogd: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
klogd: DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
klogd: MT2060: successfully identified (IF1 = 1239)
klogd: dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
klogd: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
klogd: DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
klogd: MT2060: successfully identified (IF1 = 1222)
klogd: input: IR-receiver inside an USB DVB receiver 
as /devices/pci0000:00/0000:00:1e.0/0000:04:00.2/usb2/2-1/input/input3
klogd: dvb-usb: schedule remote query interval to 50 msecs.
klogd: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and 
connected.

After a few minutes of operation

klogd: ehci_hcd 0000:04:00.2: force halt; handhake f8018014 00004000 
00000000 -> -110

I downloaded and compiled the current v4l source and confirmed it had the same 
problem.

I then removed this commit mentioned in the earlier post from the current v4l 
source http://linuxtv.org/hg/v4l-dvb/rev/561b447ade77
and recompiled the module.

SUCCESS! with the commit removed the card works with kernel 2.6.29 and the 
1.10 firmware, but not with the 1.20 firmware which will not Lock to the 
signal.

I have no idea why that commit causes problems, but with it removed the 
operation of the card is just as good as it was under the 2.6.27 kernel.

Thanks

Derek
