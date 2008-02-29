Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JV72W-0000Vd-3b
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 16:20:49 +0100
Received: by wr-out-0506.google.com with SMTP id 68so6133618wra.13
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 07:20:42 -0800 (PST)
Message-ID: <d9def9db0802290720o315084aegeb98a2f554a640ae@mail.gmail.com>
Date: Fri, 29 Feb 2008 16:20:41 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <47C82083.6080800@powercraft.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C7329F.7030705@powercraft.nl> <47C73A05.2050007@powercraft.nl>
	<d9def9db0802281455hb962279g9f45a8e87cf16d28@mail.gmail.com>
	<d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>
	<47C74DF4.6040608@powercraft.nl> <1204246336.22520.57.camel@youkaida>
	<d9def9db0802282327l1139e17ew8a571ac578e37df2@mail.gmail.com>
	<47C8163E.5030009@powercraft.nl>
	<d9def9db0802290637k5495258n7b6cff5700d94675@mail.gmail.com>
	<47C82083.6080800@powercraft.nl>
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

On Fri, Feb 29, 2008 at 4:10 PM, Jelle de Jong
<jelledejong@powercraft.nl> wrote:
>
> Markus Rechberger wrote:
>  >>  I spent several hours again to see if I could get it working on Debian
>  >>  sid. I got a little bit further bit still got compilation errors.
>  >>
>  >>  Can you please look at my attachments.
>  >>
>  >
>  >  CC [M]  /home/jelle/em28xx-userspace2/em2880-dvb.o
>  > In file included from /home/jelle/em28xx-userspace2/em28xx.h:42,
>  >                 from /home/jelle/em28xx-userspace2/em2880-dvb.c:33:
>  > include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in
>  > a function)
>  >
>  > ok this seems to come from a cleanup patch to remove some warnings. I
>  > reverted that change again.
>  > Can you download em28xx-userspace2 again and try to recompile it.
>  >
>  > thanks,
>  > Markus
>
>  Thank you it is now compiling, however when loading the drivers after
>  rebooting the pc (also before rebooting) i get the following errors.
>
>  See the attachments,
>
>  Kind regards,
>
>  Jelle
>
>
> usb 5-3: new high speed USB device using ehci_hcd and address 5
>  usb 5-3: configuration #1 chosen from 1 choice
>  em28xx: disagrees about version of symbol video_unregister_device
>  em28xx: Unknown symbol video_unregister_device
>  em28xx: disagrees about version of symbol video_device_alloc
>  em28xx: Unknown symbol video_device_alloc
>  em28xx: disagrees about version of symbol video_register_device
>  em28xx: Unknown symbol video_register_device
>  em28xx: disagrees about version of symbol video_device_release
>  em28xx: Unknown symbol video_device_release

can you also reinstall the linux kernel for your debian distribution?
the manual installation of v4l-dvb-experimental from mcentral.de or
v4l-dvb repository from linuxtv.org causes this problem.

You might try

apt-get install --reinstall linux-image-`uname -r`

for restoring your kernel

You probably have the modules from v4l-dvb-experimental or v4l-dvb
installed, but your kernel sources have older versions of those
interfaces, and the userspace drivers only build against the original
kernel interface.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
