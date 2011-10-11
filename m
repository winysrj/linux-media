Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45939 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1JKPJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 11:09:25 -0400
Received: by wyg34 with SMTP id 34so7130346wyg.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 08:09:24 -0700 (PDT)
From: Enrico Butera <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Enrico Butera <ebutera@users.berlios.de>,
	linux-media@vger.kernel.org
Subject: [RFC 0/3] omap3isp: add BT656 support
Date: Tue, 11 Oct 2011 17:08:52 +0200
Message-Id: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add support for BT656 to omap3isp. It is based
on patches from Deepthy Ravi and Javier Martinez Canillas.

To be applied on top of omap3isp-omap3isp-yuv branch at:

git.linuxtv.org/pinchartl/media.git

Enrico Butera (2):
  omap3isp: ispvideo: export isp_video_mbus_to_pix
  omap3isp: ispccdc: configure CCDC registers and add BT656 support

Javier Martinez Canillas (1):
  omap3isp: ccdc: Add interlaced field mode to platform data

 drivers/media/video/omap3isp/ispccdc.c  |  143 ++++++++++++++++++++++++++-----
 drivers/media/video/omap3isp/ispccdc.h  |    1 +
 drivers/media/video/omap3isp/ispreg.h   |    1 +
 drivers/media/video/omap3isp/ispvideo.c |    2 +-
 drivers/media/video/omap3isp/ispvideo.h |    4 +-
 include/media/omap3isp.h                |    3 +
 6 files changed, 129 insertions(+), 25 deletions(-)

-- 
1.7.4.1

