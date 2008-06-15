Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <psofa.psofa@gmail.com>) id 1K7xxh-00065Q-Of
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 21:32:26 +0200
Received: by rv-out-0506.google.com with SMTP id b25so6168481rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 15 Jun 2008 12:31:44 -0700 (PDT)
Message-ID: <8e485a510806151231m356b630aldcba7f170127120b@mail.gmail.com>
Date: Sun, 15 Jun 2008 22:31:44 +0300
From: psofa <psofa.psofa@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : No lock possible at some DVB-S2 channels with
	TT S2-3200/linux
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

The patch didnt do anything for me either.
For me the no lock possible applies to dvb-s transpoders as well.
(solvable by +4mhz)
Id like to add that even when i manage to tune with a +4mhz offset,
the signal isnt as good as my stb.
For example the stb shows 60% signal and obviously plays the stream perfectly,
while the card throws macroblocks all over and sometimes even freezes.

I wonder if everyone with that card has problems or just the 4-5 people ive
seen mentioning it in this list.
(im sorry in advance if i did anything retarded with the mailing list... :) )

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
