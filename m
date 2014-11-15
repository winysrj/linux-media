Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:43885 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbaKOUmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 15:42:08 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<m3sihmf3mc.fsf@t19.piap.pl>
	<CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com>
	<CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
Date: Sat, 15 Nov 2014 21:42:05 +0100
In-Reply-To: <CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
	(Andrey Utkin's message of "Sat, 15 Nov 2014 17:48:29 +0400")
MIME-Version: 1.0
Message-ID: <m3wq6ww602.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas or help?
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:

> In upstream there's no more module parameter for video standard
> (NTSC/PAL). But there's VIDIOC_S_STD handling procedure. But it turns
> out not to work correctly: the frame is offset, so that in the bottom
> there's black horizontal bar.
> The S_STD ioctl call actually makes difference, because without that
> the frame "slides" vertically all the time. But after the call the
> picture is not correct.

Which kernel version are you using?
I remember there were some problems with earlier versions, where the
NTSC vs PAL wasn't consistenly a bool but rather a raw register value
(or something like this), but it was fixed last time I checked.
I'm personally using SOLO6110-based cards with v3.17 and PAL and it
works, with minimal unrelated patches.

> Any ideas why wouldn't it work to change the mode after the driver load?
> Would it be allowed to add back that kernel module parameter (the one
> passed at module load time)?

I don't think this alone would help.

Looking at my patch queue (will try to remember to have them posted)...
Well, it could be the SDRAM size detection routine. I'm using cards with
64 MB of RAM and the routine repeatedly detected 128 MB or so (max
supported). I have a temporary fix for this but it needs a bit more
work, I have seen a case when it failed (I'm using ARM and MIPS
platforms and they may differ from x86 in endianness, cache coherency
etc).

If you have a card with 64 MB RAM you may want to check if the driver
detects it correctly, and if not e.g. hardcode the size. Otherwise,
I have no idea what could be wrong, it works for me.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
