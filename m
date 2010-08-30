Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49225 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab0H3WWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 18:22:12 -0400
Received: by eyg5 with SMTP id 5so3501718eyg.19
        for <linux-media@vger.kernel.org>; Mon, 30 Aug 2010 15:22:11 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org, Andy Walls <awalls@radix.net>
Subject: cx23885: Message Signaled Interrupts issue
Date: Tue, 31 Aug 2010 01:22:09 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008310122.09742.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

I was wondering, if someone tried 2.6.36-rc kernels with PCIe MSI enabled.
With TeVii s470 after rmmod cx23885 && insmod cx23885 then szap some channel I have 'No irq 
handler for vector' message. After reboot it's OK.
I think it's A/V core interrupts involved.

igor@useri:~$ szap -l10750 bridge-tv -p
reading channels from file '/home/igor/.szap/channels.conf'
zapping to 5 'bridge-tv':
sat 1, frequency = 12303 MHz H, symbolrate 27500000, vpid = 0x0134, apid = 0x0100 sid = 0x003b
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

Message from syslogd@localhost at Tue Aug 31 00:55:32 2010 ...
localhost kernel: do_IRQ: 1.137 No irq handler for vector (irq -1)

Message from syslogd@localhost at Tue Aug 31 00:55:33 2010 ...
localhost kernel: do_IRQ: 0.137 No irq handler for vector (irq -1)

Message from syslogd@localhost at Tue Aug 31 00:55:34 2010 ...
localhost kernel: do_IRQ: 1.137 No irq handler for vector (irq -1)

Message from syslogd@localhost at Tue Aug 31 00:55:35 2010 ...
localhost kernel: do_IRQ: 0.137 No irq handler for vector (irq -1)


It is similar issue with NetUP DVB-S2 , but CI involved through GPIO interrupts.
Compro e650f works well, though it uses neither A/V core interrupts nor GPIO interrupts.


-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
