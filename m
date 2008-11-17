Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp7-g19.free.fr ([212.27.42.64])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ttk22@free.fr>) id 1L2AqZ-0006YQ-6K
	for linux-dvb@linuxtv.org; Mon, 17 Nov 2008 21:37:24 +0100
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 6C485B0706
	for <linux-dvb@linuxtv.org>; Mon, 17 Nov 2008 21:37:17 +0100 (CET)
Received: from [192.168.0.2] (lns-bzn-47f-62-147-251-209.adsl.proxad.net
	[62.147.251.209])
	by smtp7-g19.free.fr (Postfix) with ESMTP id DB61AB0E3C
	for <linux-dvb@linuxtv.org>; Mon, 17 Nov 2008 21:37:16 +0100 (CET)
Message-ID: <4921D5F8.4090403@free.fr>
Date: Mon, 17 Nov 2008 21:37:12 +0100
From: Roland HAMON <ttk22@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Hi, hauppauge win tv Nova-s plus won't tune
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

Hi

(I'm new to the list, hope I won't infringe any rule on my first post)

I have a hauppauge win tv nova-s plus PCI card, connected to a simple
dish wich is pointed to hotbird3. Under windows wintv works fine: I get
160+ free to air tv channels as expected.

Under ubuntu intrepid 64 bits (2.6.27 kernel) vdr fails to tune any
channel. I tried dvb-apps 'scan' with no success:

scanning Hotbird-13.0E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12539000 H 27500000 3
initial transponder 10892000 H 27500000 3
initial transponder 10853000 H 27500000 3
initial transponder 10992000 V 27500000 2
initial transponder 11334000 H 27500000 2
initial transponder 11373000 H 27500000 2
initial transponder 12460000 V 27500000 3
>>> tune to: 12539:h:0:27500
DiSEqC: switch pos 0, 18V, hiband (index 3)
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01


femon -H gives 60% signal and 40% snr. (quite bad!)
Then when I poweroff my computer hangs and the motherboards beeps
repeatedly until I hard swith it off.

Any help greatly appreciated.
(btw, http://bugzilla.kernel.org/show_bug.cgi?id=9476 ...
 I might be having the same bug but I did not try any previous kernel
version with this card)

Bye
-- 
 TTK

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
