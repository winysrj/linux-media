Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab1IWXij (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 19:38:39 -0400
Message-ID: <4E7D187A.8060005@redhat.com>
Date: Fri, 23 Sep 2011 20:38:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH RESEND 0/4] davinci vpbe: enable DM365 v4l2 display driver
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-09-2011 02:35, Manjunath Hadli escreveu:
> The patchset adds incremental changes necessary to enable dm365
> v4l2 display driver, which includes vpbe display driver changes,
> osd specific changes and venc changes. The changes are incremental
> in nature,addind a few HD modes, and taking care of register level
> changes.
> 
> The patch set does not include THS7303 amplifier driver which is planned
> to be sent seperately.
> 
> 
> Manjunath Hadli (4):
>   davinci vpbe: remove unused macro.
>   davinci vpbe: add dm365 VPBE display driver changes
>   davinci vpbe: add dm365 and dm355 specific OSD changes
>   davinci vpbe: add VENC block changes to enable dm365 and dm355
> 
>  drivers/media/video/davinci/vpbe.c         |   55 +++-
>  drivers/media/video/davinci/vpbe_display.c |    1 -
>  drivers/media/video/davinci/vpbe_osd.c     |  474 +++++++++++++++++++++++++---
>  drivers/media/video/davinci/vpbe_venc.c    |  205 +++++++++++--
>  include/media/davinci/vpbe.h               |   16 +
>  include/media/davinci/vpbe_venc.h          |    4 +
>  6 files changed, 686 insertions(+), 69 deletions(-)


Not sure why are you re-sending this patch series. To whom are you
re-sending it? You have your git access at linuxtv.org. So, if the patches
are ready for merge, just send me a pull request. Otherwise, please mark
the patches as RFC or send to the one that will maintain the driver, c/c the
mailing list.

In any case, I'll mark the patches 2-4 as RFC (patch 1 is too trivial, I'll
just apply it, to never see it again ;) ).

Thanks,
Mauro
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

