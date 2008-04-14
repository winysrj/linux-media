Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout03.t-online.de ([194.25.134.81])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JlYAM-0007T1-5J
	for linux-dvb@linuxtv.org; Tue, 15 Apr 2008 01:32:52 +0200
Message-ID: <4803E9A2.30804@t-online.de>
Date: Tue, 15 Apr 2008 01:32:50 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: LInux DVB <linux-dvb@linuxtv.org>, Oliver Endriss <o.endriss@gmx.de>
Subject: [linux-dvb] tda10086: Testers wanted
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

Hi, folks

In my personal repository at
http://linuxtv.org/hg/~hhackmann/v4l-dvb/
there are 2 changes that affect all DVB-S cards with tda10086
- The reference frequency (crystal) of the tda10086 now is an option
   of the tda10086_config struct. This is necessary i.e. for cards with the
   SD1878 tuner.
   I adapted the driver for these boards:
    - TT Budget-S-1401
    - Pinnacle 400e / Technotrend USB
    - Lifeview Flydvb Trio
    - Medion MD8800
    - Lifeview Flydvbs LR300
    - Philips Snake
    - MD7134 (Bridge 2 - works now)

- The bandwidth of the tda826x baseband filter is now set according to the
   expected symbol rate. The boards with this tuner now should work with
   transponders providing a higher symbol rate than usual.
   This patch was provided by Oliver Endriss.

I tried to make the changes backward compatibe but since i can't test these
cards, i need your feedback.

Oliver: there was no signature in your patch. But of corse i mentioned you
in the log. I hope that's ok for you.

Have fun
   Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
