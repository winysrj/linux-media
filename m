Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:38267 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZK1Uza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 15:55:30 -0500
Received: from compi (xdsl-81-173-252-240.netcologne.de [81.173.252.240])
	by post.strato.de (fruni mo36) (RZmta 22.5)
	with ESMTP id x01574lASJ8OWh for <linux-media@vger.kernel.org>;
	Sat, 28 Nov 2009 21:55:36 +0100 (MET)
From: Jochen Puchalla <mail@puchalla-online.de>
To: linux-media@vger.kernel.org
Subject: Problem tuning TT T-1200 FF DVB-T
Date: Sat, 28 Nov 2009 21:55:27 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911282155.27486.mail@puchalla-online.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

my new card will not tune, it has a problem with the firmware I am offering. 
Does not seem to fit. TV-out with this card works fine.

Here's my log:
Nov 28 15:35:00 vdr kernel: saa7146: register extension 'dvb'.
Nov 28 15:35:00 vdr kernel: dvb 0000:00:0d.0: enabling device (0004 -> 0006)
Nov 28 15:35:00 vdr kernel: dvb 0000:00:0d.0: PCI INT A -> GSI 16 (level, 
low) -> IRQ 16
Nov 28 15:35:00 vdr kernel: IRQ 16/: IRQF_DISABLED is not guaranteed on shared 
IRQs
Nov 28 15:35:00 vdr kernel: saa7146: found saa7146 @ mem d2146000 (revision 1, 
irq 16) (0x13c2,0x0001).
Nov 28 15:35:00 vdr kernel: dvb 0000:00:0d.0: firmware: requesting 
dvb-ttpci-01.fw
Nov 28 15:35:00 vdr kernel: DVB: registering new adapter 
(Technotrend/Hauppauge WinTV DVB-T rev1.X)
Nov 28 15:35:00 vdr kernel: adapter has MAC addr = 00:d0:5c:01:e4:50
Nov 28 15:35:00 vdr kernel: dvb 0000:00:0d.0: firmware: requesting 
av7110/bootcode.bin
Nov 28 15:35:00 vdr kernel: dvb-ttpci: gpioirq unknown type=0 len=0
Nov 28 15:35:00 vdr kernel: dvb-ttpci: info @ card 1: firm f0240009, rtsl 
b0250018, vid 71010068, app 8000261d
Nov 28 15:35:00 vdr kernel: dvb-ttpci: firmware @ card 1 supports CI link 
layer interface
Nov 28 15:35:00 vdr kernel: dvb-ttpci: Crystal audio DAC @ card 1 detected
Nov 28 15:35:00 vdr kernel: saa7146_vv: saa7146 (0): registered device video0 
[v4l2]
Nov 28 15:35:00 vdr kernel: saa7146_vv: saa7146 (0): registered device vbi0 
[v4l2]
Nov 28 15:35:00 vdr kernel: DVB: registering adapter 1 frontend 0 (Spase 
SP8870 DVB-T)...
Nov 28 15:35:00 vdr kernel: input: DVB on-card IR receiver 
as /class/input/input4
Nov 28 15:35:00 vdr kernel: dvb-ttpci: found av7110-0.
Nov 28 15:35:00 vdr kernel: sp8870: waiting for firmware upload 
(dvb-fe-sp8870.fw)...
Nov 28 15:35:00 vdr kernel: dvb 0000:00:0d.0: firmware: requesting 
dvb-fe-sp8870.fw
Nov 28 15:35:00 vdr kernel: sp8870: no firmware upload (timeout or file not 
found?)
Nov 28 15:35:00 vdr kernel: sp8870_set_frontend: firmware crash!!!!!!
Nov 28 15:35:00 vdr last message repeated 7 times
Nov 28 15:35:00 vdr kernel: warning: `dnsmasq' uses 32-bit capabilities 
(legacy support in use)
Nov 28 15:35:00 vdr kernel: sp8870_set_frontend: firmware crash!!!!!!
Nov 28 15:35:01 vdr kernel: sp8870_set_frontend: firmware crash!!!!!!
Nov 28 15:35:05 vdr last message repeated 8 times
Nov 28 15:35:05 vdr vdr: [2109] frontend 1 timed out while tuning to channel 
1, tp 706
Nov 28 15:35:05 vdr kernel: sp8870_set_frontend: firmware crash!!!!!!
Nov 28 15:35:06 vdr kernel: sp8870_set_frontend: firmware crash!!!!!!
Nov 28 15:35:31 vdr last message repeated 52 times

I do have this firmware:
-rw-r--r-- 1 root root  20108 2009-11-28 16:28 dvb-fe-sp8870.fw
All other firmwares load fine, but this one doesn't.
Can you help me?
