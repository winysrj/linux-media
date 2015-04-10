Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35776 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbbDJNEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 09:04:08 -0400
Received: by obbfy7 with SMTP id fy7so13098826obb.2
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2015 06:04:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Fri, 10 Apr 2015 15:03:52 +0200
Message-ID: <CAL8zT=gah6tuBKUGJTiNCcxmbqF759SFteYY2hAA=nJWFPt=UQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] i.MX5/6 mem2mem scaler
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the series !

2015-03-18 11:22 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi,
>
> this series uses the IPU IC post-processing task, to implement
> a mem2mem device for scaling and colorspace conversion. The first
> version had a fixup applied to the wrong patch.
>
> Changes since v1:
>  - Removed deinterlacer support left-overs
>
> regards
> Philipp
>
> Philipp Zabel (3):
>   gpu: ipu-v3: Add missing IDMAC channel names
>   gpu: ipu-v3: Add mem2mem image conversion support to IC
>   gpu: ipu-v3: Register scaler platform device
>
> Sascha Hauer (2):
>   [media] imx-ipu: Add ipu media common code
>   [media] imx-ipu: Add i.MX IPUv3 scaler driver
>
>  drivers/gpu/ipu-v3/ipu-common.c             |   2 +
>  drivers/gpu/ipu-v3/ipu-ic.c                 | 787 ++++++++++++++++++++++++-
>  drivers/media/platform/Kconfig              |   2 +
>  drivers/media/platform/Makefile             |   1 +
>  drivers/media/platform/imx/Kconfig          |  11 +
>  drivers/media/platform/imx/Makefile         |   2 +
>  drivers/media/platform/imx/imx-ipu-scaler.c | 869 ++++++++++++++++++++++++++++
>  drivers/media/platform/imx/imx-ipu.c        | 313 ++++++++++
>  drivers/media/platform/imx/imx-ipu.h        |  36 ++
>  include/video/imx-ipu-v3.h                  |  49 +-
>  10 files changed, 2055 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/media/platform/imx/Kconfig
>  create mode 100644 drivers/media/platform/imx/Makefile
>  create mode 100644 drivers/media/platform/imx/imx-ipu-scaler.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu.h

It works here, even if v4l2-compliance seems a bit disappointed :
fail: /run/media/jm/SSD_JM/Projets/vodabox3/poky/build/tmp/work/cortexa9hf-vfp-neon-poky-linux-gnueabi/v4l-utils/git-r0/git/utils/v4l2-compliance/v4l2-test-formats.cpp(425):
unknown pixelformat 00000000 for buftype 1
        test VIDIOC_G_FMT: FAIL
        test VIDIOC_TRY_FMT: OK (Not Supported)
        test VIDIOC_S_FMT: OK (Not Supported)
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        fail: /run/media/jm/SSD_JM/Projets/vodabox3/poky/build/tmp/work/cortexa9hf-vfp-neon-poky-linux-gnueabi/v4l-utils/git-r0/git/utils/v4l2-compliance/v4l2-test-formats.cpp(1200):
doioctl(node, VIDIOC_G_SELECTION, &sel_crop)
        fail: /run/media/jm/SSD_JM/Projets/vodabox3/poky/build/tmp/work/cortexa9hf-vfp-neon-poky-linux-gnueabi/v4l-utils/git-r0/git/utils/v4l2-compliance/v4l2-test-formats.cpp(1270):
testBasicCrop(node, V4L2_BUF_TYPE_VIDEO_CAPTURE)
        test Cropping: FAIL
        test Composing: OK (Not Supported)
        fail: /run/media/jm/SSD_JM/Projets/vodabox3/poky/build/tmp/work/cortexa9hf-vfp-neon-poky-linux-gnueabi/v4l-utils/git-r0/git/utils/v4l2-compliance/v4l2-test-formats.cpp(1381):
doioctl(node, VIDIOC_S_FMT, &fmt)
        fail: /run/media/jm/SSD_JM/Projets/vodabox3/poky/build/tmp/work/cortexa9hf-vfp-neon-poky-linux-gnueabi/v4l-utils/git-r0/git/utils/v4l2-compliance/v4l2-test-formats.cpp(1478):
doioctl(node, VIDIOC_S_FMT, &fmt)
        test Scaling: FAIL

    Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

    Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
        fail: /run/media/jm/SSD_JM/Projets/vodabox3/poky/build/tmp/work/cortexa9hf-vfp-neon-poky-linux-gnueabi/v4l-utils/git-r0/git/utils/v4l2-compliance/v4l2-test-buffers.cpp(548):
q.has_expbuf(node)
        test VIDIOC_EXPBUF: FAIL

Maybe should it be corrected before acceptation ?
Nothing to worry, though...

JM
