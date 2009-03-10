Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1-hoer.fullrate.dk ([90.185.1.42] helo=smtp.fullrate.dk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rasmus@akvaservice.dk>) id 1LhBFb-0008Bx-BZ
	for linux-dvb@linuxtv.org; Wed, 11 Mar 2009 00:20:44 +0100
Received: from [10.0.0.11] (3703ds1-sg.0.fullrate.dk [90.184.225.237])
	by smtp.fullrate.dk (Postfix) with ESMTP id BA5E49CD36
	for <linux-dvb@linuxtv.org>; Wed, 11 Mar 2009 00:19:47 +0100 (CET)
From: Rasmus Pedersen <rasmus@akvaservice.dk>
To: linux-dvb@linuxtv.org
Date: Wed, 11 Mar 2009 00:19:47 +0100
Message-Id: <1236727187.8238.17.camel@SailCat>
Mime-Version: 1.0
Subject: [linux-dvb] KNC1
Reply-To: linux-media@vger.kernel.org, rasmus@akvaservice.dk
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

I've got some problems getting my KNC1 DVB-C working correctly.

The card is found correctly as

DVB: registering new adapter (KNC1 DVB-C MK3)
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)

I also have a CAM connected with an irdeto card installed. Syslog tells
me that its been succesfullay detected.

dvb_ca adapter 0: DVB CAM detected and initialised successfully

I can view non-encrypted/encrypted channels when using Kaffeine,
everything is working perfectly. 

My problem is that I want to record tv from the consol (I'm working on
script that can record television and expose it thru mediatomb to be
played on my PS3), and Kaffeine does not run without its UI.

I have tried mplayer and xine, but I quickly found that neither of them
has the abilty to decrypt using the attached CAM. So I went onto try
gnutv, and thats where my problems really start.

When I start gnutv like this.

./gnutv -caslotnum 0 -out file test.ts -channels channels.conf "Kanal 5"

I get this error in syslog.

DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x2a, val ==
0x02, ret == -121)

gnutv outputs this to console:

CAM Application type: 01
CAM Application manufacturer: cafe
CAM Manufacturer code: babe
CAM Menu string: Irdeto Access

And nothing else.

The stream saved to test.ts has no video, so I presume gnutv does not
decrypt the video stream.

./gnutv -cammenu works fine, and I can access the cam information using
it.

The problem is also there when using zap and dvbstreamer. I have not yet
tried mythtv or vdr, since I was hoping for a simpler solution using
gnutv or similar software to just dump the stream to disk (decrypted
ofcourse). 

I have installed latest v4l drivers from CSV and alos latest dvbapps
from CSV.

I hope somebody might now what the problem could be..

Regards,
Rasmus Pedersen


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
