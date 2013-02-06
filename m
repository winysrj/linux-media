Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:42525 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3BFJ5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 04:57:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR v3.9] Move cx2341x from media/i2c to media/common
Date: Wed, 6 Feb 2013 10:57:00 +0100
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <201301290956.20849.hverkuil@xs4all.nl> <201302060846.35774.hverkuil@xs4all.nl> <20130206071604.768c77b5@redhat.com>
In-Reply-To: <20130206071604.768c77b5@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061057.01005.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 6 February 2013 10:16:04 Mauro Carvalho Chehab wrote:
> Em Wed, 6 Feb 2013 08:46:35 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Tue February 5 2013 19:49:41 Mauro Carvalho Chehab wrote:
> > > Hi Hans,
> > > 
> > > Em Tue, 29 Jan 2013 09:56:20 +0100
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > 
> > > > Hi Mauro,
> > > > 
> > > > The cx2341x module is a helper module for conexant-based MPEG encoders.
> > > > It isn't an i2c module at all, instead it should be in common since it is
> > > > used by 7 pci and usb drivers to handle the MPEG setup.
> > > >     
> > > > It also shouldn't be visible in the config menu as it is always
> > > > selected automatically by those drivers that need it.
> > > 
> > > It should be noticed that the other non-i2c helper drivers also at
> > > the i2c directories:
> > > 	$ grep -L i2c_client drivers/media/i2c/*.c|grep -v mod
> > > 	drivers/media/i2c/aptina-pll.c
> > > 	drivers/media/i2c/btcx-risc.c
> > > 	drivers/media/i2c/cx2341x.c
> > > 	drivers/media/i2c/smiapp-pll.c
> > >
> > > A closer look may even hit some weird stuff, like tveeprom. This
> > > particular helper driver is not an I2C driver, although it
> > > has i2c_client symbol there, in order to optionally read the data
> > > via I2C, instead of receiving it via an API call.
> > 
> > At least aptina-pll.c, smiapp-pll.c and tveeprom.c all have some relationship
> > with i2c.
> 
> True, but none of the three are actually i2c drivers; they're just shared
> functions used by drivers helper code.
> 
> Hmm...
> 
> $ git grep aptina-pll.h drivers/media/
> drivers/media/i2c/aptina-pll.c:#include "aptina-pll.h"
> drivers/media/i2c/mt9m032.c:#include "aptina-pll.h"
> drivers/media/i2c/mt9p031.c:#include "aptina-pll.h"
> 
> $ git grep smiapp-pll.h drivers/media/
> drivers/media/i2c/smiapp-pll.c:#include "smiapp-pll.h"
> drivers/media/i2c/smiapp-pll.h: * drivers/media/i2c/smiapp-pll.h
> drivers/media/i2c/smiapp/smiapp.h:#include "smiapp-pll.h"
> 
> $ git grep smiapp.h drivers/media/
> drivers/media/i2c/smiapp/smiapp-core.c:#include "smiapp.h"
> drivers/media/i2c/smiapp/smiapp-limits.c:#include "smiapp.h"
> drivers/media/i2c/smiapp/smiapp-quirk.c:#include "smiapp.h"
> drivers/media/i2c/smiapp/smiapp-regs.c:#include "smiapp.h"
> drivers/media/i2c/smiapp/smiapp.h: * drivers/media/i2c/smiapp/smiapp.h
> drivers/media/i2c/smiapp/smiapp.h:#include <media/smiapp.h>
> 
> It could make sense to keep those two on I2c, eventually moving
> smapp-pl to i2c/smiapp. I have conflicting opinions here :)
> 
> > But cx2341x.c and btcx-risc.c do not have that at all. One reason
> > for creating this patch was that I couldn't find the cx2341x.c code until I
> > smiapp-pll.cdid a find.
> > 
> > > Also, I don't think cx2341x or any of those other helper drivers
> > > deserve each its own directory.
> > 
> > I thought that the cx2341x.c source in common looked a bit lonely.
> > But if we add other sources as well, then it has company :-)
> 
> :)
> 
> > > So, IMHO, the better is to just live them at the i2c directory.
> > 
> > For cx2341x and btcx-risc the i2c directory is completely inappropriate.
> > Nobody is ever going to guess that.
> 
> Agreed. Those are just leftovers of the tree reorg, as the final patch
> at v4l side were to rename "video" to "i2c".
> 
> > > They might be moved, instead, to drivers/media/common (but without
> > > creating subdirs there).
> > > 
> > > In any case, we should do the same for all those non-i2c helper
> > > drivers. Just moving cx2341x and letting the others there will just
> > > increase the mess.
> > 
> > I've no problem moving cx2341x, btcx-risc and tveeprom to common. For
> > the two pll sources I'd like to know if the authors agree (CC-ed) before
> > I make a patch moving them to common.
> 
> Fair enough.

OK, I'll prepare patches today moving cx2341x, btcx-risc and tveeprom to
common. I agree with Laurent that the pll sources are better placed in i2c,
at least for now.

Regards,

	Hans
