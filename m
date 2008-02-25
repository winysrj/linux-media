Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JTgnE-0000mD-19
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 18:07:08 +0100
Received: by nf-out-0910.google.com with SMTP id d21so938447nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 25 Feb 2008 09:07:03 -0800 (PST)
Message-ID: <8ad9209c0802250900tcbfa2d9v2494993cfb0e4604@mail.gmail.com>
Date: Mon, 25 Feb 2008 18:00:06 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1203520472.4767.18.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
References: <8ad9209c0802111207t51e82a3eg53cf93c0bda0515b@mail.gmail.com>
	<1202762738.8087.8.camel@youkaida> <1203458171.8019.20.camel@anden.nu>
	<1203461323.28796.26.camel@youkaida>
	<1203466323.5358.29.camel@pc08.localdom.local>
	<1203491540.28796.46.camel@youkaida>
	<1203520472.4767.18.camel@pc08.localdom.local>
Subject: Re: [linux-dvb] Very quiet around Nova-T 500
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

On Wed, Feb 20, 2008 at 4:14 PM, hermann pitton <hermann-pitton@arcor.de> wrote:
> Hi Nico,
>
>  Am Mittwoch, den 20.02.2008, 07:12 +0000 schrieb Nicolas Will:
>
> > On Wed, 2008-02-20 at 01:12 +0100, hermann pitton wrote:
>  > > > Now stop that logging madness and get back to work!
>  > > >
>  > > > ...
>  > > >
>  > > > ;o)
>  > > >
>  > > >
>  > > > This is a rather comical situation, though... The debugging tool is
>  > > > providing a rather unexpected and unwelcomed fix.
>  > > >
>  > > > Nico
>  > > >
>  > >
>  > > Hi,
>  > >
>  > > no, it is not. It is well known!
>  > >
>  > > Timings are very critical on almost all drivers.
>  > >
>  > > We hold breath on almost everything coming down from above, nobody has
>  > > the ability, or whom should ever want it, to test all possible side
>  > > effects on all supported devices ...
>  > >
>  > > That something breaks is very common, and that others have to give the
>  > > plumbers, is nothing new.
>  > >
>  > > To stay fair, it mostly has a good reason, and if there are some
>  > > remaining ticks left, you might get it adjusted, but ...
>  > >
>  > > On the other side it is the same ...
>  >
>  > May post may have sounded offensive, apparently.
>  >
>  > Sorry about that, my intentions were on the lighter sides of life.
>  >
>  > Nico
>  >
>
>  nothing offending at all, did enjoy your above comment :)
>  and like your active support for others.
>
>  It is just not totally unexpected that high debug levels can have some
>  spin-off and I'm curious about it.
>
>  Cheers,
>  Hermann
>
>
>
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Kernel 2.6.24-2
Debug=15
Got this after 5 minutes of LiveTV:
(Dunno if it could be usefull or not)

modifying (1) streaming state for 1
data for streaming: 10 13
>>> 0f 10 13 00
usb 10-1: USB disconnect, address 2
>>> 03 14 03 01 60 00
ep 0 write error (status = -19, len: 6)
mt2060 I2C write failed
>>> 03 14 04 07 ff ff
ep 0 write error (status = -19, len: 6)
>>> 03 14 04 08 ff ff
ep 0 write error (status = -19, len: 6)
>>> 03 14 04 09 ff f0
ep 0 write error (status = -19, len: 6)
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b
>>> 02 17 81 ca
ep 0 read error (status = -19)
<<< 00 20
I2C read failed on address b
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b
>>> 02 17 81 fd
ep 0 read error (status = -19)
<<< 77 8d
I2C read failed on address b

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
