Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:42001 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbcCSVBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 17:01:46 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH RFC 0/2] pxa_camera transition to v4l2 standalone device
Date: Sat, 19 Mar 2016 22:01:26 +0100
Message-Id: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Guennadi,

As Hans is converting sh_mobile_ceu_camera.c, let's see how close our ports are
to see if there are things we could either reuse of change.

The port is assuming :
 - the formation translation is transferred into soc_mediabus, so that it can be
   reused across all v4l2 devices
 - pxa_camera is ported

This sets a ground of discussion for soc_camera adherence removal from
pxa_camera. I'd like to have a comment from Hans if this is what he has in mind,
and Guennadi if he agrees to transfer the soc xlate stuff to soc_mediabus.

Cheers.

--
Robert

Robert Jarzmik (2):
  media: platform: transfer format translations to soc_mediabus
  media: platform: pxa_camera: make a standalone v4l2 device

 drivers/media/platform/soc_camera/pxa_camera.c   | 715 +++++++++++++----------
 drivers/media/platform/soc_camera/soc_camera.c   |   7 +-
 drivers/media/platform/soc_camera/soc_mediabus.c |  65 +++
 include/linux/platform_data/media/camera-pxa.h   |   2 +
 include/media/drv-intf/soc_mediabus.h            |  22 +
 include/media/soc_camera.h                       |  15 -
 6 files changed, 495 insertions(+), 331 deletions(-)

-- 
2.1.4

