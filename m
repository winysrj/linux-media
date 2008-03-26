Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JeWJ2-0006Ob-6T
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 15:08:45 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JYC004L9CLKMJ71@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 26 Mar 2008 10:08:09 -0400 (EDT)
Date: Wed, 26 Mar 2008 10:08:07 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <000b01c88f27$93923bf0$0a00a8c0@vorg>
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Message-id: <47EA58C7.1010200@linuxtv.org>
MIME-version: 1.0
References: <000b01c88f27$93923bf0$0a00a8c0@vorg>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Correct drivers for HVR-1800
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

Timothy D. Lenz wrote:
> Found out both the PCIe x1 slots on my motherboard seem to be bad. But the
> card does show up in the x16 slot which i'll using until I can get an RMA
> from Asus (hope they do cross shiping).
> 
> I had to blacklist cx23885 so that the nexus drivers would work.
> 
> I load driver cx23885 (after the nexus drivers) which then also loads
> compat_ioctl32 and videobuf_dvb. I also have tried loading ivtv which in
> turn loads cx2341x, but these seem to have no effect. I got the firmware
> from http://steventoth.net/linux/hvr1800/, ran the script and put the files
> in /lib/firmware which already has the firmware for my Nexus.
> 
> I got dvb-apps but am having problems compiling it. I am able to compile
> just scan and used it to scan for atsc channels. There are 2 channels which
> it says it tunes that don't show up in the list it makes but it also says it
> won't include analog channels in the list :(.
> 
> I patched VDR for atsc channels and added the atscepg plugin. I now have 2
> adapters but when I try to scan from the plugin, it says not atsc device
> found. I also tried seeding the channels.conf with a valid atsc channel
> using info posted about the patch/plugin, but I get channel not available
> even if I switch primary devices.
> 
> I posted in the dvbn board about the problems with the plugin, but wanted to
> know if I missed any drivers I need to load.

Sounds OK generally. You don't normally have to do anything with with 
the drivers to make ATSC or QAM work.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
