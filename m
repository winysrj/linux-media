Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <daniel.akerud@gmail.com>) id 1JjZWc-0008Vs-EI
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 14:35:39 +0200
Received: by wf-out-1314.google.com with SMTP id 28so2598066wfa.17
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 05:35:33 -0700 (PDT)
Message-ID: <b000da060804090535y194cb897y4ece2541361987bc@mail.gmail.com>
Date: Wed, 9 Apr 2008 14:35:32 +0200
From: "=?ISO-8859-1?Q?daniel_=E5kerud?=" <daniel.akerud@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0804080925y4554bf0bnfcd445f7f9c115ad@mail.gmail.com>
MIME-Version: 1.0
References: <47A98F3D.9070306@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<C34A2B56-5B39-4BE4-BACD-4E653F61FB03@firshman.co.uk>
	<8ad9209c0803121334s1485b65ap7fe7d5e4df552535@mail.gmail.com>
	<8ad9209c0803121338w6b93c555y73bf82abee55a63c@mail.gmail.com>
	<8ad9209c0804050434i3b898edfucf0294403d87f5ca@mail.gmail.com>
	<b000da060804080723k3eb9056bt8f9e6d37e089616@mail.gmail.com>
	<8ad9209c0804080925y4554bf0bnfcd445f7f9c115ad@mail.gmail.com>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1651873708=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1651873708==
Content-Type: multipart/alternative;
	boundary="----=_Part_28689_15505725.1207744532857"

------=_Part_28689_15505725.1207744532857
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, Apr 8, 2008 at 6:25 PM, Patrik Hansson <patrik@wintergatan.com>
wrote:

> 2008/4/8 daniel =E5kerud <daniel.akerud@gmail.com>:
> > On Sat, Apr 5, 2008 at 1:34 PM, Patrik Hansson <patrik@wintergatan.com>
> > wrote:
> >
> > > Just wanted to report that since stopped the active EIT scanning in
> > > mythtv-setup my NOVA-T 500 PCI have been stable for 4 days now with
> > > 2.6.22-14 without any special module options or anything like that.
> > > Before i never had both tuners working for more that 24 hours so that
> > > seems to be the workaround for the moment.
> > > The card still collects EIT data when watching tv so EPG still works.
> > >
> > >
> > >
> > >
> > >
> >
> > I second that. I disabled Active EIT (mythtv-setup) and also added:
> > options usbcore autosuspend=3D-1
> >
> > options dvb_usb disable_rc_polling=3D1
> >  to the module options. My system has been rock solid since (~2 weeks)
> and I
> > used to have at least a couple of problems per week before.
> > /D
> >
> Did you also try without adding the module options ?
> Just to confirm if they were needed.
>

Unfortunately not! I just had enough and did everything I could in one go
:-D

/D

------=_Part_28689_15505725.1207744532857
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div class=3D"gmail_quote">On Tue, Apr 8, 2008 at 6:25 PM, Patrik Hansson &=
lt;<a href=3D"mailto:patrik@wintergatan.com">patrik@wintergatan.com</a>&gt;=
 wrote:<br><blockquote class=3D"gmail_quote" style=3D"border-left: 1px soli=
d rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
2008/4/8 daniel =E5kerud &lt;<a href=3D"mailto:daniel.akerud@gmail.com">dan=
iel.akerud@gmail.com</a>&gt;:<br>
<div><div></div><div class=3D"Wj3C7c">&gt; On Sat, Apr 5, 2008 at 1:34 PM, =
Patrik Hansson &lt;<a href=3D"mailto:patrik@wintergatan.com">patrik@winterg=
atan.com</a>&gt;<br>
&gt; wrote:<br>
&gt;<br>
&gt; &gt; Just wanted to report that since stopped the active EIT scanning =
in<br>
&gt; &gt; mythtv-setup my NOVA-T 500 PCI have been stable for 4 days now wi=
th<br>
&gt; &gt; 2.6.22-14 without any special module options or anything like tha=
t.<br>
&gt; &gt; Before i never had both tuners working for more that 24 hours so =
that<br>
&gt; &gt; seems to be the workaround for the moment.<br>
&gt; &gt; The card still collects EIT data when watching tv so EPG still wo=
rks.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt;<br>
&gt; I second that. I disabled Active EIT (mythtv-setup) and also added:<br=
>
&gt; options usbcore autosuspend=3D-1<br>
&gt;<br>
&gt; options dvb_usb disable_rc_polling=3D1<br>
&gt; &nbsp;to the module options. My system has been rock solid since (~2 w=
eeks) and I<br>
&gt; used to have at least a couple of problems per week before.<br>
&gt; /D<br>
&gt;<br>
</div></div>Did you also try without adding the module options ?<br>
Just to confirm if they were needed.<br>
</blockquote></div><br>Unfortunately not! I just had enough and did everyth=
ing I could in one go :-D<br><br>/D<br>

------=_Part_28689_15505725.1207744532857--


--===============1651873708==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1651873708==--
