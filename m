Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Hartmut.Niemann@gmx.de>) id 1LFmC0-0003bB-7n
	for linux-dvb@linuxtv.org; Thu, 25 Dec 2008 10:07:45 +0100
From: Hartmut Niemann <Hartmut.Niemann@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Dec 2008 09:41:48 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812250941.48449.Hartmut.Niemann@gmx.de>
Subject: [linux-dvb] cx88 (Hauppauge Nova-S-Plus DVB-S) occasionally skips,
	kaffeine says: EIT (0:0): buffer overflow! Rejected
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

Hello!
With debian stable (kernel 2.6.24-etchnhalf.1-686 #1 SMP) on AMD Athlon(tm) XP 2600+, 
MSI KT4AV (VIA KT400)
my Hauppauge Nova-S-Plus DVB-S does not work well.
When I record DVB-S with kaffeine (0.8.3), it loses parts of the stream and spits out
  EIT (0:0): buffer overflow! Rejected
  Stop parsing EIT (0:0)
(about 60 times during a  1,5 h recording)
and now and then a few seconds of the film seem to be missing.

It doesn't crash, though.

The same seems to happen when viewing.

I believe this is a regression, because when I set up the system some time ago,
it worked far better than now.

Is this a known problem?
Would a dist upgrade to debian testing help?

I can't believe that my system is too slow for recording (on an 
otherwise idle X desktop / KDE).

With best regards
Hartmut Niemann

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
