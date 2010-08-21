Return-path: <mchehab@pedra>
Received: from mx4.orcon.net.nz ([219.88.242.54]:44009 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0HUG4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Aug 2010 02:56:33 -0400
Received: from Debian-exim by mx4.orcon.net.nz with local (Exim 4.69)
	(envelope-from <aaron@whitehouse.org.nz>)
	id 1Omgwp-0003a4-Ly
	for linux-media@vger.kernel.org; Sat, 21 Aug 2010 17:48:55 +1200
Received: from [121.98.204.64] (helo=[192.168.0.103])
	by mx4.orcon.net.nz with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <aaron@whitehouse.org.nz>)
	id 1Omgwp-0003Zv-I6
	for linux-media@vger.kernel.org; Sat, 21 Aug 2010 17:48:55 +1200
Message-ID: <4C6F68C6.4080007@whitehouse.org.nz>
Date: Sat, 21 Aug 2010 17:48:54 +1200
From: Aaron Whitehouse <aaron@whitehouse.org.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge hvr-2200 stops working when Hauppauge hvr-1110 is connected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

I am using Mythbuntu 10.04 and have linux-firmware-nonfree from:
https://bugs.launchpad.net/ubuntu/+source/linux-firmware-nonfree/+bug/579783

I have been happily using Mythbuntu with a Hauppauge hvr-2200 dual tuner
DVB-T for many months (thanks Steven Toth!) and it records all my TV in
MythTV.

NZ has three DVB-T multiplexes, so I bought a second single-tuner DVB-T
card, a Hauppauge hvr-1110, to cover the third multiplex and mean that,
with multirec, I can record all channels and never hit a conflict.

As I say, the hvr-2200 works really well. When I put the hvr-1110 in
(and install the non-free firmware linked above), the hvr-1110 registers
as an adapter and plays TV well as well.

Unfortunately, when I have both cards in with their firmware, the
hvr-1110 stops the hvr-2220 registering its two adapters. Dmesg is
attached to my Launchpad bug here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/621578
I have now (before reporting the bug) removed the hvr-1110 so that I am
back to my working dual-tuner hvr-2200 configuration.

Interestingly to me, when I only have the hvr-2200 firmware installed,
but with both cards in the machine, all three adapters register (create
/dev/dvb/ nodes), but clearly only the hvr-2200 adapters actually work.

Any suggestions would be greatly appreciated. I saw some things in dmesg
about IRQ conflicts, but I really have no idea.

Regards,

Aaron
