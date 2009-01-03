Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1LIym2-0000kG-Dw
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 06:10:12 +0100
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LIylu-0004sS-W4
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 05:10:03 +0000
Received: from 116.209.11.123 ([116.209.11.123])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 05:10:02 +0000
Received: from peter by 116.209.11.123 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 05:10:02 +0000
To: linux-dvb@linuxtv.org
From: Peter Hoeg <peter@hoeg.com>
Date: Sat, 3 Jan 2009 04:38:47 +0000 (UTC)
Message-ID: <loom.20090103T043514-870@post.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] HVR-1200, cx23885 driver and Message Signaled Interrupts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I'm successfully using a HVR1200, however the board reports MSI capabilities and
the driver doesn't seem to enable it. Is there any work happening on supporting
MSI? Anyway I can help testing things out?

$ lspci -v -s 4:0.0
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video
and Audio Decoder (rev 02)
	Subsystem: Hauppauge computer works Inc. Device 71d3
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at ef800000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: cx23885
	Kernel modules: cx23885

Regards,
Peter


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
