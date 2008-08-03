Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ma3oxuct@gmail.com>) id 1KPiAC-0001B3-UH
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 20:18:42 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1559453wfd.17
	for <linux-dvb@linuxtv.org>; Sun, 03 Aug 2008 11:18:35 -0700 (PDT)
Message-ID: <350fc7cf0808031118p2ded004dk5c3d160775abc272@mail.gmail.com>
Date: Sun, 3 Aug 2008 11:18:35 -0700
From: "Andrey Falko" <ma3oxuct@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Need advice for HVR-1800
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

I suspect that my HVR-1800 has a hardware defect where, it can't get
signals via ATSC or NTSC. Before I send it back, I'd like to know if
I'm doing something wrong or if I'm missing something. I've never had
or played with a tuner card.

First, I get my kernel to support the card by compiling the cx23885
module. After modprobing cx23885, I get /dev/dvb/adapter0/ folder as
well as a /dev/v4l folder containing video0 and video1.

The next thing I did was try dvbscan
/usr/share/dvb/atsc/us-CA-SF-Bay-Area . I am located in the Bay Area.
I tried some other files in that directory, but none of them was able
to tune to a frequency.

Next, I tried running w_scan -a 0, this gave me the following output:

w_scan version 20060902
-_-_-_-_ Getting frontend capabilities-_-_-_-_
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!
dumping lists (0 services)
Done.

I then tried dtvsignal from pcHDTV, it gave me this output:

# ./dtvsignal -dvb 0
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 57000000 Hz
video pid 0x0021, audio pid 0x0024
dtvsignal ver 1.0.7 - by Jack Kelliher (c) 2002-2007
channel = 2 freq = 57000000Hz
 30db       0%         25%         50%         75%        100%
Signal:     |     .     :     .     |     ._____:_____._____|
Signal: 000 .

The HVR-1800 had two ports, an ATSC and TV Cable. I tried both w_scan
and dtvsignal over both ports. I also tried to different cables with
each.

If I tell mplayer to use analog tv, I get a green screen. VLC gives me
static. Without channels.conf mplayer should not play dtv. VLC
reported that it could not tune.

Unfortunately for debugging purposes I don't have either a Windows OS
nor a TV that I can hook up.

Should I buy an antenna? Return this card? Or is there something else
I can try or something that I am missing?

Thank you in advance for any help.

-Andrey

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
