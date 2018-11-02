Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbeKBJgv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 05:36:51 -0400
From: shuah@kernel.org
To: mchehab@kernel.org, perex@perex.cz, tiwai@suse.com
Cc: Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH v8 0/4] Media Device Allocator API
Date: Thu,  1 Nov 2018 18:31:29 -0600
Message-Id: <cover.1541118238.git.shuah@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shuah Khan <shuah@kernel.org>

This patch series has been on the ice for the last couple of years.
Mauro asked me to restart the discussion on this and see if we can
make progress.

I rebased the series to Linux 4.19. It has been surprisingly well
preserved with one small merge conflict resolved in 0004.

Media Device Allocator API to allows multiple drivers share a media device.
Using this API, drivers can allocate a media device with the shared struct
device as the key. Once the media device is allocated by a driver, other
drivers can get a reference to it. The media device is released when all
the references are released.

- No changes to 0001,0002 code since the v7 referenced below.
- 0003 is a new patch to enable ALSA defines that have been
  disabled for kernel between 4.9 and 4.19.
- Minor merge conflict resolution in 0004.
- Added SPDX to new files.

References:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg105854.html

Please review. I am sending this as RFC even though it has been tested
several times prior to this non-event rebased v8. I ran sanity tests.

Shuah Khan (4):
  media: Media Device Allocator API
  media: change au0828 to use Media Device Allocator API
  media: media.h: Enable ALSA MEDIA_INTF_T* interface types
  sound/usb: Use Media Controller API to share media resources

 Documentation/media/kapi/mc-core.rst   |  37 +++
 drivers/media/Makefile                 |   3 +-
 drivers/media/media-dev-allocator.c    | 132 ++++++++++
 drivers/media/usb/au0828/au0828-core.c |  12 +-
 drivers/media/usb/au0828/au0828.h      |   1 +
 include/media/media-dev-allocator.h    |  53 ++++
 include/uapi/linux/media.h             |  25 +-
 sound/usb/Kconfig                      |   4 +
 sound/usb/Makefile                     |   2 +
 sound/usb/card.c                       |  14 ++
 sound/usb/card.h                       |   3 +
 sound/usb/media.c                      | 320 +++++++++++++++++++++++++
 sound/usb/media.h                      |  73 ++++++
 sound/usb/mixer.h                      |   3 +
 sound/usb/pcm.c                        |  29 ++-
 sound/usb/quirks-table.h               |   1 +
 sound/usb/stream.c                     |   2 +
 sound/usb/usbaudio.h                   |   6 +
 18 files changed, 692 insertions(+), 28 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.17.0
