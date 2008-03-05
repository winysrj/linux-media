Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <starkp@gmail.com>) id 1JWkjW-0000DX-KV
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 04:56:01 +0100
Received: by hs-out-0708.google.com with SMTP id 4so1144910hsl.1
	for <linux-dvb@linuxtv.org>; Tue, 04 Mar 2008 19:55:54 -0800 (PST)
Message-ID: <ebda1c680803041955y3995c805x3af62c68c44a9fef@mail.gmail.com>
Date: Tue, 4 Mar 2008 22:55:53 -0500
From: "paul stark" <starkp@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] ADS Tech Instant HDTV PCI
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1686781853=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1686781853==
Content-Type: multipart/alternative;
	boundary="----=_Part_18980_17072069.1204689353856"

------=_Part_18980_17072069.1204689353856
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I've been trying to get the ADS Tech Instant HDTV PCI card to work with
gentoo under Xen.  I'm running the 2.6.21 xen-sources kernel.  The issue I
am having is that when the saa7134 driver loads, it generates the following
error:

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:04:01.0, rev: 17, irq: 18, latency: 64, mmio:
0xfebff800
saa7133[0]: subsystem: 1421:0380, board: Kworld ATSC110 [card=90,insmod
option]
saa7133[0]: can't ioremap() MMIO memory
saa7134: probe of 0000:04:01.0 failed with error -5

Here is the information from the lspci output:

~ # lspci -v
04:01.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video
Broadcast Decoder (rev 11)
        Subsystem: Ads Technologies Inc Unknown device 0380
        Flags: bus master, medium devsel, latency 64, IRQ 18
        Memory at febff800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2

I've tried googling the error and haven't had much luck in finding a
solution.  I was wondering if anyone has any suggestions that can assist in
troubleshooting why the driver won't load.

Thanks,
Paul

------=_Part_18980_17072069.1204689353856
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I&#39;ve been trying to get the  ADS Tech Instant HDTV PCI card to work with gentoo under Xen.&nbsp; I&#39;m running the 2.6.21 xen-sources kernel.&nbsp; The issue I am having is that when the saa7134 driver loads, it generates the following error:<br>
<br>saa7130/34: v4l2 driver version 0.2.14 loaded<br>saa7133[0]: found at 0000:04:01.0, rev: 17, irq: 18, latency: 64, mmio: 0xfebff800<br>saa7133[0]: subsystem: 1421:0380, board: Kworld ATSC110 [card=90,insmod option]<br>
saa7133[0]: can&#39;t ioremap() MMIO memory<br>saa7134: probe of 0000:04:01.0 failed with error -5<br><br>Here is the information from the lspci output:<br><br>~ # lspci -v<br>04:01.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video Broadcast Decoder (rev 11)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Ads Technologies Inc Unknown device 0380<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, latency 64, IRQ 18<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Memory at febff800 (32-bit, non-prefetchable) [size=2K]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [40] Power Management version 2<br>
<br>I&#39;ve tried googling the error and haven&#39;t had much luck in finding a
solution.&nbsp; I was wondering if anyone has any suggestions that can assist
in troubleshooting why the driver won&#39;t load.<br><br>Thanks,<br>Paul<br>

------=_Part_18980_17072069.1204689353856--


--===============1686781853==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1686781853==--
