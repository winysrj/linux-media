Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43004 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbeKRSHX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Nov 2018 13:07:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: libcamera-devel@lists.libcamera.org,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 0/2] yavta: Add support for IPU3 raw 10-bit Bayer packed formats
Date: Sun, 18 Nov 2018 09:47:54 +0200
Message-Id: <20181118074756.30811-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update kernel headers to latest mainline release and add support for IPU3
defined formats to yavta.

Jacopo Mondi (2):
  Update kernel headers to v4.19
  Add support for IPU3 raw 10-bit Bayer packed formats

 include/linux/v4l2-common.h   |   1 +
 include/linux/v4l2-controls.h | 219 ++++++++++++++++++++++++++--------
 include/linux/videodev2.h     |  81 ++++++++-----
 yavta.c                       |   4 +
 4 files changed, 225 insertions(+), 80 deletions(-)

-- 
Regards,

Laurent Pinchart
