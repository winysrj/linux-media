Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:40651 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbcEMRJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 13:09:57 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, g.liakhovetski@gmx.de,
	jh1009.sung@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Media Device Allocator API 
Date: Fri, 13 May 2016 11:09:22 -0600
Message-Id: <cover.1463158822.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media Device Allocator API to allows multiple drivers share a media device.
Using this API, drivers can allocate a media device with the shared struct
device as the key. Once the media device is allocated by a driver, other
drivers can get a reference to it. The media device is released when all
the references are released.

This patch series has been tested with au0828 and snd-usb-audio drivers.
snd-usb-audio patch isn't included in this series. Once this patch series
is reviews and gets a stable state, I will send out the snd-usb-audio
patch.

Shuah Khan (3):
  media: Media Device Allocator API
  media: add media_device_unregister_put() interface
  media: change au0828 to use Media Device Allocator API

 drivers/media/Makefile                 |   3 +-
 drivers/media/media-dev-allocator.c    | 139 +++++++++++++++++++++++++++++++++
 drivers/media/media-device.c           |  11 +++
 drivers/media/usb/au0828/au0828-core.c |  12 +--
 drivers/media/usb/au0828/au0828.h      |   1 +
 include/media/media-dev-allocator.h    | 118 ++++++++++++++++++++++++++++
 include/media/media-device.h           |  15 ++++
 7 files changed, 290 insertions(+), 9 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h

-- 
2.7.4

