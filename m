Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JjGdW-0003PN-Ha
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 18:25:31 +0200
Received: by gv-out-0910.google.com with SMTP id n40so409770gve.16
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 09:25:25 -0700 (PDT)
Message-ID: <8ad9209c0804080925y4554bf0bnfcd445f7f9c115ad@mail.gmail.com>
Date: Tue, 8 Apr 2008 18:25:24 +0200
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <b000da060804080723k3eb9056bt8f9e6d37e089616@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47A98F3D.9070306@raceme.org> <47AB1FC0.8000707@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<C34A2B56-5B39-4BE4-BACD-4E653F61FB03@firshman.co.uk>
	<8ad9209c0803121334s1485b65ap7fe7d5e4df552535@mail.gmail.com>
	<8ad9209c0803121338w6b93c555y73bf82abee55a63c@mail.gmail.com>
	<8ad9209c0804050434i3b898edfucf0294403d87f5ca@mail.gmail.com>
	<b000da060804080723k3eb9056bt8f9e6d37e089616@mail.gmail.com>
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

2008/4/8 daniel =E5kerud <daniel.akerud@gmail.com>:
> On Sat, Apr 5, 2008 at 1:34 PM, Patrik Hansson <patrik@wintergatan.com>
> wrote:
>
> > Just wanted to report that since stopped the active EIT scanning in
> > mythtv-setup my NOVA-T 500 PCI have been stable for 4 days now with
> > 2.6.22-14 without any special module options or anything like that.
> > Before i never had both tuners working for more that 24 hours so that
> > seems to be the workaround for the moment.
> > The card still collects EIT data when watching tv so EPG still works.
> >
> >
> >
> >
> >
>
> I second that. I disabled Active EIT (mythtv-setup) and also added:
> options usbcore autosuspend=3D-1
>
> options dvb_usb disable_rc_polling=3D1
>  to the module options. My system has been rock solid since (~2 weeks) an=
d I
> used to have at least a couple of problems per week before.
> /D
>
>
> _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Did you also try without adding the module options ?
Just to confirm if they were needed.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
