Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47DA01B3.8050502@iki.fi>
Date: Fri, 14 Mar 2008 06:40:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47D847AC.9070803@linuxtv.org>	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>	<47D86336.2070200@iki.fi>	<abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>	<abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>	<47D9C33E.6090503@iki.fi>	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>	<47D9EED4.8090303@linuxtv.org>	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>
	<abf3e5070803132033x13ac35fax38fc427ce1e0a040@mail.gmail.com>
In-Reply-To: <abf3e5070803132033x13ac35fax38fc427ce1e0a040@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
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
> Somewhere along the way demod_address in a struct is set to AF9015_I2C_DEMOD
> which is 0x38. Is that what you wanted?

No, it is demodulator i2c-address.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
