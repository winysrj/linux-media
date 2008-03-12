Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47D86336.2070200@iki.fi>
Date: Thu, 13 Mar 2008 01:11:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47D847AC.9070803@linuxtv.org>
	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>
In-Reply-To: <abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, mkrufky@linuxtv.org
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
> On Thu, Mar 13, 2008 at 8:14 AM,  <mkrufky@linuxtv.org> wrote:
>>  Then, please turn ON debug, repeat your tests, and post again with
>>  dmesg.  I am not familiar with the af9015 driver, but for tda18271, set
>>  debug=1.  (you must unload all modules first -- do 'make unload' in the
>>  v4l-dvb dir, then replug your device)
>>
>>  -Mike
>>
>>
> 
> Sorry I'm unsure where to set debug.
> 
> Jarryd.

I added initial support for this tda-tuner to the driver. Jarryd, can 
you test?
http://linuxtv.org/hg/~anttip/af9015_new/

There is debug switch in af9013 module that may be helpful if it does 
not work. You can enable it as described or if it is too hard to play 
with modprobe just edit af9013.c file in frontend directory and set 
debug=1 by hard coding.
If it does not work you can also try set GPIO3 setting (af9015) to 0xb 
instead 0x3 used currently. Also try to change rf-spectral inversion to 
see if it helps. Firmware should be ok and all other settings as well as 
I can see from usb-sniffs. With little lucky it should start working.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
