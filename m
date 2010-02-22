Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54851 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0BVPI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 10:08:57 -0500
Received: by bwz1 with SMTP id 1so64442bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 07:08:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B826A66.4000808@netscape.net>
References: <4B826A66.4000808@netscape.net>
Date: Mon, 22 Feb 2010 10:08:55 -0500
Message-ID: <829197381002220708v6e22ba37g6dd2e27c67e3cfd@mail.gmail.com>
Subject: Re: hauppage 2200 on 2.6.33 kernel : nodename is now devnode
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: John Reid <johnbaronreid@netscape.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2010 at 6:28 AM, John Reid <johnbaronreid@netscape.net> wrote:
> Hi,
>
> Sorry if this is a duplicate. My previous post didn't seem to appear.
>
> I'm using mythbuntu 9.10.
>
> I upgraded to kernel v2.6.33-rc8 because I have a DH55TC mobo (following the
> advice here https://wiki.ubuntu.com/Intel_DH55TC). This fixed a number of
> startup and slow video issues.
>
> Now I can't rebuild the drivers for my hauppage 2200 as I did for my
> previous kernel. I've been following the instructions here:
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200
> I've been using the dev tree but I also get similar errors with the stable
> tree.
>
> Initially I got a message complaining v4l/config-compat.h could not include
> autoconf.h. I got around that by changing the include to be:
> #include <linux/version.h>
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> #include <linux/autoconf.h>
> #endif
>
> Now I get the following error:
> /home/john/local/src/hauppage-2200/saa7164-dev/v4l/dvbdev.c: In function
> 'init_dvbdev':
> /home/john/local/src/hauppage-2200/saa7164-dev/v4l/dvbdev.c:516: error:
> 'struct class' has no member named 'nodename'
> make[3]: *** [/home/john/local/src/hauppage-2200/saa7164-dev/v4l/dvbdev.o]
> Error 1
> make[2]: *** [_module_/home/john/local/src/hauppage-2200/saa7164-dev/v4l]
> Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.33-020633rc8-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory
> `/home/john/local/src/hauppage-2200/saa7164-dev/v4l'
> make: *** [all] Error 2
>
> As far as I can tell by googling, 'nodename' is now 'devnode' and has a
> different signature. I don't think I know enough to edit the driver source
> to reflect this. Has anyone got a solution? If the 2200 driver is not
> currently supported on 2.6.33 does anyone know when it might be?

Hello John,

There were some changes made in the 2.6.33 mainline kernel which were
incompatible with the v4l-dvb tree (and the saa7164 tree on the
kernellabs hg is based off of a version of v4l-dvb that is several
months old).

The issue should have been fixed relatively recently in the v4l-dvb
trunk (which *does* contain pretty much all the hvr-2200 fixes).

I would recommend you do an "hg clone http://linuxtv.org/hg/v4l-dvb"
and do a compile and see if it works.  If it doesn't then post a
reply.  But to be clear, this has nothing to do with the HVR-2200
support in particular.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
