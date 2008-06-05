Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter.ueger@googlemail.com>) id 1K4Ice-0002kU-Ll
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 18:47:33 +0200
Received: by ug-out-1314.google.com with SMTP id m3so597949uge.20
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 09:47:28 -0700 (PDT)
Message-ID: <828b75a10806050947l2f1f30e7w6b51498f63fa4b31@mail.gmail.com>
Date: Thu, 5 Jun 2008 18:47:28 +0200
From: "Peter Ueger" <peter.ueger@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] KNC1 DVB-C Plus: Can't find channels at a specific
	frequency
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

Greetings!

I have problems finding a couple of channels at a specific frequency
(538000MHz). I can find these channels with my set-top box and also
with a different DVB-C card so they must be there. Under Windows XP I
have the same problem with this card and the software there gives the
failure message "PTA Table incomplete".

$ lspci -v
[...]
00:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
Subsystem: KNC One Unknown device 0021
Flags: bus master, medium devsel, latency 32, IRQ 19
Memory at fb022000 (32-bit, non-prefetchable) [size=512]

$ dmesg | grep -i dvb
[   27.962301] DVB: registering new adapter (KNC1 DVB-C Plus)
[   28.530779] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...

$ scan tuningdata > channels.conf
[...]
>>> tune to: 538000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_64
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
