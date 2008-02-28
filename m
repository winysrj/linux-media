Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JUrT6-0003fq-Ru
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 23:43:13 +0100
Received: by wr-out-0506.google.com with SMTP id 68so5473940wra.13
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 14:43:09 -0800 (PST)
Message-ID: <d9def9db0802281443o60d211e4t6f1060a301c830b8@mail.gmail.com>
Date: Thu, 28 Feb 2008 23:43:07 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C7329F.7030705@powercraft.nl>
	<d9def9db0802281421v698df05eq52a1978c69d80df2@mail.gmail.com>
	<47C73457.1030901@powercraft.nl>
	<d9def9db0802281425i5b487f43ub90b263a63e40a01@mail.gmail.com>
	<47C7360E.9030908@powercraft.nl>
	<d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>, em28xx@mcentral.de
Subject: Re: [linux-dvb] Going though hell here,
	please provide how to for Pinnacle PCTV Hybrid Pro Stick 330e
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

On 2/28/08, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> > Markus Rechberger wrote:
> > > On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> > >> Markus Rechberger wrote:
> > >>> On 2/28/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> > >>>> This message contains the following attachment(s):
> > >>>> Pinnacle PCTV Hybrid Pro Stick 330e.txt
> > >>>>
> > >>>> Spent my hole day trying to get a dvd-t device up and running, this
> is
> > >>>> device number two I tried.
> > >>>>
> > >>>> Can somebody please tell me how to get this device working on:
> > >>>>
> > >>>> 2.6.24-1-686 debian sid and 2.6.22-14-generic ubuntu
> > >>>>
> > >>>> I have to get some sleep now, because this is getting on my health
> and
> > >>>> that does not happen often....
> > >>>>
> > >>> Jelle, it's really easy to install it actually.
> > >>> http://www.mail-archive.com/em28xx%40mcentral.de/msg00750.html
> > >>>
> > >>> this is the correct "howto" for it.
> > >>>
> > >>> You need the linux kernel sources for your kernel, if you experience
> > >>> any problems just post them to the em28xx ML.
> > >>>
> > >>> Markus
> > >> Hi Markus,
> > >>
> > >> I tried that two times,
> > >>
> > >> The seconds build blows up in my face, I need specified dependecies to
> > >> be able to compile the seconds driver...
> > >>
> > >
> > > there are not so many dependencies, just submit the errors you get.
> > >
> > > Markus
> >
> > Here you go, lets see I will try it for 40 more minutes with your help
> >
>
> jelle@xubutu-en12000e:~$ hg clone
> http://mcentral.de/hg/~mrec/em28xx-userspace2
> destination directory: em28xx-userspace2
> requesting all changes
> adding changesets
> adding manifests
> adding file changes
> added 21 changesets with 65 changes to 20 files
> 18 files updated, 0 files merged, 0 files removed, 0 files unresolved
> jelle@xubutu-en12000e:~$ cd em28xx-userspace2
> jelle@xubutu-en12000e:~/em28xx-userspace2$ sudo ./build.sh
> if [ -f ../userspace-drivers/kernel/Module.symvers ]; then \
> grep v4l_dvb_stub_attach
> ../userspace-drivers/kernel/Module.symvers > Module.symvers; \
> fi
> make -C /lib/modules/2.6.22-14-generic/build
> SUBDIRS=/home/jelle/em28xx-userspace2 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.22-14-generic'
> CC [M] /home/jelle/em28xx-userspace2/em2880-dvb.o
> In file included from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
> /home/jelle/em28xx-userspace2/em28xx.h:33:20: error: dmxdev.h: No
> such file or directory
> /home/jelle/em28xx-userspace2/em28xx.h:34:23: error: dvb_demux.h: No
> such file or directory
> /home/jelle/em28xx-userspace2/em28xx.h:35:21: error: dvb_net.h: No
> such file or directory
> /home/jelle/em28xx-userspace2/em28xx.h:36:26: error: dvb_frontend.h:
> No such file or directory
>
> there we go, the linux kernel sources aren't installed for your system.
>
> apt-get install linux-source linux-headers-`uname -r`
>
> I'm not sure if the kernel sources are decompressed in /usr/src you
> might have a look at it.
>
> /lib/modules/`uname -r`/build should be a symlink to the root of the
> extracted kernelsources.
>
> the root of your kernelsources should also contain a .config file.
>
> You can find the config file for your current kernel in /boot
>
> /boot/config-`uname -r`
>
> copy this file to the kernelroot and rename it to ".config"
>

oh wait someone already provided precompiled packages for that device
for the same ubuntu version as you use.

http://mcentral.de/pipermail/em28xx/2008-February/001277.html

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
