Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:51409 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0LTSSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 13:18:49 -0500
Date: Mon, 20 Dec 2010 12:54:46 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Alex Deucher <alexdeucher@gmail.com>
cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: problems with using the -rc kernel in the git tree
In-Reply-To: <AANLkTinjtT4Ki1=+-04GbEkw4e8+W7F=aC0c4xpv3Qqc@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1012201154080.24997@banach.math.auburn.edu>
References: <30370.90722.qm@web84204.mail.re3.yahoo.com> <4D034D67.1050806@redhat.com> <alpine.LNX.2.00.1012141235210.18793@banach.math.auburn.edu> <4D07D977.8010801@redhat.com> <alpine.LNX.2.00.1012151324190.19893@banach.math.auburn.edu> <4D091B75.6090003@redhat.com>
 <alpine.LNX.2.00.1012191716210.24101@banach.math.auburn.edu> <AANLkTinjtT4Ki1=+-04GbEkw4e8+W7F=aC0c4xpv3Qqc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-1624857819-1292871286=:24997"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-1624857819-1292871286=:24997
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Mon, 20 Dec 2010, Alex Deucher wrote:

> On Sun, Dec 19, 2010 at 6:56 PM, Theodore Kilgore
> <kilgota@banach.math.auburn.edu> wrote:
> >
> > Hans,
> >
> > Thanks for the helpful advice about how to set up a git tree for current
> > development so that I can get back into things.
> >
> > However, there is a problem with that -rc kernel, at least as far as my
> > hardware is concerned. So if I am supposed to use it to work on camera
> > stuff there is an obstacle.
> >
> > I started by copying my .config file over to the tree, and then running
> > make oldconfig (as you said and as I would have done anyway).
> >
> > The problem seems to be centered right here (couple of lines
> > from .config follow)
> >
> > CONFIG_DRM_RADEON=m
> > # CONFIG_DRM_RADEON_KMS is not set
> >
> > I have a Radeon video card, obviously. Specifically, it is (extract from X
> > config file follows)
> >
> > # Device configured by xorgconfig:
> >
> > Section "Device"
> >    Identifier  "ATI Radeon HD 3200"
> >    Driver      "radeon"
> >
> > Now, what happens is that with the kernel configuration (see above) I
> > cannot start X in the -rc kernel. I get bumped out with an error
> > message (details below) whereas that _was_ my previous configuration
> > setting.
> >
> > But if in the config for the -rc kernel I change the second line by
> > turning on CONFIG_DRM_RADEON_KMS the situation is even worse. Namely, the
> > video cuts off during the boot process, with the monitor going blank and
> > flashing up a message that it lost signal. After that the only thing to do
> > is a hard reset, which strangely does not result in any check for a dirty
> > file system, showing that things _really_ got screwed. These problems wit
> > the video cutting off at boot are with booting into the _terminal_, BTW. I
> > do not and never have made a practice of booting into X. I start X from
> > the command line after boot. Thus, the video cutting off during boot has
> > nothing to do with X at all, AFAICT.
> >
> > So as I said there are two alternatives, both of them quite unpleasant.
> >
> > Here is what the crash message is on the screen from the attempt to start
> > up X, followed by what seem to be the relevant lines from the log file,
> > with slightly more detail.
> >
> > Markers: (--) probed, (**) from config file, (==) default setting,
> >        (++) from command line, (!!) notice, (II) informational,
> >        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
> > (==) Log file: "/var/log/Xorg.0.log", Time: Sun Dec 19 14:32:12 2010
> > (==) Using config file: "/etc/X11/xorg.conf"
> > (==) Using system config directory "/usr/share/X11/xorg.conf.d"
> > (II) [KMS] drm report modesetting isn't supported.
> > (EE) RADEON(0): Unable to map MMIO aperture. Invalid argument (22)
> > (EE) RADEON(0): Memory map the MMIO region failed
> > (EE) Screen(s) found, but none have a usable configuration.
> >
> > Fatal server error:
> > no screens found
> >
> > Please consult the The X.Org Foundation support
> >         at http://wiki.x.org
> >  for help.
> > Please also check the log file at "/var/log/Xorg.0.log" for additional
> > information.
> >
> > xinit: giving up
> > xinit: unable to connect to X server: Connection refused
> > xinit: server error
> > xinit: unable to connect to X server: Connection refused
> > xinit: server error
> > kilgota@khayyam:~$
> >
> > And the following, too, from the log file, which perhaps contains one or
> > two
> > more details:
> >
> > [    48.050] (--) using VT number 7
> >
> > [    48.052] (II) [KMS] drm report modesetting isn't supported.
> > [    48.052] (II) RADEON(0): TOTO SAYS 00000000feaf0000
> > [    48.052] (II) RADEON(0): MMIO registers at 0x00000000feaf0000: size
> > 64KB
> > [    48.052] (EE) RADEON(0): Unable to map MMIO aperture. Invalid argument
> > (22)
> > [    48.052] (EE) RADEON(0): Memory map the MMIO region failed
> > [    48.052] (II) UnloadModule: "radeon"
> > [    48.052] (EE) Screen(s) found, but none have a usable configuration.
> > [    48.052]
> > Fatal server error:
> > [    48.052] no screens found
> > [    48.052]
> >
> > There are a couple of suggestions about things to try, such as compiling
> > with CONFIG_DRM_RADEON_KMS and then passing the parameter modeset=0 to the
> > radeon module. But that does not seem to help, either.
> >
> > The help screens in make menuconfig do not seem to praise the
> > CONFIG_DRM_RADEON_KMS very highly, and seem to indicate that this is still
> > a very experimental feature.
> >
> > There are no such equivalent problems with my current kernel, which is a
> > home-compiled 2.6.35.7.
> >
> > I realize that this is a done decision, but it is exactly this kind of
> > thing that I had in mind when we had the Great Debate on the linux-media
> > list about whether to use hg or git. My position was to let hardware
> > support people to run hg with the compatibility layer for recent kernels
> > (and 2.6.35.7 is certainly recent!). Well, the people who had such a
> > position did not win. So now here is unfortunately the foreseeable result.
> > An experimental kernel with some totally unrelated bug which affects my
> > hardware and meanwhile stops all progress.
> 
> If you enable radeon KMS, you need to enable fbcon in your kernel or
> you will lose video when the radeon kms driver loads since it controls
> the video device and provide a legacy kernel fbdev interface.  As for
> X, you need a ddx (xf86-video-ati) built with kms support (6.13.x
> series).
> 
> Alex

