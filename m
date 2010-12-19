Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:55648 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab0LSXUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 18:20:15 -0500
Date: Sun, 19 Dec 2010 17:56:10 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: linux-media@vger.kernel.org
Subject: problems with using the -rc kernel in the git tree
In-Reply-To: <4D091B75.6090003@redhat.com>
Message-ID: <alpine.LNX.2.00.1012191716210.24101@banach.math.auburn.edu>
References: <30370.90722.qm@web84204.mail.re3.yahoo.com> <4D034D67.1050806@redhat.com> <alpine.LNX.2.00.1012141235210.18793@banach.math.auburn.edu> <4D07D977.8010801@redhat.com> <alpine.LNX.2.00.1012151324190.19893@banach.math.auburn.edu>
 <4D091B75.6090003@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Hans, 

Thanks for the helpful advice about how to set up a git tree for current 
development so that I can get back into things. 

However, there is a problem with that -rc kernel, at least as far as my 
hardware is concerned. So if I am supposed to use it to work on camera 
stuff there is an obstacle.

I started by copying my .config file over to the tree, and then running 
make oldconfig (as you said and as I would have done anyway).

The problem seems to be centered right here (couple of lines 
from .config follow)

CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_KMS is not set

I have a Radeon video card, obviously. Specifically, it is (extract from X 
config file follows)

# Device configured by xorgconfig:

Section "Device"
    Identifier  "ATI Radeon HD 3200"
    Driver      "radeon"

Now, what happens is that with the kernel configuration (see above) I 
cannot start X in the -rc kernel. I get bumped out with an error 
message (details below) whereas that _was_ my previous configuration 
setting. 

But if in the config for the -rc kernel I change the second line by 
turning on CONFIG_DRM_RADEON_KMS the situation is even worse. Namely, the 
video cuts off during the boot process, with the monitor going blank and 
flashing up a message that it lost signal. After that the only thing to do 
is a hard reset, which strangely does not result in any check for a dirty 
file system, showing that things _really_ got screwed. These problems wit 
the video cutting off at boot are with booting into the _terminal_, BTW. I 
do not and never have made a practice of booting into X. I start X from 
the command line after boot. Thus, the video cutting off during boot has 
nothing to do with X at all, AFAICT.

So as I said there are two alternatives, both of them quite unpleasant.

Here is what the crash message is on the screen from the attempt to start 
up X, followed by what seem to be the relevant lines from the log file, 
with slightly more detail.

Markers: (--) probed, (**) from config file, (==) default setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sun Dec 19 14:32:12 2010
(==) Using config file: "/etc/X11/xorg.conf"
(==) Using system config directory "/usr/share/X11/xorg.conf.d"
(II) [KMS] drm report modesetting isn't supported.
(EE) RADEON(0): Unable to map MMIO aperture. Invalid argument (22)
(EE) RADEON(0): Memory map the MMIO region failed
(EE) Screen(s) found, but none have a usable configuration.

Fatal server error:
no screens found

Please consult the The X.Org Foundation support
         at http://wiki.x.org
 for help.
Please also check the log file at "/var/log/Xorg.0.log" for additional
information.

xinit: giving up
xinit: unable to connect to X server: Connection refused
xinit: server error
xinit: unable to connect to X server: Connection refused
xinit: server error
kilgota@khayyam:~$

And the following, too, from the log file, which perhaps contains one or 
two
more details:

[    48.050] (--) using VT number 7

[    48.052] (II) [KMS] drm report modesetting isn't supported.
[    48.052] (II) RADEON(0): TOTO SAYS 00000000feaf0000
[    48.052] (II) RADEON(0): MMIO registers at 0x00000000feaf0000: size 
64KB
[    48.052] (EE) RADEON(0): Unable to map MMIO aperture. Invalid argument 
(22)
[    48.052] (EE) RADEON(0): Memory map the MMIO region failed
[    48.052] (II) UnloadModule: "radeon"
[    48.052] (EE) Screen(s) found, but none have a usable configuration.
[    48.052]
Fatal server error:
[    48.052] no screens found
[    48.052]

There are a couple of suggestions about things to try, such as compiling 
with CONFIG_DRM_RADEON_KMS and then passing the parameter modeset=0 to the 
radeon module. But that does not seem to help, either.

The help screens in make menuconfig do not seem to praise the 
CONFIG_DRM_RADEON_KMS very highly, and seem to indicate that this is still 
a very experimental feature.

There are no such equivalent problems with my current kernel, which is a 
home-compiled 2.6.35.7.

I realize that this is a done decision, but it is exactly this kind of 
thing that I had in mind when we had the Great Debate on the linux-media 
list about whether to use hg or git. My position was to let hardware 
support people to run hg with the compatibility layer for recent kernels 
(and 2.6.35.7 is certainly recent!). Well, the people who had such a 
position did not win. So now here is unfortunately the foreseeable result. 
An experimental kernel with some totally unrelated bug which affects my 
hardware and meanwhile stops all progress.


Theodore Kilgore
