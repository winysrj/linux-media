Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:36553 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754847Ab0EBSNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 May 2010 14:13:10 -0400
Received: from [172.23.170.137] (helo=anti-virus01-08)
	by smtp-out3.blueyonder.co.uk with smtp (Exim 4.52)
	id 1O8dfA-0006hS-R1
	for linux-media@vger.kernel.org; Sun, 02 May 2010 19:13:08 +0100
Received: from [82.44.72.151] (helo=cpc1-nmal4-0-0-cust150.croy.cable.virginmedia.com)
	by asmtp-out6.blueyonder.co.uk with esmtp (Exim 4.52)
	id 1O8dfA-0007j8-Cy
	for linux-media@vger.kernel.org; Sun, 02 May 2010 19:13:08 +0100
Date: Sun, 2 May 2010 19:13:08 +0100 (BST)
From: John J Lee <jjl@pobox.com>
To: linux-media@vger.kernel.org
Subject: saa7146 firmware upload time?
Message-ID: <alpine.DEB.2.00.1005021904150.4041@alice>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

My "WinTV NOVA-t" PCI card is recognized by the saa7146 driver (ubuntu 
9.10 2.6.31-21-generic kernel), but I don't have a /dev/video0.  At some 
point I noticed messages in syslog about missing firmware (below), and 
rectified that by fetching the firmware and dropping it in /lib/firmware.

However, there's a big gap (over an hour and a half) between boot and the 
time when the driver complains about the firmware:

May  2 16:00:28 alice kernel: [   58.447825] saa7146: register extension 'budget_ci dvb'.
May  2 16:00:28 alice kernel: [   58.449357] budget_ci dvb 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
May  2 16:00:28 alice kernel: [   58.449394] IRQ 17/: IRQF_DISABLED is not guaranteed on shared IRQs
May  2 16:00:28 alice kernel: [   58.449412] saa7146: found saa7146 @ mem ffffc90011348c00 (revision 1, irq 17) (0x13c2,0x1011).
May  2 16:00:28 alice kernel: [   58.449416] saa7146 (0): dma buffer size 192512
May  2 16:00:28 alice kernel: [   58.449417] DVB: registering new adapter (TT-Budget/WinTV-NOVA-T        PCI)
May  2 16:00:28 alice kernel: [   58.510969] adapter has MAC addr = 00:d0:5c:23:ed:cf
May  2 16:00:28 alice kernel: [   58.511252] input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00:1e.0/0000:05:01.0/input/input7
May  2 16:00:28 alice kernel: [   58.587617] DVB: registering adapter 0 frontend 0 (Philips TDA10045H DVB-T)...
[...]
May  2 17:40:39 alice kernel: [ 6057.360792] tda1004x: found firmware revision 0 -- invalid
May  2 17:40:39 alice kernel: [ 6057.360795] tda1004x: waiting for firmware upload (dvb-fe-tda10045.fw)...
May  2 17:40:39 alice kernel: [ 6057.360800] budget_ci dvb 0000:05:01.0: firmware: requesting dvb-fe-tda10045.fw
May  2 17:40:39 alice kernel: [ 6057.449458] tda1004x: no firmware upload (timeout or file not found?)
May  2 17:40:39 alice kernel: [ 6057.449461] tda1004x: firmware upload failed
May  2 17:40:39 alice firmware.sh[4365]: Cannot find  firmware file 'dvb-fe-tda10045.fw'


I don't know anything about the kernel but looking at the source seemed to 
suggest the driver looks for the firmware at modprobe time, but rmmod 
followed by modprobe doesn't give me any messages about firmware (nor does 
a reboot).  What should I do to trigger this firmware upload process 
again?

Thanks


John

