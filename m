Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L3gEt-0006Sx-RH
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 01:20:44 +0100
Received: by ug-out-1314.google.com with SMTP id x30so270947ugc.16
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 16:20:40 -0800 (PST)
Date: Sat, 22 Nov 2008 01:20:32 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <alpine.DEB.2.00.0811220104130.6304@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Subject: [linux-dvb] Digital switchover (DSO) in the UK
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

(looks at clock, okay, so...)

Two days ago now, the first major steps were taken in the UK
to switch off analogue transmissions.  This means that the
supplied initial scanfiles in dvb-apps scan will start to
have incorrect information.

The biggest change will be from 2k to 8k FFT modulation as
the switchover progresses; additionally, from what I've
read, there may be some frequency changes too.  Other
modulation parameters (16-vs-64QAM and the like) are
unknown to me and not revealed in the limited reading
I've done.

The scanfile for uk-Selkirk is now out-of-date where
accuracy is concerned (perhaps others?  I'm nowhere near
and have no idea), so if someone cares to update this,
and, in the months to come, the other affected transmitter
locations, with current information, then anyone unaware
of DSO who tries to use these scanfiles with a tuner that
doesn't AUTO everything might have more success.


That means you, brave volunteer!

etc,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
