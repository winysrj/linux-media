Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cardsharing@hondelink.com>) id 1Ljh8k-00076B-FT
	for linux-dvb@linuxtv.org; Tue, 17 Mar 2009 22:48:03 +0100
Received: from woefpc (kubrick.xs4all.nl [82.95.238.50])
	by smtp-vbr19.xs4all.nl (8.13.8/8.13.8) with ESMTP id n2HLksQ4048495
	for <linux-dvb@linuxtv.org>; Tue, 17 Mar 2009 22:46:59 +0100 (CET)
	(envelope-from cardsharing@hondelink.com)
From: "Maarten Hondelink" <maarten@hondelink.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 17 Mar 2009 22:46:54 +0100
Message-ID: <1EAE808943E247C383BCCC029A3F5204@woefpc>
MIME-Version: 1.0
Subject: [linux-dvb] Rotor not working Skystar hd2(VP1041/STB0899) S2API
	MYTHTV
Reply-To: linux-media@vger.kernel.org
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

Hello,

I hope that someone can help me. Struggling with this for months now!
I have a Skystar HD2 connected to a diseqc 1.2 compatible motorized H-H
rotor and a Smart Titanium 2nd edition LNB. I use the latest S2API drivers
(http://mercurial.intuxication.org/hg/s2-liplianin) and latest sources from
the mythtv svn.

Whatever I do, the rotor will not move in mythtv. It stays on the same
position, although Mythtv indicates that it is moving the rotor.
Reinstalling mythtv, reinstalling the drivers, different OS(Ubuntu instead
of Centos) etc, whatever I do. The thing wont move! Even when shutting down
the mythbackend and running the scan-s2 with -r (move to another position)
and a correct rotor.conf the position does NOT change.
I have the extra power connector connected on the Skystar HD 2. The only way
that DOES work is using the xdipo tool 0.7.3! This one moves the rotor! When
turning on debug, this tool seems to send the diseqc command at least 5-10
times but somehow this works! Could it be a timing issue?

The rotor is not the problem since I also have an older skystar 2 card and
running it under Windows XP with (diseqc 1.2)patched  XP drivers  the rotor
moves to every wanted position without any hesitation. 

What could be wrong here? Someone any ideas?

Regards

Maarten


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
