Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59808 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab1D3Ndm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:33:42 -0400
Received: from localhost.localdomain (unknown [91.178.80.7])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3115135995
	for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 13:33:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] uvcvideo: Media controller support
Date: Sat, 30 Apr 2011 15:34:01 +0200
Message-Id: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

These patches implement support for the media controller API in the uvcvideo
driver. UVC devices report their internal topology to the host through USB
descriptors, and the topology is then further exported to userspace through
the MC API.

Note that all links are immutable, as UVC doesn't allow runtime links
configuration. Furthermore the V4L2 subdev pad-level API isn't used, formats
are controlled through V4L2 device nodes only. The MC API is thus totally
optional, non MC-aware applications won't notice any change in the driver
behaviour.

As the MC API is marked as experimental, should I make MC support conditionally
compilable, and add a configuration menu entry to enable/disable it ?

Laurent Pinchart (4):
  uvcvideo: Register a v4l2_device
  uvcvideo: Register subdevices for each entity
  uvcvideo: Connect video devices to media entities
  v4l: Release module if subdev registration fails

 drivers/media/video/uvc/Makefile     |    2 +-
 drivers/media/video/uvc/uvc_driver.c |   58 +++++++++++++++--
 drivers/media/video/uvc/uvc_entity.c |  118 ++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |   18 +++++
 drivers/media/video/v4l2-device.c    |    5 +-
 5 files changed, 192 insertions(+), 9 deletions(-)
 create mode 100644 drivers/media/video/uvc/uvc_entity.c

-- 
Regards,

Laurent Pinchart

