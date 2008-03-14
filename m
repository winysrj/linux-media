Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1Ja946-00043m-4L
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 13:31:15 +0100
Message-ID: <47DA7008.8010404@linuxtv.org>
Date: Fri, 14 Mar 2008 08:31:04 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47D847AC.9070803@linuxtv.org>	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>	<47D86336.2070200@iki.fi>	<abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>	<abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>	<47D9C33E.6090503@iki.fi>	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>	<47D9EED4.8090303@linuxtv.org>
	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>
	<47DA0F01.8010707@iki.fi>
In-Reply-To: <47DA0F01.8010707@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

Antti Palosaari wrote:
> looks like possible bug found!
>
> Jarryd Beck wrote:
>> On Fri, Mar 14, 2008 at 2:19 PM, Michael Krufky <mkrufky@linuxtv.org>
>> wrote:
>
>>>  This all happens very quickly on the hardware that I've tested ( a
>>>  cx23887-based pcie card and a cypress fx2-based usb device).  I've
>>> also
>>>  heard good reports on saa713x-based pci cards.  Is the i2c slow in the
>>>  af9013 driver?
>
> Just checked from code and it looks like it is 60 kHz currently. It is
> not clear for me how kHz correlates to value written to register so
> let is be this time.
Hmm..  60 kHz compared to 400 kHz is a big difference, but we can deal
with that later.
>
>>>  The tuner driver is programmed to use 7mhz dvbt with IF centered at
>>> 3.8
>>>  mhz -- is the demod set to the same?
>
> hmm, I think there is bug now. I compared eeprom dumps and found that
> my MT2060 has IF1 = 36125 and eeprom of this device says it should be
> IF1 =  4300. Is 4.3 Mhz close enough (we are speaking same thing?)?

4.3 is not close enough to 3.8.  If you don't know how to set the demod
to 3.8, then we can do some hacks to make it work, but signal reception
is likely to be very poor -- better off looking in his snoop log to see
how the windows driver sets the demod to 3.8

>
> Jerryd, change .tuner_if = 36125 to 4300 . It can be found from af9015
> module.
>
>> How do I find out about the demod? Is the speed of af9013 a question for
>> me because I have no idea.
>
> One thing to test speed is also commenting out "program tuner" part
> from af9013 so it does not ask tuner to go frequency. It did not tune
> then.
>
> But, I still needs debug logs of the af9013. Then I can compare much
> more easier usb-sniff and debug values got from driver.
>
> Antti
-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
