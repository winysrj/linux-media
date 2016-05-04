Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:34242 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbcEDXY5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 19:24:57 -0400
Date: Wed, 4 May 2016 20:24:48 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
Message-ID: <20160504232446.GA17293@pirotess.lan>
References: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
 <20160504211444.GA23122@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160504211444.GA23122@acer>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/Mai/2016 00:14, Andrey Utkin wrote:
> On Wed, May 04, 2016 at 01:21:20PM -0300, Ismael Luceno wrote:
> > From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> > 
> > Such frame size is met in practice. Also report oversized frames.
> > 
> > [ismael: Reworked warning and commit message]
> > 
> > Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
> 
> I object against merging the first part.
> 
> > ---
> >  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> > index 67a14c4..f98017b 100644
> > --- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> > +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> > @@ -33,7 +33,7 @@
> >  #include "solo6x10-jpeg.h"
> >  
> >  #define MIN_VID_BUFFERS		2
> > -#define FRAME_BUF_SIZE		(196 * 1024)
> > +#define FRAME_BUF_SIZE		(200 * 1024)
> 
> Please don't push this.
> It doesn't matter whether there are 196 or 200 KiB because there happen
> bigger frames.
> I don't remember details so I cannot point to all time max frame size.
> AFAIK this issue appeared on one particular customer installation. I
> don't monitor it closely right now. I think I have compiled custom
> package for that setup with FRAME_BUF_SIZE increased much more (maybe
> 10x?).

I don't quite remember the overscan, but the maximum should be around
1.2MB, so yes. If the QM hasn't been tweaked, then the image must
be terrible.
