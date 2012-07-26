Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60166 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2GZDmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 23:42:38 -0400
Received: by vcbfk26 with SMTP id fk26so1275259vcb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 20:42:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50105C50.8020306@gmail.com>
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
	<50105C50.8020306@gmail.com>
Date: Thu, 26 Jul 2012 09:12:37 +0530
Message-ID: <CAOD6ATqoj6AbYHfE8OwE4GU99q2L+phF9==0rFHpyCm94bTMew@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add new driver for generic scaler
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Jul 26, 2012 at 2:21 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
>
> Hi,
>
> On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
> > This patch adds support for the gscaler device which is a new device
> > for scaling and color space conversion on EXYNOS5 SoCs.
> >
> > This device supports the followings as key feature.
> >   1) Input image format
> >     - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, TILE
> >   2) Output image format
> >     - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, YUV444
> >   3) Input rotation
> >     - 0/90/180/270 degree, X/Y Flip
> >   4) Scale ratio
> >     - 1/16 scale down to 8 scale up
> >   5) CSC
> >     - RGB to YUV / YUV to RGB
> >   6) Size
> >     - 2048 x 2048 for tile or rotation
> >     - 4800 x 3344 other case
> >
> > changes since v2:
> > - Rebased on latest media-tree git, branch staging/for_v3.6.
> >       http://linuxtv.org/git/media_tree.git
> > - Addressed review comments from Pawel Osciak and Sylwester Nawrocki
> >       https://patchwork.kernel.org/patch/1159031/
> > - Split the v2 patch into multiple patches
> >
> > Note: This patch set is based on the following two patches
> >    1] "V4L: Remove "_ACTIVE" from the selection target name definitions"
> >    2] "v4l: add fourcc definitions for new formats"
> >
> > Shaik Ameer Basha (2):
> >    v4l: Add new YVU420 multi planar fourcc definition
> >    media: gscaler: Add Makefile for G-Scaler Driver
> >
> > Sungchun Kang (3):
> >    media: gscaler: Add new driver for generic scaler
> >    media: gscaler: Add core functionality for the G-Scaler driver
> >    media: gscaler: Add m2m functionality for the G-Scaler driver
>
> There is following build error after applying this patch series:
>
>  CC      drivers/media/video/exynos-gsc/gsc-core.o
> In file included from drivers/media/video/exynos-gsc/gsc-core.c:30:0:
> drivers/media/video/exynos-gsc/gsc-core.h: In function ‘is_tiled’:
> drivers/media/video/exynos-gsc/gsc-core.h:430:29: error:
> ‘V4L2_PIX_FMT_NV12MT_16X16’ undeclared (first use in this function)
> drivers/media/video/exynos-gsc/gsc-core.h:430:29: note: each undeclared
> identifier is reported only once for each function it appears in
> drivers/media/video/exynos-gsc/gsc-core.c: At top level:
> drivers/media/video/exynos-gsc/gsc-core.c:191:18: error:
> ‘V4L2_PIX_FMT_NV12MT_16X16’ undeclared here (not in a function)
> make[4]: *** [drivers/media/video/exynos-gsc/gsc-core.o] Error 1
> make[3]: *** [drivers/media/video/exynos-gsc] Error 2
> make[2]: *** [drivers/media/video] Error 2
> make[1]: *** [drivers/media] Error 2
> make: *** [drivers] Error 2
>
>

As mentioned above in "Note:" section,
this patch is based on the following two patches...
1] "V4L: Remove "_ACTIVE" from the selection target name definitions"
2] "v4l: add fourcc definitions for new formats"

If you apply the second patch by "Arun Kumar K"
[http://patchwork.linuxtv.org/patch/13317/]
the build errors will be resolved.

> >
> >   Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |   97 ++-
> >   drivers/media/video/Kconfig                        |    8 +
> >   drivers/media/video/Makefile                       |    2 +
> >   drivers/media/video/exynos-gsc/Makefile            |    3 +
> >   drivers/media/video/exynos-gsc/gsc-core.c          | 1261
> > ++++++++++++++++++++
> >   drivers/media/video/exynos-gsc/gsc-core.h          |  537 +++++++++
> >   drivers/media/video/exynos-gsc/gsc-m2m.c           |  781 ++++++++++++
> >   drivers/media/video/exynos-gsc/gsc-regs.c          |  450 +++++++
> >   drivers/media/video/exynos-gsc/gsc-regs.h          |  172 +++
> >   include/linux/videodev2.h                          |    1 +
> >   10 files changed, 3298 insertions(+), 14 deletions(-)
> >   create mode 100644 drivers/media/video/exynos-gsc/Makefile
> >   create mode 100644 drivers/media/video/exynos-gsc/gsc-core.c
> >   create mode 100644 drivers/media/video/exynos-gsc/gsc-core.h
> >   create mode 100644 drivers/media/video/exynos-gsc/gsc-m2m.c
> >   create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.c
> >   create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.h
> >
>

Regards,
Shaik Ameer Basha

p.s: this message is resent because the previous message was not
delivered to linux-media@vger.kernel.org
