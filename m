Return-path: <linux-media-owner@vger.kernel.org>
Received: from web86703.mail.ird.yahoo.com ([217.146.188.144]:22298 "HELO
	web86703.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752142AbZCVI4J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 04:56:09 -0400
Message-ID: <509292.77960.qm@web86703.mail.ird.yahoo.com>
Date: Sun, 22 Mar 2009 08:49:24 +0000 (GMT)
From: Philip Poole <philip_poole@btinternet.com>
Subject: Can't tune to Astra 2D (because of Symbol Rate 220000?)
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

Essentially I'm a Linux DVB newbie, and am struggling with this.
Basically I want to just record BBC HD, and watch it elsewhere via UPnP server (Mediatomb).
I
have three tuners. A Hauppauge WinTV DVB-S USB tuner. This works fine.
It can tune to the required transponder (Astra 2D, 10847, Vertical,
Symbol Rate 220000), but it seems to have a bandwidth limit of about
6Mbps (I suspect its because its USB 1.1) and so it can handle SD based
video streams, but not HD.
So I have two other cards from Ebay. Both PCI this time. A Technisat Skystar 2 and more recently (due to this one's failure) a Hauppauge WinTV DVB-S rev 1.3.
I
deliberately chose the Hauppauge as it was revision 1.3 (and apparently
well supported), and a different chipset to the Skystar 2. It's obvious
they're different as I had to download and install firmware for the
1.3, which I didn't have to for the Skystar 2.
They
both work, recognised by the kernel and appear in /dev/dvb, and can
tune to stuff (typically with a symbol rate of 275000) but both
completely fail to Freesat channels (basically Astra 2D) because (I
think) the symbol rate is 220000. Very weird!
I'm using Fedora 9 essentially out of the box, nothing peculiar done to change it.

So,
is this a known problem? Has anybody else seen this? Is there a DVB-S
card that will tune to this fairly standard scenario? I've seen a
Compro VideoMate S300 do it in Windows, but that card isn't supported
in Linux. Or, is it a LinuxTV/Kernel version problem (I'm sorry, I'm
not sure which version of the Kernel I'm using definitely 2.6.x, I'm
aware from the box at the moment so can't tell just now.)

Help!

Cheers,
Phil 

