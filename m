Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K9OXN-0007Iw-UT
	for linux-dvb@linuxtv.org; Thu, 19 Jun 2008 20:07:12 +0200
Message-ID: <9188.212.50.194.254.1213898824.squirrel@webmail.kapsi.fi>
In-Reply-To: <e37d7f810806171229j72aa07cco5f82e4021317ef8f@mail.gmail.com>
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
	<4850566E.8030001@iki.fi>
	<e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
	<4850F597.9030603@iki.fi>
	<e37d7f810806120619q28bff0d8y8f2d5319187ab6b0@mail.gmail.com>
	<e37d7f810806171229j72aa07cco5f82e4021317ef8f@mail.gmail.com>
Date: Thu, 19 Jun 2008 21:07:04 +0300 (EEST)
From: "Antti Palosaari" <crope@iki.fi>
To: "Andrew Websdale" <websdaleandrew@googlemail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

ti 17.6.2008 22:29 Andrew Websdale kirjoitti:
> 2008/6/12 Andrew Websdale
>> 2008/6/12 Antti Palosaari <crope@iki.fi>:
>> wrote:
>>
>>> OK, then the reason might by tuner. Tuner may be changed to other one
>>> or
>>> tuner i2c-address is changed. I doubt whole tuner is changed. Now we
>>> should
>>> identify which tuner is used. There is some ways how to do that.
>>>
>>> 1) Look from Windows driver files
>>> 2) Open stick and look chips
>>> 3) Take USB-sniffs and try to identify tuner from there
>>
>>
> I've opened the stick & there's an MT352 (as expected) but the other chip
> is
> an MT2060 which is the tuner, I think, as I see that there's an 'mt2060'
> module in the tuner module directory. Is there some modification I can do
> to
> the code so that it gets picked up by the driver? - I know a bit of C++
> app
> programming but I'm very new to C driver code, but would like to learn
> more.
> Hopefully I can help some others who have this chipset as well.....
> regards Andrew

Looks like small changes to m9206 driver is needed. MT2060 tuner needs
IF1, i2c-address and output clock bit (0/1 if I remeber correctly..).
Those can be seen from windows sniffs or by guessing / testing. IF1 is
easy to set default one, 1220, wrong IF1 only decreases performance. If
there is eeprom used then value is normally read from there, otherwose
just set default. clock is easy to test. I don=B4t know how many i2c-address
are supported by chip, but most probably there is not too many. Hopefully
only 4. You can look from specs or from other drivers what i2c-addresses
are used for mt2060. I think it will take 2-10 test to find correct values
by trial and error method.

I am now on holiday trip, but next week - monday or tuesday I can fix that
driver that if anyone else haven=B4t done already.

regards
Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
