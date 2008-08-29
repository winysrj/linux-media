Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb.list@sustik.com>) id 1KZ6mF-0002hc-94
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 18:24:48 +0200
Received: from [192.168.11.5] (really [66.68.29.99])
	by hrndva-omta03.mail.rr.com with ESMTP
	id <20080829162411.AAK22935.hrndva-omta03.mail.rr.com@[192.168.11.5]>
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 16:24:11 +0000
Message-ID: <48B822A9.6070400@sustik.com>
Date: Fri, 29 Aug 2008 11:24:09 -0500
From: Matyas Sustik <linux-dvb.list@sustik.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Fusion HDTV 7
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

I am using debian sid and attempts to load the cx23885 module fail:

in dmesg:
cx23885: Unknown parameter `car'
(I use the card=4 option.)

The device:
02:00.0 Multimedia video controller: Conexant Device 8852 (rev 02)
        Subsystem: DViCO Corporation Device d618
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at fbc00000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express Endpoint, MSI 00
        Capabilities: [80] Power Management version 2
        Capabilities: [90] Vital Product Data <?>
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [200] Virtual Channel <?>
        Kernel modules: cx23885

kernel version:
2.6.26-1-amd64

Note that this module came with the debian package:
linux-image-2.6.26-1-amd64      2.6.26-3

1.  Am I right that this is not supposed to happen?  May I conclude
that the packaged module is incompatible with the kernel it is packaged for?
If so, I can report this bug to Debian; but I want to make sure I have the
concepts straight before they shoot me down saying it is linuxtv.org's fault.

2.  I tried recompiling the module(s) using sources from linuxtv.org.  I used
http://linuxtv.org/hg/v4l-dvb but the created modules still reported unknown
symbols:
cx23885: disagrees about version of symbol videobuf_streamoff
cx23885: Unknown symbol videobuf_streamoff

There are actually various other mercurial repos hosted on linuxtv.org, which
one should I try next?

Thanks in advance!
Matyas






-- 
Matyas
-
Every hardware eventually breaks.  Every software eventually works.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
