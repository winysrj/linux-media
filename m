Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1674 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3BFHq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 02:46:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR v3.9] Move cx2341x from media/i2c to media/common
Date: Wed, 6 Feb 2013 08:46:35 +0100
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <201301290956.20849.hverkuil@xs4all.nl> <20130205164941.6052fd42@redhat.com>
In-Reply-To: <20130205164941.6052fd42@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302060846.35774.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue February 5 2013 19:49:41 Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Tue, 29 Jan 2013 09:56:20 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi Mauro,
> > 
> > The cx2341x module is a helper module for conexant-based MPEG encoders.
> > It isn't an i2c module at all, instead it should be in common since it is
> > used by 7 pci and usb drivers to handle the MPEG setup.
> >     
> > It also shouldn't be visible in the config menu as it is always
> > selected automatically by those drivers that need it.
> 
> It should be noticed that the other non-i2c helper drivers also at
> the i2c directories:
> 	$ grep -L i2c_client drivers/media/i2c/*.c|grep -v mod
> 	drivers/media/i2c/aptina-pll.c
> 	drivers/media/i2c/btcx-risc.c
> 	drivers/media/i2c/cx2341x.c
> 	drivers/media/i2c/smiapp-pll.c
>
> A closer look may even hit some weird stuff, like tveeprom. This
> particular helper driver is not an I2C driver, although it
> has i2c_client symbol there, in order to optionally read the data
> via I2C, instead of receiving it via an API call.

At least aptina-pll.c, smiapp-pll.c and tveeprom.c all have some relationship
with i2c. But cx2341x.c and btcx-risc.c do not have that at all. One reason
for creating this patch was that I couldn't find the cx2341x.c code until I
smiapp-pll.cdid a find.

> Also, I don't think cx2341x or any of those other helper drivers
> deserve each its own directory.

I thought that the cx2341x.c source in common looked a bit lonely.
But if we add other sources as well, then it has company :-)

> So, IMHO, the better is to just live them at the i2c directory.

For cx2341x and btcx-risc the i2c directory is completely inappropriate.
Nobody is ever going to guess that.

> They might be moved, instead, to drivers/media/common (but without
> creating subdirs there).
> 
> In any case, we should do the same for all those non-i2c helper
> drivers. Just moving cx2341x and letting the others there will just
> increase the mess.

I've no problem moving cx2341x, btcx-risc and tveeprom to common. For
the two pll sources I'd like to know if the authors agree (CC-ed) before
I make a patch moving them to common.

Regards,

	Hans

> 
> > 
> > This pull request moves it to the right directory.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:
> > 
> >   Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://linuxtv.org/hverkuil/media_tree.git cx2341x
> > 
> > for you to fetch changes up to 15ee97480694257081933f3f78666de1c88eec5e:
> > 
> >   cx2341x: move from media/i2c to media/common (2013-01-29 09:47:49 +0100)
> > 
> > ----------------------------------------------------------------
> > Hans Verkuil (1):
> >       cx2341x: move from media/i2c to media/common
> > 
> >  drivers/media/common/Kconfig                    |    1 +
> >  drivers/media/common/Makefile                   |    2 +-
> >  drivers/media/common/cx2341x/Kconfig            |    2 ++
> >  drivers/media/common/cx2341x/Makefile           |    1 +
> >  drivers/media/{i2c => common/cx2341x}/cx2341x.c |    0
> >  drivers/media/i2c/Kconfig                       |   14 --------------
> >  drivers/media/i2c/Makefile                      |    1 -
> >  7 files changed, 5 insertions(+), 16 deletions(-)
> >  create mode 100644 drivers/media/common/cx2341x/Kconfig
> >  create mode 100644 drivers/media/common/cx2341x/Makefile
> >  rename drivers/media/{i2c => common/cx2341x}/cx2341x.c (100%)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
