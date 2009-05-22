Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56846 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZEVEhP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 00:37:15 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4M4bCnF002360
	for <linux-media@vger.kernel.org>; Thu, 21 May 2009 23:37:17 -0500
From: "chaithrika" <chaithrika@ti.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	"'Manjunath Hadli'" <mrh@ti.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>
References: <1241789126-23317-1-git-send-email-chaithrika@ti.com> <03fc01c9d9db$2f9f8b20$8edea160$@com> <200905211614.34701.hverkuil@xs4all.nl>
In-Reply-To: <200905211614.34701.hverkuil@xs4all.nl>
Subject: RE: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Fri, 22 May 2009 10:06:39 +0530
Message-ID: <048b01c9da96$e6013c40$b203b4c0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Thursday, May 21, 2009 7:45 PM
> To: chaithrika
> Cc: linux-media@vger.kernel.org; davinci-linux-open-
> source@linux.davincidsp.com; 'Manjunath Hadli'; 'Brijesh Jadav'
> Subject: Re: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display
> driver
> 
> On Thursday 21 May 2009 08:12:57 chaithrika wrote:
> > Hi All,
> >
> > Do you have any review comments on this patch set?
> 
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> I'm happy with these patches!
> 

Thanks!

> There is one thing that can be improved, though. It is really an
> enhancement
> and does not prevent this from being merged.
> 
> Currently the isr routine refuses to switch to the next frame if the
> dma
> queue is empty. However, I see no reason for this: it should always go
> to
> that frame regardless and keep that until new frames are queued. I've
> made
> this change in the (very old) driver I use at work, but this should
> become
> standard behavior.
> 

OK. I will look into this.

Thanks,
Chaithrika

> Regards,
> 
> 	Hans
> 
> >
> > Regards,
> > Chaithrika
> >
> > > -----Original Message-----
> > > From: Chaithrika U S [mailto:chaithrika@ti.com]
> > > Sent: Friday, May 08, 2009 6:55 PM
> > > To: linux-media@vger.kernel.org
> > > Cc: davinci-linux-open-source@linux.davincidsp.com; Manjunath
> Hadli;
> > > Brijesh Jadav; Chaithrika U S
> > > Subject: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display
> > > driver
> > >
> > > Display driver for TI DM646x EVM
> > >
> > > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > > Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> > >
> > > These patches add the display driver support for TI DM646x EVM.
> > > This patch set has been tested for basic display functionality for
> > > Composite and Component outputs.
> > >
> > > This patch set consists of the updates based on the review comments
> by
> > > Hans Verkuil.
> > >
> > > Patch 1: Display device platform and board setup
> > > Patch 2: VPIF driver
> > > Patch 3: DM646x display driver
> > > Patch 4: Makefile and config files modifications for Display
> > >
> > > Some of the features like the HBI/VBI support are not yet
> implemented.
> > > Also there are some known issues in the code implementation like
> > > fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not
> been
> > > tested extensively.
> > >
> > > -Chaithrika
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG


