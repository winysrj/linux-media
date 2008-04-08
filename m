Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.251])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <chelta@gmail.com>) id 1Jj3Q0-0001rp-Ps
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 04:18:41 +0200
Received: by an-out-0708.google.com with SMTP id d18so430219and.125
	for <linux-dvb@linuxtv.org>; Mon, 07 Apr 2008 19:18:26 -0700 (PDT)
Message-ID: <18b099ea0804071918n6fe3d5d4n4c76b6e7e2e8f220@mail.gmail.com>
Date: Tue, 8 Apr 2008 11:48:26 +0930
From: "Melissa Carley" <chelta@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] DigitalNow TinyTwin USB Tuner
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

Hi All,
First time on the mailing list - and this may seem like a pretty dumb
question - but i'm having problems installing the drivers for the
DigitalNow TInyTwin USB tuner.

My system is Gentoo, running 2.6.24 kernel. I have downloaded the
drivers I believe to be accurate
(http://linuxtv.org/hg/~anttip/af9015/) via hg clone, and have done a
make & make install on them from my system.

They do not appear in the kernel (I'm not sure if they are meant to?)
and I cannot find them in /lib/modules/<kernelversion> at all.

Again, this might seem dumb - but has any one had any luck with
getting this working, and if so can you advise me on a type of
step-by-step procedure?

This is my current output from lsusb:
Bus 003 Device 003: ID 045e:00dd Microsoft Corp (Keyboard)
Bus 003 Device 002: ID 03f0:2f11 Hewlett-Packard (Printer)
Bus 002 Device 002: ID 058f:6377 Alcor Micro Corp (SD Card Reader I believe)
Bus 002 Device 003: ID 13d3:3226 IMC Networks (I think this is meant
to be the USB stick?)

Thanks!

Melissa

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