OK, I will try to pursue this. But, first to be clear about the sequence 
of events:

In my previous setup using 2.6.35.7 the radeon KMS was *not* enabled and 
things worked just fine. When I ran through "make oldconfig" I did not 
change that (see above). Then I was able to boot, but not able to start 
and X session. 

After rebooting with my old kernel, I did some searching for the error 
messages that I got (again, see above) and tried to follow the suggestion 
of turning that KMS config option on, experimenting with various things 
such as passing an option to the module to disable the KMS when loading. 
But with the KMS config option things were even worse than without it, in 
that I could not even boot the machine.

So I am glad to let things remain as they were and not to use this 
new-fangled option. Therefore one rather meaningful question is, why did 
things not continue to work when I did not change anything about my 
configuration?

Now, as to which version of the X drivers that I am running, it does not 
seem to be a problem:

kilgota@khayyam:~/slackware64-current/slackware64/x$ ls | grep ati
[...]
xf86-video-ati-6.13.2-x86_64-1.txt
xf86-video-ati-6.13.2-x86_64-1.txz
xf86-video-ati-6.13.2-x86_64-1.txz.asc
kilgota@khayyam:~/slackware64-current/slackware64/x$

and 

kilgota@khayyam:/var/log/packages$ ls | grep ati
[...]
xf86-video-ati-6.13.2-x86_64-1
kilgota@khayyam:/var/log/packages$

As to

> If you enable radeon KMS, you need to enable fbcon in your kernel or
> you will lose video when the radeon kms driver loads since it controls
> the video device and provide a legacy kernel fbdev interface.

Again, thanks for the suggestions. I will see what happens if I put in the 
framebuffer console option. I am sure it is not there; I have otherwise 
not particularly enjoyed using it and have usually tried to avoid its use. 
It requires still another option: to use a font which is large enough. I 
cannot use a console with some kind of 8x8 or 4x6 font, or whatever. So to 
hunt for a good font is already extra trouble for nothing. But also when 
the framebuffer console kicks in the bootup messages disappear in the 
middle of the boot procedure. Thanks, I would much rather see what is 
happening than to look at pretty pictures while booting or to have the 
messages go into a black hole halfway through. Some of us are just a 
little bit old-fashioned that way and really do not give a hoot whether 
the bootup looks sexy or not. In other words, I find myself confronted 
with one of those situations where not all movement is progress.

Thus, again, why did things collapse now and refuse to work properly 
without the KMS option, when without the KMS option things worked 
perfectly well in 2.6.35.7 ? Judging from what the error messages are 
saying, it appears to me that in the presence of the new kernel 
there seems to be an attempt to use the KMS option regardless of 
whether it is present, and when it is not present one is bumped out with 
an "error" which in the previous environment was no error at all. Weird.

Theodore Kilgore
---863829203-1624857819-1292871286=:24997--
