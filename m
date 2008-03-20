Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eeyore.nlsn.nu ([213.115.133.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dlist2@nlsn.nu>) id 1JcJOF-0003YV-6W
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 12:57:00 +0100
Received: from localhost (localhost [127.0.0.1])
	by eeyore.nlsn.nu (Postfix) with ESMTP id 98E2F1C059
	for <linux-dvb@linuxtv.org>; Thu, 20 Mar 2008 12:56:56 +0100 (CET)
Date: Thu, 20 Mar 2008 12:56:56 +0100 (CET)
From: dlist2@nlsn.nu
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0803201256390.4638@eeyore.nlsn.nu>
MIME-Version: 1.0
Subject: [linux-dvb] TT-Budget C-1501 not working
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

I just purchased a Technotrend Budget C-1501.
Im running Mythbuntu Beta, and downloaded the latest v4l drivers but it 
still fails.

lspci -v

05:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Unknown device 101a
        Flags: bus master, medium devsel, latency 66, IRQ 5
        Memory at fc501000 (32-bit, non-prefetchable) [size=512]

lspci -n

05:04.0 0480: 1131:7146 (rev 01)
        Subsystem: 13c2:101a
        Flags: bus master, medium devsel, latency 66, IRQ 5
        Memory at fc501000 (32-bit, non-prefetchable) [size=512]

log says

 kernel: [   54.207308] Linux video capture  interface: v2.00
 kernel: [   54.501753] saa7146: register extension 'dvb'.
 runvdr: stopping after fatal fail (vdr: warning - cannot set dumpable: Invalid argument vdr: no primary device found - using 
first device!)

And /dev/dvb is empty of course.
Im not a kernel hacker, but if you have any hits on how to get this card 
working please let me know.

Thanks

  Daniel

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
