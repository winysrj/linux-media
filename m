Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KlXLh-0004Lu-EM
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 01:12:46 +0200
Message-ID: <48E55565.7030703@iki.fi>
Date: Fri, 03 Oct 2008 02:12:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Websdale <websdaleandrew@googlemail.com>
References: <e37d7f810810021333j79a2469draaed9c0858bbc516@mail.gmail.com>
In-Reply-To: <e37d7f810810021333j79a2469draaed9c0858bbc516@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DPosh m9206 USB DVB-T stick with MT2060
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

hello
Andrew Websdale wrote:
>      Some time ago I had a brief correspondence on here with Antii
> about adding support for the MT2060 tuner to the DPosh driver( there's
> recently been a load of these on sale in several places for 10 GBP
> ish). I had a go at hacking something together, which although
> definitely poorly written, did appear to work. However, my signal at
> home is currently just not quite good enough to test it properly, so I
> let the matter rest for the moment.
>      Then I was contacted by a guy who'd bought the same stick & been
> following my posts - he tried it & is definitely receiving TV
> stations(with plenty of room for improvement), so it seems that its
> worth going further with it.
>       I've attached a diff of m920x.c -  I'd like some help with a)the
> correct mechanism for detecting which tuner chip is present (i.e.
> QT1010/MT2060) , b) what to tweak to improve output quality & c)
> whether my whole approach is wrong or what?- I have no experience of
> driver programming or C, though I know a little about C++ app
> development. Hugh (the guy with another DPosh stick) will be able to
> test any changes as will I (if I can improve my Freeview signal).
> Regards Andrew Websdale

You can first try to attach qt1010 tuner and if it fails (it will fail 
if there is no qt1010) you can secondly try to attach mt2060 tuner. 
There is some examples in current drivers how to do that. Look anysee.c 
for example.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
