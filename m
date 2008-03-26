Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Jea5U-0003Si-DG
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 19:11:04 +0100
Received: by wx-out-0506.google.com with SMTP id s11so4103113wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 11:10:34 -0700 (PDT)
Message-ID: <d9def9db0803261110l6d9e948bt4be847e9ebaf7ff1@mail.gmail.com>
Date: Wed, 26 Mar 2008 19:10:34 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Patrik Hansson" <patrik@wintergatan.com>
In-Reply-To: <8ad9209c0803261055y72a34ceax9b346d55525a9c4d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206139910.12138.34.camel@youkaida> <1206185051.22131.5.camel@tux>
	<1206190455.6285.20.camel@youkaida> <1206270834.4521.11.camel@shuttle>
	<1206348478.6370.27.camel@youkaida>
	<1206546831.8967.13.camel@acropora>
	<8ad9209c0803261055y72a34ceax9b346d55525a9c4d@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
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

On 3/26/08, Patrik Hansson <patrik@wintergatan.com> wrote:
> On Wed, Mar 26, 2008 at 4:53 PM, Nicolas Will <nico@youplala.net> wrote:
> > On Mon, 2008-03-24 at 08:47 +0000, Nicolas Will wrote:
> > > Guys,
> > >
> > > I was running with the following debug options when I got a disconnec=
t:
> > >
> > > options dvb-usb-dib0700 force_lna_activation=3D1
> > > options dvb-usb-dib0700 debug=3D1
> > > options mt2060 debug=3D1
> > > options dibx000_common debug=3D1
> > > options dvb_core debug=3D1
> > > options dvb_core dvbdev_debug=3D1
> > > options dvb_core frontend_debug=3D1
> > > options dvb_usb debug=3D1
> > > options dib3000mc debug=3D1
> > > options usbcore autosuspend=3D-1
> > >
> > >
> > > /var/log/messages is here:
> > >
> > > http://www.youplala.net/~will/htpc/disconnects/messages-with_debug
> > >
> > > and slightly different data:
> > >
> > > http://www.youplala.net/~will/htpc/disconnects/syslog-with_debug
> > >
> > > Can that help, or would more be needed?
> > >
> > > There was zero remote usage at the time.
> >
> >
> > This is really a cry for help.
> >
> > I am not a coder, I don't even know where my K&R C book that I bought 17
> > years ago is anymore, so I cannot dive into the code and pretend to
> > understand it.
> >
> > But I can push, pull, help coordinate, document, hg clone, compile,
> > install, reboot, test, report, publish results on the wiki, and more if
> > needed.
> >
> > That card was nearly working 100%, then something broke, and we are back
> > to the status we had 1 year ago.
> >
> > Please, please, please...
> >
> >
> >
> > Nico
> >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
> When you get a disconnect what is needed for you to be able to get it bac=
k ?
> Just so there is no missunderstanding.
>
>
> I=B4m running sasc-ng as cardemulator to be able to use my card for the
> encrypted channels here in Sweden and i only have to restart that (and
> of course mythtv-backend) and the tuner is back.
>

The driver will be held back from unloading as long as a devicenode is open.
So restarting all applications which accesses the device nodes should
definitely help if that problem comes up.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
