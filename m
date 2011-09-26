Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2489 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1IZLRB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:17:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: Re: [PATCH RESEND 0/4] davinci vpbe: enable DM365 v4l2 display driver
Date: Mon, 26 Sep 2011 13:16:52 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com> <B85A65D85D7EB246BE421B3FB0FBB593025729ADE3@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593025729ADE3@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261316.52134.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, September 19, 2011 07:49:18 Hadli, Manjunath wrote:
> Sakari, Hans,
>  Can I request you to have a look at these patches too?

It's on my TODO list for this week.

Regards,

	Hans

> 
> Thanks and Regards,
> -Manju
> 
> On Mon, Sep 19, 2011 at 11:05:25, Hadli, Manjunath wrote:
> > The patchset adds incremental changes necessary to enable dm365
> > v4l2 display driver, which includes vpbe display driver changes, osd specific changes and venc changes. The changes are incremental in nature,addind a few HD modes, and taking care of register level changes.
> > 
> > The patch set does not include THS7303 amplifier driver which is planned to be sent seperately.
> > 
> > 
> > Manjunath Hadli (4):
> >   davinci vpbe: remove unused macro.
> >   davinci vpbe: add dm365 VPBE display driver changes
> >   davinci vpbe: add dm365 and dm355 specific OSD changes
> >   davinci vpbe: add VENC block changes to enable dm365 and dm355
> > 
> >  drivers/media/video/davinci/vpbe.c         |   55 +++-
> >  drivers/media/video/davinci/vpbe_display.c |    1 -
> >  drivers/media/video/davinci/vpbe_osd.c     |  474 +++++++++++++++++++++++++---
> >  drivers/media/video/davinci/vpbe_venc.c    |  205 +++++++++++--
> >  include/media/davinci/vpbe.h               |   16 +
> >  include/media/davinci/vpbe_venc.h          |    4 +
> >  6 files changed, 686 insertions(+), 69 deletions(-)
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
