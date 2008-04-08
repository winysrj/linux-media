Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jj6Dr-000208-5Q
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 07:18:21 +0200
Message-ID: <47FAFFF9.6090902@iki.fi>
Date: Tue, 08 Apr 2008 08:17:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Melissa Carley <chelta@gmail.com>
References: <18b099ea0804071918n6fe3d5d4n4c76b6e7e2e8f220@mail.gmail.com>
In-Reply-To: <18b099ea0804071918n6fe3d5d4n4c76b6e7e2e8f220@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DigitalNow TinyTwin USB Tuner
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

heissan,

Melissa Carley wrote:
> Hi All,
> First time on the mailing list - and this may seem like a pretty dumb
> question - but i'm having problems installing the drivers for the
> DigitalNow TInyTwin USB tuner.
> 
> My system is Gentoo, running 2.6.24 kernel. I have downloaded the
> drivers I believe to be accurate
> (http://linuxtv.org/hg/~anttip/af9015/) via hg clone, and have done a
> make & make install on them from my system.
> 
> They do not appear in the kernel (I'm not sure if they are meant to?)
> and I cannot find them in /lib/modules/<kernelversion> at all.
> 
> Again, this might seem dumb - but has any one had any luck with
> getting this working, and if so can you advise me on a type of
> step-by-step procedure?

It should be detected by driver and frontend is also created but it will 
not still work. Tuning fails always. Your device has MXL5005 tuner that 
is not working yet with this driver. MXL5003 devices are working and 
thats why I think there is only minor configuration error, probably 
wrong GPIO or wrong tuner settings.
I can fix this in small time if you or someone else can take USB-sniff 
from Windows.

> This is my current output from lsusb:
> Bus 003 Device 003: ID 045e:00dd Microsoft Corp (Keyboard)
> Bus 003 Device 002: ID 03f0:2f11 Hewlett-Packard (Printer)
> Bus 002 Device 002: ID 058f:6377 Alcor Micro Corp (SD Card Reader I believe)
> Bus 002 Device 003: ID 13d3:3226 IMC Networks (I think this is meant
> to be the USB stick?)

Yes, that it is. Also dmesg-command will show a lot information from 
device after it is plugged.

> Thanks!
> 
> Melissa

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
