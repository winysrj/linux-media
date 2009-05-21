Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4079 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbZEUOOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 10:14:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "chaithrika" <chaithrika@ti.com>
Subject: Re: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Thu, 21 May 2009 16:14:34 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	"'Manjunath Hadli'" <mrh@ti.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>
References: <1241789126-23317-1-git-send-email-chaithrika@ti.com> <03fc01c9d9db$2f9f8b20$8edea160$@com>
In-Reply-To: <03fc01c9d9db$2f9f8b20$8edea160$@com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905211614.34701.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 21 May 2009 08:12:57 chaithrika wrote:
> Hi All,
>
> Do you have any review comments on this patch set?

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

I'm happy with these patches!

There is one thing that can be improved, though. It is really an enhancement 
and does not prevent this from being merged.

Currently the isr routine refuses to switch to the next frame if the dma 
queue is empty. However, I see no reason for this: it should always go to 
that frame regardless and keep that until new frames are queued. I've made 
this change in the (very old) driver I use at work, but this should become 
standard behavior.

Regards,

	Hans

>
> Regards,
> Chaithrika
>
> > -----Original Message-----
> > From: Chaithrika U S [mailto:chaithrika@ti.com]
> > Sent: Friday, May 08, 2009 6:55 PM
> > To: linux-media@vger.kernel.org
> > Cc: davinci-linux-open-source@linux.davincidsp.com; Manjunath Hadli;
> > Brijesh Jadav; Chaithrika U S
> > Subject: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display
> > driver
> >
> > Display driver for TI DM646x EVM
> >
> > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> >
> > These patches add the display driver support for TI DM646x EVM.
> > This patch set has been tested for basic display functionality for
> > Composite and Component outputs.
> >
> > This patch set consists of the updates based on the review comments by
> > Hans Verkuil.
> >
> > Patch 1: Display device platform and board setup
> > Patch 2: VPIF driver
> > Patch 3: DM646x display driver
> > Patch 4: Makefile and config files modifications for Display
> >
> > Some of the features like the HBI/VBI support are not yet implemented.
> > Also there are some known issues in the code implementation like
> > fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not been
> > tested extensively.
> >
> > -Chaithrika
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
