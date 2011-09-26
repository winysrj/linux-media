Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33408 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1IZL0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:26:49 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 26 Sep 2011 16:56:37 +0530
Subject: RE: [PATCH RESEND 0/4] davinci vpbe: enable DM365 v4l2 display
 driver
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025729ADE6@dbde02.ent.ti.com>
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
 <4E7D187A.8060005@redhat.com>
In-Reply-To: <4E7D187A.8060005@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 24, 2011 at 05:08:34, Mauro Carvalho Chehab wrote:
> Em 19-09-2011 02:35, Manjunath Hadli escreveu:
> > The patchset adds incremental changes necessary to enable dm365
> > v4l2 display driver, which includes vpbe display driver changes, osd 
> > specific changes and venc changes. The changes are incremental in 
> > nature,addind a few HD modes, and taking care of register level 
> > changes.
> > 
> > The patch set does not include THS7303 amplifier driver which is 
> > planned to be sent seperately.
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
> 
> 
> Not sure why are you re-sending this patch series. To whom are you re-sending it? You have your git access at linuxtv.org. So, if the patches are ready for merge, just send me a pull request. Otherwise, please mark the patches as RFC or send to the one that will maintain the driver, c/c the mailing list.

Thank you Mauro. I will send you a pull request for the rest of the 
three patches.

-Manju
> 
> In any case, I'll mark the patches 2-4 as RFC (patch 1 is too trivial, I'll just apply it, to never see it again ;) ).
> 
> Thanks,
> Mauro
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" 
> > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 

