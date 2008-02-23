Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JSnh9-0007kV-Sa
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 07:17:12 +0100
Received: from berkeloid.vlook.shikadi.net ([192.168.4.11])
	by vitalin.sorra.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JSnh5-0004NS-G8
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 16:17:07 +1000
Received: from korath.teln.shikadi.net ([192.168.0.14])
	by berkeloid.teln.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JSnfh-0003CJ-Q4
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 16:15:41 +1000
Message-ID: <47BFBA0D.2080607@shikadi.net>
Date: Sat, 23 Feb 2008 16:15:41 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How do you stream the entire MPEG-TS with dvbstream?
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

Hi everyone,

I've just installed a new DViCO FusionHDTV dual digital 4 (which appears
to the PC as two USB "Zarlink ZL10353 DVB-T" devices.)

I'm trying to set up dvbstream to send the whole transport stream across
the network to another PC, but I can't get this to work.  If I do
something like this:

  dvbstream -f 226500 -gi 16 -bw 7 512 650

Then it works fine, I get video and audio on the other PC and about
500kB/sec network use, but if I do this:

  dvbstream -f 226500 -gi 16 -bw 7 8192

Then the network use goes up to 1.7MB/sec but the picture and sound
arrive corrupted, as if I have extremely bad reception.

Using an old version of dvbstream with a Hauppauge Nova-T this works
fine, except in that case I have 3MB/sec of network traffic with the
same channel.  It's almost as if the latest version of dvbstream doesn't
correctly capture the whole MPEG-TS stream from the card.

Has anyone else gotten this to work?

Thanks,
Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
