Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <billmccartney@gmail.com>) id 1KgaQV-0003RV-Mr
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 09:29:16 +0200
Received: by ug-out-1314.google.com with SMTP id 39so2259676ugf.16
	for <linux-dvb@linuxtv.org>; Fri, 19 Sep 2008 00:29:12 -0700 (PDT)
Message-ID: <d77717b60809190029p4bdcdda6g55db6a9261673675@mail.gmail.com>
Date: Fri, 19 Sep 2008 03:29:12 -0400
From: "Bill McCartney" <billmccartney@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] HVR-1800 - can't find the card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1756675585=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1756675585==
Content-Type: multipart/alternative;
	boundary="----=_Part_15398_28895902.1221809352019"

------=_Part_15398_28895902.1221809352019
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Well, I'm not sure if it is a DVB problem. The hvr-1800 shows up in my
lspci, but driver doesn't load. I have tried kernels version 2.26.24 and
2.26.25.7, removed all other cards from the system - and still have the same
problem.

Output when I try to install the driver
cx23885 driver version 0.0.1 loaded
cx23885[0]: can't get MMIO memory @ 0x0
CORE cx23885[0] No more PCIe resources for subsystem: 0070:7801
cx23885: probe of 0000:03:00.0 failed with error -22

The output of my lspci -v (of the card)
03:00.0 Multimedia video controller: Conexant Unknown device 8880 (rev 0f)
        Subsystem: Hauppauge computer works Inc. Unknown device 7801
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at <ignored> (64-bit, non-prefetchable)
        Capabilities: [40] Express Endpoint IRQ 0
        Capabilities: [80] Power Management version 2
        Capabilities: [90] Vital Product Data
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable-

In my kernel logs I see this from the bootlogs:
PCI: Cannot allocate resource region 0 of device 0000:03:00.0

I've tried several kernel options as far as pci configuration goes -- does
this mean that I have bad hardware? Should I just return it to the store? Is
it a conflict with my motherboard?

Thanks in advanced,
 - Bill

------=_Part_15398_28895902.1221809352019
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Well, I&#39;m not sure if it is a DVB problem. The hvr-1800 shows up in my lspci, but driver doesn&#39;t load. I have tried kernels version 2.26.24 and <a href="http://2.26.25.7">2.26.25.7</a>, removed all other cards from the system - and still have the same problem.<br>
<br>Output when I try to install the driver<br>cx23885 driver version 0.0.1 loaded<br>cx23885[0]: can&#39;t get MMIO memory @ 0x0<br>CORE cx23885[0] No more PCIe resources for subsystem: 0070:7801<br>cx23885: probe of 0000:03:00.0 failed with error -22<br>
<br>The output of my lspci -v (of the card)<br>03:00.0 Multimedia video controller: Conexant Unknown device 8880 (rev 0f)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Hauppauge computer works Inc. Unknown device 7801<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags: bus master, fast devsel, latency 0, IRQ 10<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Memory at &lt;ignored&gt; (64-bit, non-prefetchable)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [40] Express Endpoint IRQ 0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [80] Power Management version 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [90] Vital Product Data<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-<br><br>In my kernel logs I see this from the bootlogs:<br>PCI: Cannot allocate resource region 0 of device 0000:03:00.0<br><br>I&#39;ve tried several kernel options as far as pci configuration goes -- does this mean that I have bad hardware? Should I just return it to the store? Is it a conflict with my motherboard?<br>
<br>Thanks in advanced,<br>&nbsp;- Bill<br></div>

------=_Part_15398_28895902.1221809352019--


--===============1756675585==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1756675585==--
