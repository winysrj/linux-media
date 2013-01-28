Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1631 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3A1LAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 06:00:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 6/7] saa7134: v4l2-compliance: remove V4L2_IN_ST_NO_SYNC from enum_input
Date: Mon, 28 Jan 2013 12:00:27 +0100
Cc: Ondrej Zary <linux@rainbow-software.org>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org> <1359315912-1767-7-git-send-email-linux@rainbow-software.org> <20130128083046.206a3958@redhat.com>
In-Reply-To: <20130128083046.206a3958@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281200.27158.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 28 2013 11:30:46 Mauro Carvalho Chehab wrote:
> Em Sun, 27 Jan 2013 20:45:11 +0100
> Ondrej Zary <linux@rainbow-software.org> escreveu:
> 
> > Make saa7134 driver more V4L2 compliant: don't set bogus V4L2_IN_ST_NO_SYNC
> > flag in enum_input as it's for digital video only
> > 
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/media/pci/saa7134/saa7134-video.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> > index 0b42f0c..fff6735 100644
> > --- a/drivers/media/pci/saa7134/saa7134-video.c
> > +++ b/drivers/media/pci/saa7134/saa7134-video.c
> > @@ -1757,8 +1757,6 @@ static int saa7134_enum_input(struct file *file, void *priv,
> >  
> >  		if (0 != (v1 & 0x40))
> >  			i->status |= V4L2_IN_ST_NO_H_LOCK;
> > -		if (0 != (v2 & 0x40))
> > -			i->status |= V4L2_IN_ST_NO_SYNC;
> >  		if (0 != (v2 & 0x0e))
> >  			i->status |= V4L2_IN_ST_MACROVISION;
> >  	}
> 
> 
> Hmm... I'm not sure about this one. Very few drivers use those definitions,
> but I suspect that this might potentially break some userspace applications.
> 
> It sounds more likely that v4l-compliance is doing the wrong thing here,
> if it is complaining about that.

I agree. See my reply to this patch. I'd appreciate your input on that.

Regards,

	Hans
