Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRjoO-0005oW-H9
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 08:56:16 +0100
Received: from [11.11.11.138] (user-54458eb9.lns1-c13.telh.dsl.pol.co.uk
	[84.69.142.185])
	by mail.youplala.net (Postfix) with ESMTP id 9156AD88122
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 08:54:52 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <950c7d180802192339s5fa402fan6a9ac8674e128689@mail.gmail.com>
References: <1203434275.6870.25.camel@tux>
	<1203441662.9150.29.camel@acropora> <1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203458966.28796.13.camel@youkaida>
	<950c7d180802192339s5fa402fan6a9ac8674e128689@mail.gmail.com>
Date: Wed, 20 Feb 2008 07:54:51 +0000
Message-Id: <1203494091.11318.7.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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


On Wed, 2008-02-20 at 16:39 +0900, Matthew Vermeulen wrote:
> On Feb 20, 2008 7:09 AM, Nicolas Will <nico@youplala.net> wrote: 
>         
>         
>         On Wed, 2008-02-20 at 06:10 +0900, Matthew Vermeulen wrote:
>         > Hi all... I'm seeing exactly the same problems everyone else
>         is (log
>         > flooding etc) except that I can't seem to get any keys
>         picked by lirc
>         > or /dev/input/event7 at all...
>         >
>         > Would this patch help in this case?
>         
>         
>         It would help with the flooding, most probably, though there
>         was a patch
>         for that available before.
>         
>         As for LIRC not picking up the event, I would be tempted to
>         say no, it
>         won't help.
>         
>         Are you certain that your LIRC is configured properly? Are you
>         certain
>         that your event number is the right one?
>         
>         
>         Nico
> 
> I believe so... in so far as I can tell... I sent an email to this
> list about a week ago describing my problems, but there was no
> response. (subject: Compro Videomate U500). I've copied it below:
> 
> Hi all,
> 
> I've still been trying to get the inluded remote with my USB DVB-T
> Tuner working. It's a Compro Videomate U500 - it useses the dibcom
> 7000 chipset. After upgrading to Ubuntu 8.04 (hardy) I can now see the
> remote when I do a "cat /proc/bus/input/devices":
> 
> I: Bus=0003 Vendor=185b Product=1e78 Version=0100
> N: Name="IR-receiver inside an USB DVB receiver"
> P: Phys=usb-0000:00:02.1-4/ir0
> S: Sysfs=/devices/pci0000:00/0000 :00:02.1/usb1/1-4/input/input7
> U: Uniq=
> H: Handlers=kbd event7 
> B: EV=3
> B: KEY=10afc332 2842845 0 0 0 4 80018000 2180 40000801 9e96c0 0 800200
> ffc

Weird.

You went through all this, I guess:

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#Remote_control

And you are running a recent v4l-dvb tree, I assume.

> 
> However, I get now output running irrecord:

I was never too lucky with irrecord on my system, IIRC.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
