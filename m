Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab2G3Wmr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 18:42:47 -0400
Message-ID: <50170DE0.2030007@redhat.com>
Date: Mon, 30 Jul 2012 19:42:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org
Subject: Re: "[PULL] video_visstrim for 3.6"
References: <1343295404-8931-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1343295404-8931-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-07-2012 06:36, Javier Martin escreveu:
> Hi Mauro,
> this pull request is composed of two series that provide support for two mem2mem devices:
> - 'm2m-deinterlace' video deinterlacer
> - 'coda video codec'
> I've included platform support for them too.
> 
> 
> The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:
> 
>    Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
> 
> are available in the git repository at:
> 
>    https://github.com/jmartinc/video_visstrim.git for_3.6
> 
> for you to fetch changes up to 9bb10266da63ae7f8f198573e099580e9f98f4e8:
> 
>    i.MX27: Visstrim_M10: Add support for deinterlacing driver. (2012-07-26 10:57:30 +0200)
> 
> ----------------------------------------------------------------
> Javier Martin (5):
>        i.MX: coda: Add platform support for coda in i.MX27.
>        media: coda: Add driver for Coda video codec.
>        Visstrim M10: Add support for Coda.
>        media: Add mem2mem deinterlacing driver.
>        i.MX27: Visstrim_M10: Add support for deinterlacing driver.
> 
>   arch/arm/mach-imx/clk-imx27.c                   |    4 +-
>   arch/arm/mach-imx/devices-imx27.h               |    4 +
>   arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |   49 +-
>   arch/arm/plat-mxc/devices/Kconfig               |    6 +-
>   arch/arm/plat-mxc/devices/Makefile              |    1 +
>   arch/arm/plat-mxc/devices/platform-imx27-coda.c |   37 +
>   arch/arm/plat-mxc/include/mach/devices-common.h |    8 +

I need ARM maintainer's ack for the patches that touch the above files.

Regards,
Mauro
