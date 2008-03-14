Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47DAC42D.7010306@iki.fi>
Date: Fri, 14 Mar 2008 20:30:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47D847AC.9070803@linuxtv.org>	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>	<47D86336.2070200@iki.fi>	<abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>	<abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>	<47D9C33E.6090503@iki.fi>	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>	<47D9EED4.8090303@linuxtv.org>	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>	<47DA0F01.8010707@iki.fi>
	<47DA7008.8010404@linuxtv.org>
In-Reply-To: <47DA7008.8010404@linuxtv.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org
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

Michael Krufky wrote:
> 4.3 is not close enough to 3.8.  If you don't know how to set the demod
> to 3.8, then we can do some hacks to make it work, but signal reception
> is likely to be very poor -- better off looking in his snoop log to see
> how the windows driver sets the demod to 3.8

OI have looked sniffs and tested linux driver and found that it is set 
to 3800. There is 4300 kHz set in eeprom, it is ok for 8 MHz but not for 
6 or 7. Looks like driver needs to do some quirks when this tuner is 
used. Anyhow, patch attached is hardcoded to use 3.8 now.

Jarryd, please test. Also some changes to stick plug done, if it does 
not work for you can fix it as earlier.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
