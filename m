Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KF3wn-0002dg-9f
	for linux-dvb@linuxtv.org; Sat, 05 Jul 2008 11:20:50 +0200
Message-ID: <486F3CEA.1030903@iki.fi>
Date: Sat, 05 Jul 2008 12:20:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Websdale <websdaleandrew@googlemail.com>
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>	<e37d7f810806120619q28bff0d8y8f2d5319187ab6b0@mail.gmail.com>	<e37d7f810806171229j72aa07cco5f82e4021317ef8f@mail.gmail.com>	<9188.212.50.194.254.1213898824.squirrel@webmail.kapsi.fi>	<e37d7f810806191119h76ef8162ia3dc14b350fcd22c@mail.gmail.com>	<e37d7f810806230414o7b7d589q71bf6ae5d8c9bc4b@mail.gmail.com>	<e37d7f810806231158l848f2d3hb160f16db38e71a7@mail.gmail.com>	<9738.212.50.194.254.1214289017.squirrel@webmail.kapsi.fi>	<e37d7f810806241209y6b1c3e0dn61048cc58922bc68@mail.gmail.com>	<e37d7f810806251528w738f3d20sdf6f1e35d487e1e0@mail.gmail.com>
	<e37d7f810807041613haf8c091q4afa56673a07f5b7@mail.gmail.com>
In-Reply-To: <e37d7f810807041613haf8c091q4afa56673a07f5b7@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
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

Andrew Websdale wrote:
> 
> I can report some (limited) success with the m920x driver. It seems to 
> be trying to tune when I scan, although no locks on any channels, but it 
> may just be that I've got a poor signal. When trying Kaffeine there is 
> some fluctuation from the signal & SNR meters, & there is this output in 
> syslog:
> Jul  4 23:43:33 toshiba kernel: MT2060: IF1: 1220MHz
> Jul  4 23:43:33 toshiba kernel: MT2060: PLL freq=537833kHz  
> f_lo1=1757750kHz  f_lo2=1183750kHz
> Jul  4 23:43:33 toshiba kernel: MT2060: PLL div1=109  num1=55  div2=73  
> num2=8064
> Jul  4 23:43:33 toshiba kernel: MT2060: PLL [1..5]: 5d 6d 30 f8 93
> Jul  4 23:43:34 toshiba kernel: MT2060: IF1: 1220MHz
> Jul  4 23:43:34 toshiba kernel: MT2060: PLL freq=537833kHz  
> f_lo1=1757750kHz  f_lo2=1183750kHz
> Jul  4 23:43:34 toshiba kernel: MT2060: PLL div1=109  num1=55  div2=73  
> num2=8064
> Jul  4 23:43:34 toshiba kernel: MT2060: PLL [1..5]: 5d 6d 30 f8 93
> 
> and so on...
> 
> However, the LED still doesn't light (does that indicate a bigger 
> problem than just the LED?) and I've still to get a video signal. I 
> shall try to test it on a known good signal, as there are things 
> interfering with my TV signal right now.
> But it looks pretty hopeful - is there anything you can tell me about 
> maximising the signal etc?
> I've attached my version of m920x.c
> regards Andrew

There is two kind of LEDs in those sticks. One is power LED that lights 
all the time when device is powered and the other lock LED that lights 
only when demodulator is locked to the valid channel. I assume your 
device has lock LED that should light only when device is locked to the 
valid channel. Controlling LEDs is sometimes possible by the driver 
software and sometimes not at all. Don't care LED before device is not 
working.

I think it is better to strong known good signal and test device against 
it to see if everything is almost right. After that you can try to find 
settings to reach better receiving sensitivity.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
