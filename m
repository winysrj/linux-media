Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefanselariu@gmail.com>) id 1K1Fz1-0004SD-Ba
	for linux-dvb@linuxtv.org; Wed, 28 May 2008 09:22:07 +0200
Received: by mu-out-0910.google.com with SMTP id w8so2134203mue.1
	for <linux-dvb@linuxtv.org>; Wed, 28 May 2008 00:21:57 -0700 (PDT)
From: Stefan Selariu <stefanselariu@gmail.com>
To: linux-dvb@linuxtv.org
Date: Wed, 28 May 2008 10:21:58 +0300
Message-Id: <1211959318.5974.10.camel@stefan>
Mime-Version: 1.0
Subject: [linux-dvb] AVerTV Speedy PCI-E
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
I have this card which I cannot use under Linux :(
        
#lspci -vnn
        03:00.0 Multimedia controller [0480]: Philips Semiconductors
Unknown device [1131:7160] (rev 03)
	Subsystem: Avermedia Technologies Inc Unknown device [1461:1655]
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at fea00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5
Enable-
	Capabilities: [50] Express Endpoint IRQ 0
	Capabilities: [74] Power Management version 2
	Capabilities: [80] Vendor Specific Information

http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=426
        
I'll provide chip names later, when I get home and open the computer
case.
        
Is there a driver for this card?
How is this card supported under Linux?
        
Best regards,
Stefan


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
