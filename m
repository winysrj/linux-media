Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.server.beonex.com ([78.46.195.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux.news@bucksch.org>) id 1LSJ30-0005jx-5O
	for linux-dvb@linuxtv.org; Wed, 28 Jan 2009 23:38:15 +0100
Message-ID: <4980DE90.5050906@bucksch.org>
Date: Wed, 28 Jan 2009 23:39:12 +0100
From: Ben Bucksch <linux.news@bucksch.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technisat SkyStar HD + CI + AlphaCrypt says "PC card
	did not respond"
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

Hardware:
- DVB-S2: TechniSat SkyStar HD = Technotrend S2-3200
- CI: With corresponding CI
- CA: AlphaCrypt Light
- Pay-TV smartcard
Software:
- Ubuntu 8.04
- (A) Linux 2.6.28 with S2API drivers
- (B) Linux 2.6.27-rc5 with multiproto drivers (hg 855d0c878944)
- (C) Linux 2.6.23.1 with multiproto driver (20071118)
- gnutv

I keep getting "dvb_ca adaptor 0: PC card did not respond :(" on 
/var/log/syslog

I purchased a new AlphaCrypt and new CI (!), but still same problem :(

It used to work, I could record even encrypted HD movies with this card 
and older multiproto drivers (C) and another distro (Gentoo) about one 
year ago.

I'm puzzled and don't know what to do anymore. I have excluded almost 
all possibilities. Only remaining factors could be DVB card, smartcard, 
and distro.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
