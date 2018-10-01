Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46738 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbeJASZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 14:25:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
Date: Mon, 01 Oct 2018 14:48:10 +0300
Message-ID: <2438028.OjeO6a9KTA@avalon>
In-Reply-To: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday, 1 October 2018 11:43:04 EEST Hans Verkuil wrote:
> It turns out that we have both JPEG and Motion-JPEG pixel formats defined.
> 
> Furthermore, some drivers support one, some the other and some both.
> 
> These pixelformats both mean the same.

Do they ? I thought MJPEG was JPEG using fixed Huffman tables that were not 
included in the JPEG headers.

> I propose that we settle on JPEG (since it seems to be used most often) and
> add JPEG support to those drivers that currently only use MJPEG.
> 
> We also need to update the V4L2_PIX_FMT_JPEG documentation since it just
> says TBD:
> 
> https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-compresse
> d.html
> 
> $ git grep -l V4L2_PIX_FMT_MJPEG
> drivers/media/pci/meye/meye.c
> drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> drivers/media/platform/sti/delta/delta-cfg.h
> drivers/media/platform/sti/delta/delta-mjpeg-dec.c
> drivers/media/usb/cpia2/cpia2_v4l.c
> drivers/media/usb/go7007/go7007-driver.c
> drivers/media/usb/go7007/go7007-fw.c
> drivers/media/usb/go7007/go7007-v4l2.c
> drivers/media/usb/s2255/s2255drv.c
> drivers/media/usb/uvc/uvc_driver.c
> drivers/staging/media/zoran/zoran_driver.c
> drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
> drivers/usb/gadget/function/uvc_v4l2.c
> 
> It looks like s2255 and cpia2 support both already, so that would leave
> 8 drivers that need to be modified, uvc being the most important of the
> lot.
> 
> Any comments?

-- 
Regards,

Laurent Pinchart
