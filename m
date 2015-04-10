Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14896 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbbDJOli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 10:41:38 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NML00D1LIC3VMB0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Apr 2015 15:45:39 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, 'David Airlie' <airlied@linux.ie>,
	'Mauro Carvalho Chehab' <mchehab@osg.samsung.com>,
	'Steve Longerbeam' <slongerbeam@gmail.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	'Ian Molton' <imolton@ad-holdings.co.uk>,
	'Jean-Michel Hautbois' <jean-michel.hautbois@vodalys.com>,
	kernel@pengutronix.de
References: <1426607290-13380-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1426607290-13380-1-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH 0/5] i.MX5/6 mem2mem scaler
Date: Fri, 10 Apr 2015 16:41:34 +0200
Message-id: <03c101d0739c$71eeeb40$55ccc1c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

From: linux-media-owner@vger.kernel.org [mailto:linux-media-
owner@vger.kernel.org] On Behalf Of Philipp Zabel
Sent: Tuesday, March 17, 2015 4:48 PM
> 
> Hi,
> 
> this series uses the IPU IC post-processing task, to implement a
> mem2mem device for scaling and colorspace conversion.

This patchset makes changes in two subsystems - media and gpu.
It would be good to merge these patchset through a single subsystem.

The media part of this patchset is good, are there any comments to
the gpu part of this patchset?

I talked with Mauro on the IRC and he acked that this patchset could be
merged via the gpu subsystem. 

Best wishes,
Kamil Debski

 
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
>  drivers/gpu/ipu-v3/ipu-ic.c                 | 787
> ++++++++++++++++++++++++-
>  drivers/media/platform/Kconfig              |   2 +
>  drivers/media/platform/Makefile             |   1 +
>  drivers/media/platform/imx/Kconfig          |  11 +
>  drivers/media/platform/imx/Makefile         |   2 +
>  drivers/media/platform/imx/imx-ipu-scaler.c | 869
> ++++++++++++++++++++++++++++
>  drivers/media/platform/imx/imx-ipu.c        | 313 ++++++++++
>  drivers/media/platform/imx/imx-ipu.h        |  36 ++
>  include/video/imx-ipu-v3.h                  |  49 +-
>  10 files changed, 2055 insertions(+), 17 deletions(-)  create mode
> 100644 drivers/media/platform/imx/Kconfig
>  create mode 100644 drivers/media/platform/imx/Makefile
>  create mode 100644 drivers/media/platform/imx/imx-ipu-scaler.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu.h
> 
> --
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

