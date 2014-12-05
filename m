Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.pb.cz ([109.72.0.114]:46464 "EHLO smtp4.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaLEJzC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 04:55:02 -0500
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp4.pb.cz (Postfix) with ESMTPS id 4BFB782BE2
	for <linux-media@vger.kernel.org>; Fri,  5 Dec 2014 10:54:54 +0100 (CET)
Message-ID: <548180EE.2040908@mizera.cz>
Date: Fri, 05 Dec 2014 10:54:54 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: it913x: probe of 8-001c failed with error -22
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bump: any Idea please ?

Hello.

U12.04 with newly installed 3.8 kernel:

3.8.0-44-generic #66~precise1-Ubuntu SMP Tue Jul 15 04:01:04 UTC 2014 
x86_64 x86_64 x86_64 GNU/Linux

USB dvb-t tuner:

Bus 001 Device 005: ID 048d:9135 Integrated Technology Express, Inc. 
Zolid Mini DVB-T Stick

Newest V4L drivers installed. But there is an error in log by inserting 
of the USB tuner:

-------------------
Nov 25 16:24:38 zly-hugo kernel: [  315.927923] usb 1-1.3: new 
high-speed USB device number 5 using ehci-pci
Nov 25 16:24:38 zly-hugo kernel: [  316.021755] usb 1-1.3: New USB 
device found, idVendor=048d, idProduct=9135
Nov 25 16:24:38 zly-hugo kernel: [  316.021760] usb 1-1.3: New USB 
device strings: Mfr=0, Product=0, SerialNumber=0
Nov 25 16:24:38 zly-hugo kernel: [  316.023071] usb 1-1.3: 
dvb_usb_af9035: prechip_version=83 chip_version=02 chip_type=9135
Nov 25 16:24:38 zly-hugo kernel: [  316.023443] usb 1-1.3: dvb_usb_v2: 
found a 'ITE 9135 Generic' in cold state
Nov 25 16:24:38 zly-hugo kernel: [  316.023519] usb 1-1.3: dvb_usb_v2: 
downloading firmware from file 'dvb-usb-it9135-02.fw'
Nov 25 16:24:38 zly-hugo mtp-probe: checking bus 1, device 5: 
"/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3"
Nov 25 16:24:38 zly-hugo kernel: [  316.119961] usb 1-1.3: 
dvb_usb_af9035: firmware version=3.40.1.0
Nov 25 16:24:38 zly-hugo kernel: [  316.119974] usb 1-1.3: dvb_usb_v2: 
found a 'ITE 9135 Generic' in warm state
Nov 25 16:24:38 zly-hugo kernel: [  316.120972] usb 1-1.3: dvb_usb_v2: 
will pass the complete MPEG2 transport stream to the software demuxer
Nov 25 16:24:38 zly-hugo kernel: [  316.120996] DVB: registering new 
adapter (ITE 9135 Generic)
Nov 25 16:24:38 zly-hugo mtp-probe: bus: 1, device: 5 was not an MTP device
Nov 25 16:24:38 zly-hugo kernel: [  316.123808] af9033 8-0038: firmware 
version: LINK 3.40.1.0 - OFDM 3.40.1.0
Nov 25 16:24:38 zly-hugo kernel: [  316.123812] af9033 8-0038: Afatech 
AF9033 successfully attached
Nov 25 16:24:38 zly-hugo kernel: [  316.123822] usb 1-1.3: DVB: 
registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
Nov 25 16:24:38 zly-hugo kernel: [  316.125115] it913x: probe of 8-001c 
failed with error -22
---------------------

What is wrong ?

THX  --kapetr



