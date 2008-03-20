Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JcGaL-0007gz-02
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 09:57:17 +0100
Received: from berkeloid.vlook.shikadi.net ([192.168.4.11])
	by vitalin.sorra.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JcGaF-0002Rn-Vj
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 18:57:12 +1000
Received: from korath.teln.shikadi.net ([192.168.0.14])
	by berkeloid.teln.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JcGaF-0005dB-7d
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 18:57:11 +1000
Message-ID: <47E226E7.7030601@shikadi.net>
Date: Thu, 20 Mar 2008 18:57:11 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvbstream reliability issues?
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

Hi all,

I've recently started using dvbstream (instead of dvbrecord) to record
shows using cron but I'm finding it to be very unreliable.

Depending on my reception quality, it has a tendency to segfault fairly
regularly - enough that I wrote a script to reload it after a segfault
so that I wouldn't miss my recording.  With this set up it usually
segfaults once every 15 minutes or so, and sometimes as often as every
4-5 minutes if the reception isn't so great.

Sometimes it doesn't segfault though, it just stops recording for some
reason (the output file only grows by a few bytes a minute.)  This is
worse because it doesn't terminate, so my script isn't able to reload it
to catch the rest of the recording.

For those people using dvbstream to do their recording, are any of you
having issues like this?

I'm running CVS from 2008-02-24 and I'm using -prog to record based on
the program instead of using PIDs (as our broadcasters here seem to
change their PIDs without warning every couple of months.)

I'm hoping there's some easy fix for this, because I'd rather not have
to try to get dvbrecord to work again!

Thanks,
Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
