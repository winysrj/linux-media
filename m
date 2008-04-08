Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [66.180.172.116] (helo=vps1.tull.net)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nick-linuxtv@nick-andrew.net>) id 1Jj5r9-0000Gt-Hb
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 06:54:56 +0200
Date: Tue, 8 Apr 2008 14:54:24 +1000
From: Nick Andrew <nick-linuxtv@nick-andrew.net>
To: Melissa Carley <chelta@gmail.com>
Message-ID: <20080408045424.GA13098@tull.net>
References: <18b099ea0804071918n6fe3d5d4n4c76b6e7e2e8f220@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
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

G'day Melissa,

On Tue, Apr 08, 2008 at 11:48:26AM +0930, Melissa Carley wrote:
> My system is Gentoo, running 2.6.24 kernel. I have downloaded the
> drivers I believe to be accurate
> (http://linuxtv.org/hg/~anttip/af9015/) via hg clone, and have done a
> make & make install on them from my system.

I'm afraid this driver doesn't yet work for this device.

> They do not appear in the kernel (I'm not sure if they are meant to?)
> and I cannot find them in /lib/modules/<kernelversion> at all.

You would normally do 'make install' as root to copy the modules
from your build directory to below /lib/modules/<kernelversion>
but there's not much point doing that at this time, because the
driver doesn't work with the TinyTwin device yet.

You can also insmod from the build directory, i.e.

insmod ./v4l/dvb-core.ko
insmod ./v4l/dvb-pll.ko
insmod ./v4l/dvb-usb.ko
insmod ./v4l/dvb-af901x.ko

> Again, this might seem dumb - but has any one had any luck with
> getting this working, and if so can you advise me on a type of
> step-by-step procedure?

You're doing the correct thing.

> Bus 002 Device 003: ID 13d3:3226 IMC Networks (I think this is meant
> to be the USB stick?)

Yes, this is the one.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
