Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KB23E-0004kf-0j
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 08:30:48 +0200
Message-ID: <9738.212.50.194.254.1214289017.squirrel@webmail.kapsi.fi>
In-Reply-To: <e37d7f810806231158l848f2d3hb160f16db38e71a7@mail.gmail.com>
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
	<4850566E.8030001@iki.fi>
	<e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
	<4850F597.9030603@iki.fi>
	<e37d7f810806120619q28bff0d8y8f2d5319187ab6b0@mail.gmail.com>
	<e37d7f810806171229j72aa07cco5f82e4021317ef8f@mail.gmail.com>
	<9188.212.50.194.254.1213898824.squirrel@webmail.kapsi.fi>
	<e37d7f810806191119h76ef8162ia3dc14b350fcd22c@mail.gmail.com>
	<e37d7f810806230414o7b7d589q71bf6ae5d8c9bc4b@mail.gmail.com>
	<e37d7f810806231158l848f2d3hb160f16db38e71a7@mail.gmail.com>
Date: Tue, 24 Jun 2008 09:30:17 +0300 (EEST)
From: "Antti Palosaari" <crope@iki.fi>
To: "Andrew Websdale" <websdaleandrew@googlemail.com>
MIME-Version: 1.0
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
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

ma 23.6.2008 21:58 Andrew Websdale kirjoitti:
> 2008/6/19 Antti Palosaari <crope@iki.fi>:
>>
>> Looks like small changes to m9206 driver is needed. MT2060 tuner needs
>>>
>>>> IF1, i2c-address and output clock bit (0/1 if I remeber correctly..).
>>>> Those can be seen from windows sniffs or by guessing / testing. IF1 is
>>>> easy to set default one, 1220, wrong IF1 only decreases performance.
>>>> If
>>>> there is eeprom used then value is normally read from there, otherwose
>>>> just set default. clock is easy to test. I don=C2=B4t know how many
>>>> i2c-address
>>>> are supported by chip, but most probably there is not too many.
>>>> Hopefully
>>>> only 4. You can look from specs or from other drivers what
>>>> i2c-addresses
>>>> are used for mt2060. I think it will take 2-10 test to find correct
>>>> values
>>>> by trial and error method.
>>>>
>>>
>>
>> I've tried adding the mt2060 code - it compiles OK & does seem to be
>> nearly
>> right,the tuner is being recognised, but I think loading the module
>> causes
>> the I2c bit of the kernel to Oops - would an incorrect i2c address cause
>> this?
>>
> Here's my dmesg output:
> m920x_mt2060_tuner_attach
> BUG: unable to handle kernel NULL pointer dereference at virtual address
> 0000006c

because you have passed tuner i2c-address as parameter to the dvb_attach()

regards
Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
