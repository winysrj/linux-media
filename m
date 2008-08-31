Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48B9E6E2.3030104@sustik.com>
Date: Sat, 30 Aug 2008 19:33:38 -0500
From: Matyas Sustik <linux-dvb.list@sustik.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <48B822A9.6070400@sustik.com>	
	<37219a840808290932n23165451nfcdfa6ded704713e@mail.gmail.com>	
	<48B83C83.7050801@sustik.com>
	<37219a840808291204o7012d75t95bd8dbcf3ee0cc2@mail.gmail.com>
In-Reply-To: <37219a840808291204o7012d75t95bd8dbcf3ee0cc2@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fusion HDTV 7
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

Thanks for your comments!

I can report that the card receives OTA HD channels.  Both tuners
work (at the same time) allowing two HD channels to be received.
(azap/mplayer and mythtv both work.)

The last missing piece was with the firmware.  A script which came
with the firmware files from www.steventoth.net placed the firmware
file dvb-fe-xc5000-1.1.fw to /lib/firmware/2.6.26-amd64 instead of
/lib/firmware.  This may be distro specific.

I could have figured all this out by the available docs and reading
the logs.  However here is a list of what may improve the documentation:

1.  Emphasize that other than the card module (in my case cx23885) need
to be reloaded for compatibility between modules.  Therefore the compile
from sources and reboot is needed.  (Easier than to find, remove and reload
all the relevant modules.)

2.  The firmware file has to be hunted down.  In my case the manufacturer
provides .exe files only (maybe self-extracting) so I could not get the
firmware that way.  Why not just have a page with the firmware files
themselves?  The need for the firmware file also could be emphasized.
(This is apparent if one reads the logs.)

Some info on what should be in the logs when the card works:

CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Express
[card=10,autodetected]
DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)..

xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously

xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
firmware: requesting dvb-fe-xc5000-1.1.fw
xc5000: firmware read 12332 bytes.
xc5000: firmware upload

Thanks again,
Matyas
-
Every hardware eventually breaks.  Every software eventually works.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
