Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JZEWV-0008D2-8M
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 01:08:56 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1207881tia.13
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 17:08:39 -0700 (PDT)
Message-ID: <abf3e5070803111708k5dcee77ay166fc4bcf7c97711@mail.gmail.com>
Date: Wed, 12 Mar 2008 11:08:39 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840803111625x3079e56apf38b7122979fc11d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
	<47D49309.8020607@linuxtv.org>
	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>
	<47D4B8D0.9090401@linuxtv.org>
	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
	<47D539E8.6060204@linuxtv.org>
	<abf3e5070803101415g79c1f4a6m9b7467a0e6590348@mail.gmail.com>
	<47D5AF38.90600@iki.fi>
	<abf3e5070803111405v5d65d531mbff0649df14226d3@mail.gmail.com>
	<37219a840803111625x3079e56apf38b7122979fc11d@mail.gmail.com>
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

>  One thing I can say -- the Linux tda18271 driver should be able to
>  detect your tuner at 0xC0  (0x60)  as a tda18271c1 -- It's worth a
>  try, and could certainly be possible that the driver *may* work as-is,
>  although I suspect that some tweaking will be needed.
>
>  Regards,
>
>  Mike
>

I changed it's i2c as loaded by af9015 to 0xC0, then got this in
dmesg:

TDA18271HD/C1 detected @ 5-00c0

Also when I plugged it in, it sat there for about 10 seconds before
finishing loading (dmesg printed another 5 lines about the device
after about 10 seconds), but still no tuning.

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
