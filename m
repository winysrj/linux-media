Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34750 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbDPUzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 16:55:00 -0400
Received: by laat2 with SMTP id t2so66080602laa.1
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 13:54:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428574888-46407-7-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl> <1428574888-46407-7-git-send-email-hverkuil@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 16 Apr 2015 21:54:28 +0100
Message-ID: <CA+V-a8u3BaODyopxt16LVx-TX0z09fRBhZocJLt5mB-NZVcqXQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] v4l2: replace s_mbus_fmt by set_fmt in bridge drivers
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Thu, Apr 9, 2015 at 11:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Replace all calls to s_mbus_fmt in bridge drivers by calls to the
> set_fmt pad op.
>
> Remove the old try/s_mbus_fmt video ops since they are now no longer used.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/pci/cx18/cx18-controls.c             | 13 +++--
>  drivers/media/pci/cx18/cx18-ioctl.c                | 12 +++--
>  drivers/media/pci/cx23885/cx23885-video.c          | 12 +++--
>  drivers/media/pci/ivtv/ivtv-controls.c             | 12 +++--
>  drivers/media/pci/ivtv/ivtv-ioctl.c                | 12 +++--
>  drivers/media/pci/saa7134/saa7134-empress.c        | 10 ++--
>  drivers/media/platform/am437x/am437x-vpfe.c        | 19 ++-----
>  drivers/media/platform/blackfin/bfin_capture.c     |  8 +--
>  drivers/media/platform/marvell-ccic/mcam-core.c    |  8 +--
>  drivers/media/platform/sh_vou.c                    | 61 ++++++++++++----------
>  drivers/media/platform/soc_camera/atmel-isi.c      | 27 +++++-----
>  drivers/media/platform/soc_camera/mx2_camera.c     | 35 +++++++------
>  drivers/media/platform/soc_camera/mx3_camera.c     | 31 ++++++-----
>  drivers/media/platform/soc_camera/omap1_camera.c   | 44 +++++++++-------
>  drivers/media/platform/soc_camera/pxa_camera.c     | 33 ++++++------
>  drivers/media/platform/soc_camera/rcar_vin.c       |  4 +-
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |  8 +--
>  drivers/media/platform/soc_camera/soc_scale_crop.c | 37 +++++++------
>  drivers/media/platform/via-camera.c                |  8 +--
>  drivers/media/usb/cx231xx/cx231xx-417.c            | 12 +++--
>  drivers/media/usb/cx231xx/cx231xx-video.c          | 23 ++++----
>  drivers/media/usb/em28xx/em28xx-camera.c           | 12 +++--
>  drivers/media/usb/go7007/go7007-v4l2.c             | 12 +++--
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c            | 17 +++---
>  include/media/v4l2-subdev.h                        |  8 ---
>  25 files changed, 256 insertions(+), 222 deletions(-)
>
for am437x

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
