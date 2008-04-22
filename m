Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout01.t-online.de ([194.25.134.80])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JoPR7-0007cy-TR
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 22:50:02 +0200
Message-ID: <480E4F61.10208@t-online.de>
Date: Tue, 22 Apr 2008 22:49:37 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>		<200804130349.15215@orion.escape-edv.de>	<4801DED3.4020804@elfarto.com>		<4803C2FA.1010408@hot.ee>
	<48065CB6.50709@elfarto.com>		<1208422406.12385.295.camel@rommel.snap.tv>		<34260.217.8.27.117.1208427888.squirrel@webmail.elfarto.com>		<4807AFE2.40400@t-online.de>
	<4807B386.1050109@elfarto.com>		<4807C1A6.8000909@t-online.de>	<1208862469.7807.7.camel@rommel.snap.tv>
	<480E0575.1010908@gmail.com>
In-Reply-To: <480E0575.1010908@gmail.com>
Subject: Re: [linux-dvb] TT-Budget C-1501
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

hi,

e9hack schrieb:
> Sigmund Augdal schrieb:
>> tor, 17.04.2008 kl. 23.31 +0200, skrev Hartmut Hackmann:
>> <snip>
>>> Do you have a datasheet of the tda10023? From the first glance, i have =
the
>>> impression that it was only used with a conventional tuner yet. With the
>>> silicon tuner, the chip needs to be programmed to use a different IF. We
>>> beed to find out how this is done.
>> I don't have any datasheet. I tried playing around with some of the
>> values in the init-tab, and they do affect the signal levels (signal and
>> snr) reported, but I haven't managed to find something that does give a
>> lock. There is also a if_freq variable in the current driver sources
>> that does not seem to be passed to the chip directly but is used in some
>> computations. In the current driver this value is selected based on
>> channel bandwidth (being only used for dvb-t this far). I've tried with
>> several values for this (8MHz, 0MHz, 4MHz and the currently used 5MHz
>> for 8MHz bandwidth channels).
>>
>> Birr: Do you have any info on this, as you seem to be the last developer
>> working on that demod?
> =

> I don't own the datasheet of the TDA10023. I think you must read the conf=
iguration of the =

> TDA10023 from windows. This can be done with this program =

> (http://linuxtv.org/downloads/saa7146dump-0.2.zip). If it is necessary to=
 monitor the =

> initialization of the tuner chip, you must use an i2c-monitor. I develope=
d a cheap monitor =

> (http://www.vdr-portal.de/board/thread.php?postid=3D639818#post639818). T=
he costs of the =

> parts are less then 10=A4. To build such a monitor, you should know what =
a soldering-iron is.
> =

> -Hartmut Birr
> =

Looks like we need to make changes in both, tda827x and tda10023. Currently=
 the 10023
is programmed for 36.13MHz IF frequency. This is *not* possible with the 82=
7x.
So we need to implement a configuration option for the tda10023 to select t=
he IF center
frequency (haven't had the time to have a close look yet) and we need to im=
plement a way
to let the tda827x driver choose the right parameter set.
I would be more interested in the configuration of the tda10023. With the t=
da827x, i know
what to do.

Hartmut


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
