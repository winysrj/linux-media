Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45211 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1JJKG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 06:06:56 -0400
Received: by yxl31 with SMTP id 31so5183097yxl.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 03:06:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s3GJ7-By=q_ADa6qcpaENK5kXvkTG8Hd=Y+qXs9dgXa0w@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
	<CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
	<CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
	<201110081751.38953.laurent.pinchart@ideasonboard.com>
	<CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
	<CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
	<CAAwP0s3NFvvUYd-0kwKLKXfYB4Zx1nXb0nd9+JM61JWtrVFfRg@mail.gmail.com>
	<CA+2YH7uFeHAmEpVqbd94qtCajb45pkr9YzeW+RDa5sf2bUG_wQ@mail.gmail.com>
	<CAAwP0s3GJ7-By=q_ADa6qcpaENK5kXvkTG8Hd=Y+qXs9dgXa0w@mail.gmail.com>
Date: Mon, 10 Oct 2011 12:06:55 +0200
Message-ID: <CA+2YH7subMzFAg7f7-uHXEmYBD+Kd1=E2nWKx7dgKCEpOu=zgQ@mail.gmail.com>
Subject: Re: omap3-isp status
From: Enrico <ebutera@users.berlios.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 10, 2011 at 11:02 AM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> Is your tree (igep 3.1.0rc9 kernel + omap3isp-yuv patches) accessible
> so I can clone and give a try?
>
> I can then make a patch-set on top on that, one that I can actually
> test on real hardware and be sure that is working well.
>
> If I can git clone your tree then it will be faster, otherwise I will
> try omap3isp-yuv with igep board support added, but it would take me
> more time to do so. I will find some free time late this afternoon to
> try that.

I have updated my igep openembedded layer at [1] (testing branch) with:

current igep master kernel (3.1.0rc9) + omap3isp-yuv patches + your
patches v2 + tvp5150 patches + some tvp5150 and board files fixes.

All the patches (specified in the .bb file) are git am-able patches so
you can just clone the igep master repository and apply all the
patches (0001-0025).

This is the cover letter for the patches i applied, if someone can
review the omap3isp related patches to be sure i didn't forget
anything it would be very helpful:

Arnaud Lacombe (1):
  drivers/media: do not use EXTRA_CFLAGS

Enrico Butera (3):
  tvp5150: compile fixes and added missing entity_cleanup
  exp-igep0022: add tvp5151 support
  igep00x0: fix camera platform data

Guennadi Liakhovetski (1):
  omap3isp: ccdc: remove redundant operation

Ivaylo Petrov (1):
  omap3isp: csi2: Add V4L2_MBUS_FMT_YUYV8_2X8 support

Javier Martinez Canillas (6):
  omap3isp: ccdc: Add interlaced field mode to platform data
  omap3isp: ccdc: Add interlaced count field to isp_ccdc_device
  omap3isp: ccdc: Add support to ITU-R BT.656 video data format
  tvp5150: Add constants for PAL and NTSC video standards
  tvp5150: Add video format registers configuration values
  tvp5150: Migrate to media-controller framework and add video format
    detection

Laurent Pinchart (12):
  omap3isp: Don't accept pipelines with no video source as valid
  omap3isp: Move platform data definitions from isp.h to
    media/omap3isp.h
  omap3isp: Don't fail streamon when the sensor doesn't implement
    s_stream
  omap3isp: video: Avoid crashes when pipeline set stream operation
    fails
  omap3isp: Move media_entity_cleanup() from unregister() to cleanup()
  omap3isp: Move *_init_entities() functions to the init/cleanup
    section
  omap3isp: Add missing mutex_destroy() calls
  omap3isp: Fix memory leaks in initialization error paths
  omap3isp: video: Split format info bpp field into width and bpp
  omap3isp: ccdc: Remove support for interlaced data and master HS/VS
    mode
  omap3isp: ccdc: Remove ispccdc_syncif structure
  omap3isp: ccdc: Add YUV input formats support

Michael Jones (1):
  omap3isp: queue: fail QBUF if user buffer is too small

 arch/arm/mach-omap2/board-igep00x0.c       |   67 +++++
 arch/arm/mach-omap2/exp-igep0022.c         |    3 +
 drivers/media/video/omap3isp/Makefile      |    4 +-
 drivers/media/video/omap3isp/isp.c         |   13 +-
 drivers/media/video/omap3isp/isp.h         |   87 +------
 drivers/media/video/omap3isp/ispccdc.c     |  376 ++++++++++++++++----------
 drivers/media/video/omap3isp/ispccdc.h     |   38 +---
 drivers/media/video/omap3isp/ispccp2.c     |  129 +++++-----
 drivers/media/video/omap3isp/ispcsi2.c     |  118 +++++---
 drivers/media/video/omap3isp/isph3a_aewb.c |    2 +-
 drivers/media/video/omap3isp/isph3a_af.c   |    2 +-
 drivers/media/video/omap3isp/isphist.c     |    2 +-
 drivers/media/video/omap3isp/isppreview.c  |  108 ++++----
 drivers/media/video/omap3isp/ispqueue.c    |    4 +
 drivers/media/video/omap3isp/ispresizer.c  |  104 ++++----
 drivers/media/video/omap3isp/ispstat.c     |   52 ++--
 drivers/media/video/omap3isp/ispstat.h     |    2 +-
 drivers/media/video/omap3isp/ispvideo.c    |   77 ++++--
 drivers/media/video/omap3isp/ispvideo.h    |    5 +-
 drivers/media/video/tvp5150.c              |  408 +++++++++++++++++++++++++++-
 drivers/media/video/tvp5150_reg.h          |   17 +-
 include/media/omap3isp.h                   |  138 ++++++++++
 include/media/tvp5150.h                    |    6 +
 23 files changed, 1215 insertions(+), 547 deletions(-)
 create mode 100644 include/media/omap3isp.h

Enrico
