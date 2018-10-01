Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50574 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728804AbeJAPTr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 11:19:47 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
Date: Mon, 1 Oct 2018 10:43:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It turns out that we have both JPEG and Motion-JPEG pixel formats defined.

Furthermore, some drivers support one, some the other and some both.

These pixelformats both mean the same.

I propose that we settle on JPEG (since it seems to be used most often) and
add JPEG support to those drivers that currently only use MJPEG.

We also need to update the V4L2_PIX_FMT_JPEG documentation since it just says
TBD:

https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-compressed.html

$ git grep -l V4L2_PIX_FMT_MJPEG
drivers/media/pci/meye/meye.c
drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
drivers/media/platform/sti/delta/delta-cfg.h
drivers/media/platform/sti/delta/delta-mjpeg-dec.c
drivers/media/usb/cpia2/cpia2_v4l.c
drivers/media/usb/go7007/go7007-driver.c
drivers/media/usb/go7007/go7007-fw.c
drivers/media/usb/go7007/go7007-v4l2.c
drivers/media/usb/s2255/s2255drv.c
drivers/media/usb/uvc/uvc_driver.c
drivers/staging/media/zoran/zoran_driver.c
drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
drivers/usb/gadget/function/uvc_v4l2.c

It looks like s2255 and cpia2 support both already, so that would leave
8 drivers that need to be modified, uvc being the most important of the
lot.

Any comments?

Regards,

	Hans
