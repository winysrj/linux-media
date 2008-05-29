Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefanselariu@gmail.com>) id 1K1lev-0003SZ-GK
	for linux-dvb@linuxtv.org; Thu, 29 May 2008 19:11:26 +0200
Received: by gv-out-0910.google.com with SMTP id n29so1166377gve.16
	for <linux-dvb@linuxtv.org>; Thu, 29 May 2008 10:11:21 -0700 (PDT)
Message-ID: <cc5a77190805291011t68f70773re0851a68f188e1a6@mail.gmail.com>
Date: Thu, 29 May 2008 20:11:21 +0300
From: "=?ISO-8859-2?Q?=AAtefan_=AAelariu?=" <stefanselariu@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] saa7136E status?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0027408276=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0027408276==
Content-Type: multipart/alternative;
	boundary="----=_Part_5832_26342347.1212081081400"

------=_Part_5832_26342347.1212081081400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have an Avermedia AverTV Speedy PCI-E which has the NXD chips:
SAA7136E/1/G, SAA7160ET and TDA18271HDC1

#lspci -v
03:00.0 Multimedia controller: Philips Semiconductors Unknown device 7160
(rev 03)
    Subsystem: Avermedia Technologies Inc Unknown device 1655
    Flags: bus master, fast devsel, latency 0, IRQ 10
    Memory at fea00000 (64-bit, non-prefetchable) [size=1M]
    Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5
Enable-
    Capabilities: [50] Express Endpoint IRQ 0
    Capabilities: [74] Power Management version 2
    Capabilities: [80] Vendor Specific Information

Is there a driver for this card?

Best regards,
Stefan

------=_Part_5832_26342347.1212081081400
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have an Avermedia AverTV Speedy PCI-E which has the NXD chips: SAA7136E/1/G, SAA7160ET and TDA18271HDC1<br><br>#lspci -v<br>03:00.0 Multimedia controller: Philips Semiconductors Unknown device 7160 (rev 03)<br>&nbsp;&nbsp;&nbsp; Subsystem: Avermedia Technologies Inc Unknown device 1655<br>
&nbsp;&nbsp;&nbsp; Flags: bus master, fast devsel, latency 0, IRQ 10<br>&nbsp;&nbsp;&nbsp; Memory at fea00000 (64-bit, non-prefetchable) [size=1M]<br>&nbsp;&nbsp;&nbsp; Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5 Enable-<br>&nbsp;&nbsp;&nbsp; Capabilities: [50] Express Endpoint IRQ 0<br>
&nbsp;&nbsp;&nbsp; Capabilities: [74] Power Management version 2<br>&nbsp;&nbsp;&nbsp; Capabilities: [80] Vendor Specific Information<br><br>Is there a driver for this card?<br><br>Best regards,<br>Stefan<br><br>

------=_Part_5832_26342347.1212081081400--


--===============0027408276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0027408276==--
