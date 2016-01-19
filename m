Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53137 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbcASKVD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 05:21:03 -0500
Date: Tue, 19 Jan 2016 08:20:52 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [GIT PULL for v4.5-rc1] media controller next gen patch series
Message-ID: <20160119082052.3bd42e7f@recife.lan>
In-Reply-To: <CAMuHMdX3ve8dy5B1PHkDHuzb-FbP4g6PC3=-o9F=z0aTWoST7Q@mail.gmail.com>
References: <20160112084328.2194ec49@recife.lan>
	<CAMuHMdX3ve8dy5B1PHkDHuzb-FbP4g6PC3=-o9F=z0aTWoST7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jan 2016 11:02:30 +0100
Geert Uytterhoeven <geert@linux-m68k.org> escreveu:

> Hi Mauro,
> 
> On Tue, Jan 12, 2016 at 11:43 AM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > That's the second part of the media patches. It contains the media controller
> > next generation patches, with is the result of one year of discussions and
> > development. It also contains patches to enable media controller support
> > at the DVB subsystem.
> >
> > The goal is to improve the media controller to allow proper support for
> > other types of Video4Linux devices (radio and TV ones) and to extend the
> > media controller functionality to allow it to be used by other subsystems
> > like DVB, ALSA and IIO.
> >
> > In order to use the new functionality, a new ioctl is needed
> > (MEDIA_IOC_G_TOPOLOGY). As we're still discussing how to pack the struct
> > fields of this ioctl in order to avoid compat32 issues, I decided to add
> > a patch at the end of this series commenting out the new ioctl, in order
> > to postpone the addition of the new ioctl to the next Kernel version (4.6).
> > With that, no userspace visible changes should happen at the media
> > controller API, as the existing ioctls are untouched. Yet, it helps
> > DVB, ALSA and IIO developers to develop and test the patches adding media
> > controller support there, as the core will contain all required internal
> > changes to allow adding support for devices that belong to those
> > subsystems.
> >
> > Regards,
> > Mauro
> >
> > The following changes since commit 768acf46e1320d6c41ed1b7c4952bab41c1cde79:
> >
> >   [media] rc: sunxi-cir: Initialize the spinlock properly (2015-12-23 15:51:40 -0200)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-2
> >
> > for you to fetch changes up to be0270ec89e6b9b49de7e533dd1f3a89ad34d205:
> >
> >   [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY (2016-01-11 12:35:17 -0200)  
> 
> After merging this into mainline, I get the BUG_ON() and crash I reported ca.
> one month ago in "vsp1 BUG_ON() and crash (Re: [PATCH v9 03/12] media:
> Entities, pads and links)" ( https://lkml.org/lkml/2015/12/14/373).

Not sure what happened here, as this was supposed to have fixed already.
I'll ask Javier to take a look into it and work with you for us to get it
fixed ASAP.

Regards,
Mauro

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
