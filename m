Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54835 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1IZL2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:28:53 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 26 Sep 2011 16:58:31 +0530
Subject: RE: [PATCH RESEND 0/4] davinci vpbe: enable DM365 v4l2 display
 driver
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025729ADE7@dbde02.ent.ti.com>
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB593025729ADE3@dbde02.ent.ti.com>
 <201109261316.52134.hverkuil@xs4all.nl>
In-Reply-To: <201109261316.52134.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 26, 2011 at 16:46:52, Hans Verkuil wrote:
> On Monday, September 19, 2011 07:49:18 Hadli, Manjunath wrote:
> > Sakari, Hans,
> >  Can I request you to have a look at these patches too?
> 
> It's on my TODO list for this week.
Thank you Hans.
I will pull request nevertheless, and Mauro can take a call if he wants to defer.

Thx,
-Manju

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Thanks and Regards,
> > -Manju
> > 
> > On Mon, Sep 19, 2011 at 11:05:25, Hadli, Manjunath wrote:
> > > The patchset adds incremental changes necessary to enable dm365
> > > v4l2 display driver, which includes vpbe display driver changes, osd specific changes and venc changes. The changes are incremental in nature,addind a few HD modes, and taking care of register level changes.
> > > 
> > > The patch set does not include THS7303 amplifier driver which is planned to be sent seperately.
> > > 
> > > 
> > > Manjunath Hadli (4):
> > >   davinci vpbe: remove unused macro.
> > >   davinci vpbe: add dm365 VPBE display driver changes
> > >   davinci vpbe: add dm365 and dm355 specific OSD changes
> > >   davinci vpbe: add VENC block changes to enable dm365 and dm355
> > > 
> > >  drivers/media/video/davinci/vpbe.c         |   55 +++-
> > >  drivers/media/video/davinci/vpbe_display.c |    1 -
> > >  drivers/media/video/davinci/vpbe_osd.c     |  474 +++++++++++++++++++++++++---
> > >  drivers/media/video/davinci/vpbe_venc.c    |  205 +++++++++++--
> > >  include/media/davinci/vpbe.h               |   16 +
> > >  include/media/davinci/vpbe_venc.h          |    4 +
> > >  6 files changed, 686 insertions(+), 69 deletions(-)
> > > 
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" 
> > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

