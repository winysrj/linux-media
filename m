Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JUzZK-0004YQ-U5
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 08:22:11 +0100
Received: by wa-out-1112.google.com with SMTP id m28so4144157wag.13
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 23:22:04 -0800 (PST)
Message-ID: <8ad9209c0802282322u6b11d18ds1358c0683a43af9f@mail.gmail.com>
Date: Fri, 29 Feb 2008 08:22:04 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <200802282110.31123.dom.plu@laposte.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <47A98F3D.9070306@raceme.org>
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
	<47C7076B.6060903@philpem.me.uk>
	<200802282110.31123.dom.plu@laposte.net>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 2/28/08, Dominique P. <dom.plu@laposte.net> wrote:
> Hi
>
> I have exactly the same problem, all seems fine on vdr until I start one
> recording that use the second timer , I got thousand of message like this
> one , it seems stg is not well loaded some time, I just have to shutdown =
vdr,
> I can see that device disconnect itself on dmesg and all is OK when start=
ing
> vdr another time ...
>
> hope somebody have a solution for that
>
> Best regards
>
> kernel =3D 2.6.22.18-desktop586-1mdv on mandriva 2008.0
>
>
>
> Le Thursday 28 February 2008 20:11:39 Philip Pemberton, vous avez =E9crit=
 :
> > Patrik Hansson wrote:
> > > 20:37:40 up 1 day, 8 min ...and counting, both tuners working fine.
> > >
> > > There are two:
> > > [14153.150380] mt2060 I2C read failed
> > > [18967.903269] mt2060 I2C read failed
> > > recorded in dmesg but nothing fatal.
> >
> > philpem@dragon:~$ uptime
> >   19:06:28 up 23:42,  3 users,  load average: 1.19, 1.22, 1.18
> >
> > And the log is full of this crap:
> > Feb 28 06:29:13 dragon syslogd 1.5.0#1ubuntu1: restart.
> > Feb 28 06:29:13 dragon kernel: [39865.332785] cx24123_readreg: reg=3D0x=
14
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.333946] cx24123_readreg: reg=3D0x=
20
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.432586] cx24123_readreg: reg=3D0x=
14
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.433733] cx24123_readreg: reg=3D0x=
20
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.532380] cx24123_readreg: reg=3D0x=
14
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.533473] cx24123_readreg: reg=3D0x=
20
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.632210] cx24123_readreg: reg=3D0x=
14
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.633301] cx24123_readreg: reg=3D0x=
20
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.731998] cx24123_readreg: reg=3D0x=
14
> > (error=3D-121)
> > Feb 28 06:29:13 dragon kernel: [39865.733092] cx24123_readreg: reg=3D0x=
20
> > (error=3D-121)
> > Feb 28 06:29:14 dragon kernel: [39865.831820] cx24123_readreg: reg=3D0x=
14
> > (error=3D-121)
> > Feb 28 06:29:14 dragon kernel: [39866.374256] mt2060 I2C write failed
> > (len=3D2) Feb 28 06:29:14 dragon kernel: [39866.374262] mt2060 I2C write
> > failed (len=3D6) Feb 28 06:29:14 dragon kernel: [39866.374264] mt2060 I=
2C
> > read failed Feb 28 06:29:14 dragon kernel: [39866.382298] mt2060 I2C re=
ad
> > failed Feb 28 06:29:14 dragon kernel: [39866.390210] mt2060 I2C read fa=
iled
> > Feb 28 06:29:14 dragon kernel: [39866.398195] mt2060 I2C read failed Fe=
b 28
> > 06:29:14 dragon kernel: [39866.406181] mt2060 I2C read failed Feb 28
> > 06:29:14 dragon kernel: [39866.414175] mt2060 I2C read failed Feb 28
> > 06:29:14 dragon kernel: [39866.422213] mt2060 I2C read failed Feb 28
> > 06:29:14 dragon kernel: [39866.430162] mt2060 I2C read failed
> >
> > And the tuner is utterly shot. It worked for most of one recording, then
> > promptly died.
> >
> > *sigh*
> >
> > Patrik, just out of curiosity, what kernel are you running?
> > I'm running 2.6.24-8-generic on Mythbuntu 8.04 alpha 2 and thinking abo=
ut
> > downgrading to an earlier kernel.
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

1: I got a mailer-daemon reply saing that my ip was spamfiltred (I use
gmail?) when replying to what kernel i use.
My kernel is 2.6.22-14-generic

2: This morning I hade L__ on my second tuner.
some more mt2060 I2C read failed in dmesg.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
