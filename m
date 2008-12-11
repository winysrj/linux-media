Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <sinter.mann@gmx.de>) id 1LAo5v-00079K-Mb
	for linux-dvb@linuxtv.org; Thu, 11 Dec 2008 17:08:56 +0100
From: sinter <sinter.mann@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 11 Dec 2008 17:06:25 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812111706.25702.sinter.mann@gmx.de>
Subject: [linux-dvb] Technisat Skystar rev 2.8 - application problems with
	the driver
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

There is one problem with that driver revision 2.8:

What you need to reproduce the problem:
- a channels.conf with FTA channels only
- the technisat card Revision 2.8 as the only card in your system
- xine or mplayer
- mtt and / or dvbrowse, which are essential parts of Gerd Knorr's xawtv-4.0 
pre
  which you can download here: http://dl.bytesex.org/cvs-
snapshots/xawtv-20081014-100645.tar.gz

You can reproduce the problem with the following procedure:
1. Either start mplayer dvb:// or xine dvb:// (the "master application")
2. Start mtt after successfully compiling xawtv-4.0 pre (the "slave 
application")

Then please zap on / change channel using mplayer or xine.

Under normal conditions mtt should stop now and wait as "slave application" 
for the
"master application" to tune a new channel.
If that new channel has been tuned correctly mtt should continue and show the 
new videotext.

But what happens instead is the following:
mtt stops and waits for the new channel, but for unknown reasons the new 
channel is not being tuned.
The consequence are the typical timeout-based errors known from xine or 
mplayer.
Zapping is only successful if mtt as videotext application is not involved at 
all parallely.

Question:
Can someone please reproduce this problem / error?
Can someone please offer a fix for that problem?

A thousand thanks

sinter


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
