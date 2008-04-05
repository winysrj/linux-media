Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1Ji6fa-0000PR-VQ
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 13:34:54 +0200
Received: by yw-out-2324.google.com with SMTP id 5so94155ywh.41
	for <linux-dvb@linuxtv.org>; Sat, 05 Apr 2008 04:34:45 -0700 (PDT)
Message-ID: <8ad9209c0804050434i3b898edfucf0294403d87f5ca@mail.gmail.com>
Date: Sat, 5 Apr 2008 13:34:45 +0200
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803121338w6b93c555y73bf82abee55a63c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47A98F3D.9070306@raceme.org> <1202327817.20362.28.camel@youkaida>
	<1202330097.4825.3.camel@anden.nu> <47AB1FC0.8000707@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<C34A2B56-5B39-4BE4-BACD-4E653F61FB03@firshman.co.uk>
	<8ad9209c0803121334s1485b65ap7fe7d5e4df552535@mail.gmail.com>
	<8ad9209c0803121338w6b93c555y73bf82abee55a63c@mail.gmail.com>
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

On Wed, Mar 12, 2008 at 10:38 PM, Patrik Hansson <patrik@wintergatan.com> w=
rote:
>
> On Wed, Mar 12, 2008 at 9:34 PM, Patrik Hansson <patrik@wintergatan.com> =
wrote:
>  >
>  > On Wed, Mar 5, 2008 at 12:03 AM, Ben Firshman <ben@firshman.co.uk> wro=
te:
>  >  > I am quite disappointed to report that one of my tuners has just di=
ed
>  >  >  this evening. No error messages to speak of.
>  >  >
>  >  >  Ben
>  >  >
>  >  >
>  >  >
>  >  >  On 26 Feb 2008, at 19:18, Philip Pemberton wrote:
>  >  >
>  >  >  > Patrik Hansson wrote:
>  >  >  >> Just wanted to say that I=B4m experiencing the same.
>  >  >  >> Using latest rev (the one with patches merged) + unknown remote=
 key
>  >  >  >> patch.
>  >  >  >> Ubuntu 7.10
>  >  >  >>
>  >  >  >> Also having a lot of "prebuffer timeout 10 times" i the middle =
of
>  >  >  >> shows.
>  >  >  >
>  >  >  > I think I might have a workaround... On Mythbuntu or one of the =
many
>  >  >  > Ubuntu
>  >  >  > variants, this seems to work:
>  >  >  >
>  >  >  > 1)  Run:
>  >  >  >       lsmod |grep usbcore
>  >  >  >
>  >  >  > 2)  If step 1 produced any output that started with 'usbcore', t=
hen
>  >  >  > usbcore is
>  >  >  > loaded as a module. Perform step 3a. Otherwise, step 3b.
>  >  >  >
>  >  >  > 3a) Create a text file called /etc/modprobe.d/local-dvb (the nam=
e is
>  >  >  > fairly
>  >  >  > irrelevant). Insert one line of text into it:
>  >  >  >       options usbcore autosuspend=3D-1
>  >  >  >     Now go to step 4.
>  >  >  >
>  >  >  > 3b) Your kernel has usbcore built in. That means you have to mod=
ify
>  >  >  > the kernel
>  >  >  > command line...
>  >  >  >     Edit /boot/grub/menu.lst (you'll need to sudo to do this).
>  >  >  > Search for
>  >  >  > this line:
>  >  >  > # defoptions=3Dquiet splash
>  >  >  >     Amend it to read:
>  >  >  > # defoptions=3Dquiet splash usbcore.autosuspend=3D-1
>  >  >  >     It's meant to be commented out, so leave the hash at the
>  >  >  > beginning of the
>  >  >  > line alone... Save and exit, then run ...
>  >  >  > sudo update grub
>  >  >  >     Ubuntu will regenerate grub.conf, using the new kernel comma=
nd
>  >  >  > line. Off
>  >  >  > to step 4 you go!
>  >  >  >
>  >  >  >     If you're using a non-Debian distro (e.g. Fedora), do the sa=
me
>  >  >  > thing but
>  >  >  > edit the 'kernel' line instead. It might read:
>  >  >  > kernel          /boot/vmlinuz-2.6.24-8-generic root=3DLABEL=3D/ =
ro quiet
>  >  >  > splash
>  >  >  >     Change it to:
>  >  >  > kernel          /boot/vmlinuz-2.6.24-8-generic root=3DLABEL=3D/ =
ro quiet
>  >  >  > splash
>  >  >  > usbcore.autosuspend=3D-1
>  >  >  >
>  >  >  > 4)  Reboot your PC.
>  >  >  >
>  >  >  > This is a bit long-winded, but saves a kernel recompile, and a t=
on
>  >  >  > of messing
>  >  >  > around recompiling kernels when Ubuntu do another release.
>  >  >  >
>  >  >  > I'm working on what I consider to be a better fix, which involves
>  >  >  > using the
>  >  >  > kernel's Quirks function to disable USB suspend just for the DiB=
com
>  >  >  > controllers. That is, the kernel won't try and suspend them at a=
ll...
>  >  >  >
>  >  >  > Thanks,
>  >  >  > --
>  >  >  > Phil.                         |  (\_/)  This is Bunny. Copy and
>  >  >  > paste Bunny
>  >  >  > lists@philpem.me.uk           | (=3D'.'=3D) into your signature =
to help
>  >  >  > him gain
>  >  >  > http://www.philpem.me.uk/     | (")_(") world domination.
>  >  >  >
>  >  >
>  >  >
>  >  > > _______________________________________________
>  >  >  > linux-dvb mailing list
>  >  >  > linux-dvb@linuxtv.org
>  >  >  > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >  >
>  >  >
>  >  >  _______________________________________________
>  >  >  linux-dvb mailing list
>  >  >  linux-dvb@linuxtv.org
>  >  >  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >  >
>  >
>  >  I just want check something i just discovered.
>  >  Under /sys/module/dvb_core/parameters/ i have something called
>  >  dvb_powerdown_on_sleep
>  >  This i set to "1" for me.
>  >  I also have one called  dvb_shutdown_timeout and that is set to 0
>  >
>  >  Exactly what is it that options usbcore autosuspend=3D-1 controls ?
>  >
>  >  I would have expected that at least one of those should be -1
>  >
>
>  .....and now i see were i made my mistake (usbcore vs dvb_core) and
>  made a fool out of myself.
>  please disregard my last email.
>

Just wanted to report that since stopped the active EIT scanning in
mythtv-setup my NOVA-T 500 PCI have been stable for 4 days now with
2.6.22-14 without any special module options or anything like that.
Before i never had both tuners working for more that 24 hours so that
seems to be the workaround for the moment.
The card still collects EIT data when watching tv so EPG still works.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
