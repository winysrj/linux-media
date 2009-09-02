Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.95]:31500 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZIBTeL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 15:34:11 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2714.orange.fr (SMTP Server) with ESMTP id 6E3461C000A8
	for <linux-media@vger.kernel.org>; Wed,  2 Sep 2009 21:34:12 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2714.orange.fr (SMTP Server) with ESMTP id 60C7B1C00051
	for <linux-media@vger.kernel.org>; Wed,  2 Sep 2009 21:34:12 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-19-82.w92-135.abo.wanadoo.fr [92.135.50.82])
	by mwinf2714.orange.fr (SMTP Server) with ESMTP id 0E4571C000A8
	for <linux-media@vger.kernel.org>; Wed,  2 Sep 2009 21:34:11 +0200 (CEST)
Message-ID: <4A9EC8B3.10904@gmail.com>
Date: Wed, 02 Sep 2009 21:34:11 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: (EC168) PC Basic TNT USB Basic V5 ( France ) recognized but no channel
 tuning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I've just bough that and it seems that the EC168 driver can't work with
it ( yet )
The PCB identifies itself as a ForwardVideo "EzTV818_D.". Work with a
EC168 and a MXL5003S ( no doubt about it, but it is barely legible, and
since i've no camera, no PCB picture available ). ( and the EC168BDA.bin
firmware is provided on the CD )

A typical dmesg for it :


[19715.764919] usb 2-1.1: new high speed USB device using ehci_hcd and
address 8
[19715.873356] usb 2-1.1: configuration #1 chosen from 1 choice
[19715.878085] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference
design' in cold state, will try to load a firmware
[19715.878096] firmware: requesting dvb-usb-ec168.fw
[19715.929889] dvb-usb: downloading firmware from file 'dvb-usb-ec168.fw'
[19715.985884] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference
design' in warm state.
[19715.985958] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[19715.986487] DVB: registering new adapter (E3C EC168 DVB-T USB2.0
reference design)
[19715.986931] DVB: registering adapter 1 frontend 0 (E3C EC100 DVB-T)...
[19715.987045] MXL5005S: Attached at address 0xc6
[19715.987052] dvb-usb: E3C EC168 DVB-T USB2.0 reference design
successfully initialized and connected.
[19716.004730] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference
design' in warm state.
[19716.004799] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[19716.010131] DVB: registering new adapter (E3C EC168 DVB-T USB2.0
reference design)
[19716.010499] DVB: registering adapter 2 frontend 0 (E3C EC100 DVB-T)...
[19716.010612] MXL5005S: Attached at address 0xc6
[19716.010619] dvb-usb: E3C EC168 DVB-T USB2.0 reference design
successfully initialized and connected.
[19716.010729] usb 2-1.1: New USB device found, idVendor=18b4,
idProduct=1001
[19716.010733] usb 2-1.1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0

To be perfectly honest a previous attempt didn't have the "New USB
device" at the end, but the result was the same : no tuning possible (
"WARNING: >>> tuning failed!!!" ) even if there is a device file for it
in /dev/ ( on a Linux debian 2.6.26-2-686 #1 SMP Fri Aug 14 01:27:18 UTC
2009 i686 GNU/Linux with V4L/DVB driver using mercurial ). I've checked
the antenna cable  ( my old Intuix S800 work perfectly in the same setup
but it does not have a remote :) )


Thanks for any info/tips.



