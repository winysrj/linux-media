Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62327 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbeDQKW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 06:22:29 -0400
Date: Tue, 17 Apr 2018 07:22:21 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Mentz <danielmentz@google.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: Re: [PATCH 0/5] Remaining COMPILE_TEST and smatch cleanups
Message-ID: <20180417072221.04decc50@vento.lan>
In-Reply-To: <cover.1523960171.git.mchehab@s-opensource.com>
References: <cover.1523960171.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Apr 2018 06:20:10 -0400
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> There were several interactions at the COMPILE_TEST and smatch
> patch series. While I applied most of them, there are 5 patches that
> I kept out of it. The omap3 patch that were in my tree was the old
> one. So, I'm re-posting it.
> 
> The ioctl32 patches are the latest version. Let's repost it to get some
> acks, as this patch touches at V4L2 core, so a careful review is
> always a good idea.

Forgot to mention. If anyone wants to test, the patches are at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=compile_test_v6b

> 
> Arnd Bergmann (1):
>   media: omap3isp: allow it to build with COMPILE_TEST
> 
> Laurent Pinchart (1):
>   media: omap3isp: Enable driver compilation on ARM with COMPILE_TEST
> 
> Mauro Carvalho Chehab (3):
>   omap: omap-iommu.h: allow building drivers with COMPILE_TEST
>   media: v4l2-compat-ioctl32: fix several __user annotations
>   media: v4l2-compat-ioctl32: better name userspace pointers
> 
>  drivers/media/platform/Kconfig                |   7 +-
>  drivers/media/platform/omap3isp/isp.c         |   8 +
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 623 +++++++++++++-------------
>  include/linux/omap-iommu.h                    |   5 +
>  4 files changed, 338 insertions(+), 305 deletions(-)
> 



Thanks,
Mauro
