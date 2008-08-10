Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KSB0o-0005I2-9v
	for linux-dvb@linuxtv.org; Sun, 10 Aug 2008 15:31:11 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5E0077S06ZLI10@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 10 Aug 2008 09:30:36 -0400 (EDT)
Date: Sun, 10 Aug 2008 09:30:35 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <ee0ad0230808100543g1578d37bqbae9b32def5a9f7f@mail.gmail.com>
To: Damien Morrissey <damien@damienandlaurel.com>
Message-id: <489EED7B.9030905@linuxtv.org>
MIME-version: 1.0
References: <ee0ad0230808100543g1578d37bqbae9b32def5a9f7f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVT-1000S Support Development Assistance Offer
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

Damien Morrissey wrote:
> Dear all,
> I have recently purchased a DTV-1000S before realising it was not 
> supported (for the price I took a punt). However, the card seems good 
> under Windows and I would like to use it with MythTV under linux.
> 
> If anyone out there is working on a driver for this card and I can be of 
> any assistance, please let me know. I run mythbuntu with mythtv 0.21+fixes.

http://www.mail-archive.com/linux-dvb@linuxtv.org/msg27620.html

saa7130 + tda18271 + tda10048.

The kernel has support for all of these, so you need to talk with the 
saa7130 maintainer. With PCI and GPIO details it's possible to make this 
work.

If you haven't done so already, please take some decent close-up 
pictures and ensure the wiki at linuxtv.org is up to date.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
