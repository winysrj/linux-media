Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965080AbcKDRyA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 13:54:00 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCHv2 0/2] vsp1 writeback prototype
Date: Fri,  4 Nov 2016 17:53:50 +0000
Message-Id: <1478282032-17571-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resending this patch series to bring in dri-devel, and interested parties.
Apologies for the resend to linux-media and linux-renesas-soc.

This short series extends the VSP1 on the RCar platforms to allow creating a
V4L2 video node on display pipelines where the hardware allows writing to
memory simultaneously.

In this instance, the hardware restricts the output to match the display size
(no rescaling) but does allow pixel format conversion.

A current limitation (that the DRI devs might have ideas about) is that the vb2
buffers are swapped on the atomic_flush() calls rather than on vsync events.

Ideally swapping buffers would occur on every vsync such that the output rate
of the video node would match the display rate, however the timing here proves
more difficult to synchronise the updates from a vysnc and flush without adding
latency to the flush.

Is there anything I can do to synchronise the v4l2 buffers with the DRM/KMS
interfaces currently? Or does anyone have any suggestions for extending as
such?

And of course ideas on anything that could be done generically to support other
targets as well would be worth considering - though currently this
implementation is very RCar/VSP1 specific.


Kieran Bingham (2):
  Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
  v4l: vsp1: Provide a writeback video device

 drivers/media/platform/vsp1/vsp1.h       |   1 +
 drivers/media/platform/vsp1/vsp1_drm.c   |  19 ++++
 drivers/media/platform/vsp1/vsp1_drv.c   |   5 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h  |   1 +
 drivers/media/platform/vsp1/vsp1_video.c | 161 ++++++++++++++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_video.h |   5 +
 drivers/media/platform/vsp1/vsp1_wpf.c   |  19 +++-
 7 files changed, 193 insertions(+), 18 deletions(-)

-- 
2.7.4

