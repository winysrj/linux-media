Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <claesl@gmail.com>) id 1JW9cm-0008Ry-Uv
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 13:18:33 +0100
Received: by wr-out-0506.google.com with SMTP id c55so11237751wra.11
	for <linux-dvb@linuxtv.org>; Mon, 03 Mar 2008 04:18:28 -0800 (PST)
Message-ID: <47CBEC8D.4050306@gmail.com>
Date: Mon, 03 Mar 2008 13:18:21 +0100
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] AzureWave VP 1041 DVB-S2 problem
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

Hi, 
I have some problems with my  AzureWave AD-SP400 (VP 1041) card.

Some background info before the problem:
I'm running on a Slamd64 distro with a 2.6.24.2 kernel and I have
the latest code from http://jusst.de/hg/mantis, compiled and installed 
successfully.

Downloaded and built http://jusst.de/manu/scan.tar.bz2 successfully and 
it can scan both DVB-S and DVB-S2.
I then downloaded http://abraham.manu.googlepages.com/szap.c and built 
it according to 
http://www.linuxtv.org/pipermail/linux-dvb/2007-October/021474.html 
without any problems.

Now to the problem itself.
When I run
szap -r -i -a 1 -l UNIVERSAL -t 0 -c channels.conf "The Poker Channel"
and
mplayer /dev/dvb/adapter1/dvr0

mplayer says...

TS file format detected.
VIDEO MPEG2(pid=515) AUDIO MPA(pid=652) NO SUBS (yet)!  PROGRAM N. 0
VIDEO:  MPEG2  544x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0 kbyte/s)


and the picture is shown.

When i run 
szap -r -p -i -a 1 -l UNIVERSAL -t 2 -c channels.conf "SVT HD"
and
mplayer /dev/dvb/adapter1/dvr0

mplayer says

TS file format detected.
VIDEO MPEG2(pid=512) AUDIO MPA(pid=640) NO SUBS (yet)!  PROGRAM N. 0


and nothing else happens. I think it should detect a h264 stream.
I have tested with and without the -p option for szap with the same results.

/dev/adapter1 is a dvbloopback device and I have successfully tuned in to the channel "SVT HD" with h264 stream
on a DVB-C card so the problem must be somewhere in the DVB-S/S2 implementation?

Can anyone give me some hints of what's wrong here?

Regards
/Claes


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
