Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JSpYO-00082D-FD
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 09:16:16 +0100
Received: from berkeloid.vlook.shikadi.net ([192.168.4.11])
	by vitalin.sorra.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JSpYI-0004Rg-Nm
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 18:16:10 +1000
Received: from korath.teln.shikadi.net ([192.168.0.14])
	by berkeloid.teln.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JSpYH-0004Q0-UN
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 18:16:09 +1000
Message-ID: <47BFD5F4.3030805@shikadi.net>
Date: Sat, 23 Feb 2008 18:14:44 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Is there a daemon style program for scheduled DVB
	recording?
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

I'm currently setting up a new server that will (among other things)
record TV shows for me.  In the past I've used cron to schedule
recording jobs, and I've used dvbrecord to do the actual recording.

This set up has served me well for many years, but unfortunately
dvbrecord doesn't seem to exist any more, and it never supported
programs with AC3 audio anyway (which is pretty much all the HDTV
channels here in Australia.)

If you were setting up a headless machine to record TV shows, what
programs would you use to do this?  Ideally I'd like the shows dumped
into a local directory, so that I can watch them over NFS with mplayer,
but I'm open to alternatives.

I really want to avoid running a whole "media centre" program like
MythTV, VDR, etc. as I'd like this to be lean and clean and I don't mind
using the command line for playback.

Any suggestions?  I'd be happy to document the final system,
installation, configuration, etc. on the LinuxTV wiki, as I couldn't
find any info about this sort of thing on there at the moment.

Many thanks,
Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
