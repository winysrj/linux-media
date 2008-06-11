Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <egor.shibeko@gmail.com>) id 1K6W7c-0004eA-C8
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 21:36:40 +0200
Received: by fg-out-1718.google.com with SMTP id e21so2300007fga.25
	for <linux-dvb@linuxtv.org>; Wed, 11 Jun 2008 12:36:36 -0700 (PDT)
Date: Wed, 11 Jun 2008 22:38:40 +0000
From: Egor Shibeko <egor.shibeko@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20080611223840.2b0f4a8d@err0r.cosmostv.by>
Mime-Version: 1.0
Subject: [linux-dvb] Descrambles from time to time
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

I have access to the host with DVB-S and CA module. If required, I
could provide more information tomorrow. My application (I used
libdvben50221) shows scrambled channels, gnutv
does it too. Problem is both of them sometimes don't descramble the
channels (or at least it looks like that). In this case you could
restart it several times and it would descramble channels again.
I tried to use kaffeine (0.8.3), and it doesn't descramble channels at
all, but it's ok with not-scrambled channels. I tried MythTV ('cause it
had its own implementation for descrambling) but I had no success
with it yet.

The main question is if I could know what's the problem in? Is it in
device, driver, library or application?

Thank You
--
Egor Shibeko

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
