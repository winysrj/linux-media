Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47D735F4.2070303@linuxtv.org>
Date: Tue, 11 Mar 2008 21:46:28 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>	<47D49309.8020607@linuxtv.org>	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>	<47D4B8D0.9090401@linuxtv.org>	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>	<47D539E8.6060204@linuxtv.org>	<abf3e5070803101415g79c1f4a6m9b7467a0e6590348@mail.gmail.com>	<47D5AF38.90600@iki.fi>	<abf3e5070803111405v5d65d531mbff0649df14226d3@mail.gmail.com>	<37219a840803111625x3079e56apf38b7122979fc11d@mail.gmail.com>
	<abf3e5070803111708k5dcee77ay166fc4bcf7c97711@mail.gmail.com>
In-Reply-To: <abf3e5070803111708k5dcee77ay166fc4bcf7c97711@mail.gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
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

Jarryd Beck wrote:
>>  One thing I can say -- the Linux tda18271 driver should be able to
>>  detect your tuner at 0xC0  (0x60)  as a tda18271c1 -- It's worth a
>>  try, and could certainly be possible that the driver *may* work as-is,
>>  although I suspect that some tweaking will be needed.
>>
>>  Regards,
>>
>>  Mike
>>
> 
> I changed it's i2c as loaded by af9015 to 0xC0, then got this in
> dmesg:
> 
> TDA18271HD/C1 detected @ 5-00c0
> 
> Also when I plugged it in, it sat there for about 10 seconds before
> finishing loading (dmesg printed another 5 lines about the device
> after about 10 seconds), but still no tuning.

Can I see those five lines?  ;-)

While you're at it, you may as well include dmesg from the point that the bridge driver loads and on.

I don't know how the AF9015 works, but Antti does.  What demod is on this device? ...or is that part of the AF9015?

After googling some more, I found that the tda18211 supports DVB-T, ATSC and QAM ...  Seems to be a digital-only tuner, while the tda18271 supports both digital and analog.

The IF frequencies used for the tda18211 are the same as the default settings for the tda18271c1.

- QAM: IF output centered at 4 and 5 MHz (bandwidth = 6 and 8 MHz respectively)
- DVB-T: IF output centered at 3.3, 3.8 and 4.3 MHz (bandwidth = 6, 7 and 8MHz respectively)
- ATSC: IF output centered at 3.25 MHz (bandwidth = 6MHz)

...I am looking at the snoop log some more -- My earlier statement was wrong -- I *do* see the driver programming all 39 registers, and now I do see calibration transactions taking place.

I can see from this snoop that the value that belongs in the linux driver's "std_bits" parameter should be 0x19.  It looks like the windows driver starts off with 0x18, and after some wiggling, locks at 0x19.   Maybe it is first trying to tune to a 7 MHz DVB-T channel, then changes to 8 MHz.

You said that you tuned to "channel 7, sydney, australia" -- is that an 8 MHz channel?  What frequency is it on?

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
