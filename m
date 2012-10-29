Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32946 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab2J2LTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 07:19:36 -0400
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCN00JMNJHDRF70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Oct 2012 11:20:01 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MCN00CJYJGLTZ20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Oct 2012 11:19:34 +0000 (GMT)
Message-id: <508E6644.4040104@samsung.com>
Date: Mon, 29 Oct 2012 12:19:32 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/2] Fix a few more warnings
References: <1351506118-2385-1-git-send-email-mchehab@redhat.com>
In-reply-to: <1351506118-2385-1-git-send-email-mchehab@redhat.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/2012 11:21 AM, Mauro Carvalho Chehab wrote:
> Hans Verkuil yesterday's build still got two warnings at the
> generic drivers:
>         http://hverkuil.home.xs4all.nl/logs/Sunday.log
> 
> They didn't appear at i386 build probably because of some
> optimization done there.
> 
> Anyway, fixing them are trivial, so let's do it.
> 
> After applying those patches, the only drivers left producing
> warnings are the following platform drivers:
> 
> drivers/media/platform/davinci/dm355_ccdc.c
> drivers/media/platform/davinci/dm644x_ccdc.c
> drivers/media/platform/davinci/vpbe_osd.c
> drivers/media/platform/omap3isp/ispccdc.c
> drivers/media/platform/omap3isp/isph3a_aewb.c
> drivers/media/platform/omap3isp/isph3a_af.c
> drivers/media/platform/omap3isp/isphist.c
> drivers/media/platform/omap3isp/ispqueue.c
> drivers/media/platform/omap3isp/ispvideo.c
> drivers/media/platform/omap/omap_vout.c
> drivers/media/platform/s5p-fimc/fimc-capture.c
> drivers/media/platform/s5p-fimc/fimc-lite.c

For these two files I've sent already a pull request [1], which
includes a fixup patch
s5p-fimc: Don't ignore return value of vb2_queue_init()

BTW, shouldn't things like these be taken care when someone does
a change at the core code ? I'm not having issues in this case at all,
but if there is many people doing constantly changes at the core it
might imply for driver authors/maintainers wasting much of their time
for fixing issues resulting from constant changes at the base code.

Thanks,
Sylwester

> drivers/media/platform/sh_vou.c
> drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> 
> Platform driver maintainers: please fix, as those warnings could be
> hiding real bugs. Also, removing all warnings is interesting,
> as they helps to detect when new possible bugs got introduced.
> 
> I think Hans also use "make W=1" option when doing his tests.
> 
> Mauro Carvalho Chehab (2):
>   [media] drxk_hard: fix the return code from an error handler
>   [media] xc4000: Fix a few warnings
> 
>  drivers/media/dvb-frontends/drxk_hard.c | 1 +
>  drivers/media/tuners/xc4000.c           | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

[1] http://patchwork.linuxtv.org/patch/15195/

