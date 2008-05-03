Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JsKL8-0002l6-EJ
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 18:11:59 +0200
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0K0A0032KVMZTQ40@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Sat, 03 May 2008 19:11:23 +0300 (EEST)
Received: from spam5.suomi.net (spam5.suomi.net [212.50.131.165])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0K0A00FJYVMZV6E0@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Sat, 03 May 2008 19:11:23 +0300 (EEST)
Date: Sat, 03 May 2008 19:11:09 +0300
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <1208945819.7807.16.camel@rommel.snap.tv>
To: Sigmund Augdal <sigmund@snap.tv>
Message-id: <481C8E9D.9030306@iki.fi>
MIME-version: 1.0
References: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>
	<200804130349.15215@orion.escape-edv.de> <4801DED3.4020804@elfarto.com>
	<4803C2FA.1010408@hot.ee> <48065CB6.50709@elfarto.com>
	<1208422406.12385.295.camel@rommel.snap.tv>
	<34260.217.8.27.117.1208427888.squirrel@webmail.elfarto.com>
	<4807AFE2.40400@t-online.de> <4807B386.1050109@elfarto.com>
	<4807C1A6.8000909@t-online.de> <1208862469.7807.7.camel@rommel.snap.tv>
	<480E0575.1010908@gmail.com> <480E4F61.10208@t-online.de>
	<1208945819.7807.16.camel@rommel.snap.tv>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT-Budget C-1501
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

Sigmund Augdal wrote:
> The init-tab part of tda10023.c seems to indicate which posisions are
> which registers in the chip. There are in particular two that are called
> DELTAF_MSB and DELTAF_LSB, which is currently set to 0xFFF0. I guess
> this would be a key thing to change, but what needs to be changed in the
> tuner driver? I've also noticed that when the tda10046 is used with
> tda827x it changes some other parameters in the demod (agc threshold,
> gain and polarities). Do we need to change these in tda10023 also? Or
> could we change tda827x to output what the tda10023 needs?

Probably you want to look current Anysee TDA10023-module. I have put 
some of those registers configurable already.
http://linuxtv.org/hg/~anttip/anysee/

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
