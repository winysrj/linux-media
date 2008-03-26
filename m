Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout.perfora.net ([74.208.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlenz@vorgon.com>) id 1JeSMQ-0003Y8-6E
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 10:55:59 +0100
Message-ID: <000b01c88f27$93923bf0$0a00a8c0@vorg>
From: "Timothy D. Lenz" <tlenz@vorgon.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 26 Mar 2008 02:51:41 -0700
MIME-Version: 1.0
Subject: [linux-dvb] Correct drivers for HVR-1800
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

Found out both the PCIe x1 slots on my motherboard seem to be bad. But the
card does show up in the x16 slot which i'll using until I can get an RMA
from Asus (hope they do cross shiping).

I had to blacklist cx23885 so that the nexus drivers would work.

I load driver cx23885 (after the nexus drivers) which then also loads
compat_ioctl32 and videobuf_dvb. I also have tried loading ivtv which in
turn loads cx2341x, but these seem to have no effect. I got the firmware
from http://steventoth.net/linux/hvr1800/, ran the script and put the files
in /lib/firmware which already has the firmware for my Nexus.

I got dvb-apps but am having problems compiling it. I am able to compile
just scan and used it to scan for atsc channels. There are 2 channels which
it says it tunes that don't show up in the list it makes but it also says it
won't include analog channels in the list :(.

I patched VDR for atsc channels and added the atscepg plugin. I now have 2
adapters but when I try to scan from the plugin, it says not atsc device
found. I also tried seeding the channels.conf with a valid atsc channel
using info posted about the patch/plugin, but I get channel not available
even if I switch primary devices.

I posted in the dvbn board about the problems with the plugin, but wanted to
know if I missed any drivers I need to load.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
