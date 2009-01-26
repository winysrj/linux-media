Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LRX0w-0004QH-2E
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 20:21:39 +0100
Received: by ey-out-2122.google.com with SMTP id 25so758778eya.17
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 11:20:50 -0800 (PST)
Date: Mon, 26 Jan 2009 20:20:41 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Marco Bertorello <marco@bertorello.ns0.it>
In-Reply-To: <5dd5976b0901260805k40ea2dbbl5e076fea27bc6765@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901262007500.15738@ybpnyubfg.ybpnyqbznva>
References: <5dd5976b0901260805k40ea2dbbl5e076fea27bc6765@mail.gmail.com>
MIME-Version: 1.0
Cc: DVB mailin' list thang <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] IXIX UsbTV2
Reply-To: linux-media@vger.kernel.org
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

On Mon, 26 Jan 2009, Marco Bertorello wrote:

> have somebody used succesfully this device [1] on GNU/Linux?
> I've tried out on a ubuntu intrepid and seems that it was recognized
> by kernel, in dmesg see em28xx, but kaffeine told me that there isn't
> any DVB interface.

`em28xx' devices are a strange situation.  There exists the
in-kernel drivers, and there exists an out-of-kernel set of
drivers which may have better support for this device.

Perhaps you may have better luck with the drivers which can
be found at mcentral.de .  The author of these drivers can
be found lurking on this list, but there is also a dedicated
mailing list for this driver, and posting to this list
requires you to be a subscriber (though non-subscriber posts
can make it to the list).


In any case, check out what is available at mcentral.de .
It is not as convenient as what may be provided, and in an
ideal world, your OS will provide working drivers for your
device, but this is some time off...


grazie,
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
