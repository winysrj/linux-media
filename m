Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:46031 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbaLRQUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 11:20:17 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com,
	dheitmueller@kernellabs.com, prabhakar.csengg@gmail.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	ttmesterr@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] au0828 vb2 conversion
Date: Thu, 18 Dec 2014 09:20:09 -0700
Message-Id: <cover.1418918401.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series includes patch v2 of the au0828 vb2 conversion,
removing video and vbi buffer timeout handling, and a patch to
not set fmt.pix.priv.

The following work is in progress and will be as separate patches:
- removing users and using v4l2_fh_is_singular_file() instead.
- Changing dynamic allocation of video device structs to static
  which will reduce the overhead to allocate at register time and
  deallocating at unregister.
 
Shuah Khan (3):
  media: au0828 - convert to use videobuf2
  media: au0828 change to not zero out fmt.pix.priv
  media: au0828 remove video and vbi buffer timeout work-around

 drivers/media/usb/au0828/Kconfig        |   2 +-
 drivers/media/usb/au0828/au0828-cards.c |   2 +-
 drivers/media/usb/au0828/au0828-vbi.c   | 122 ++--
 drivers/media/usb/au0828/au0828-video.c | 994 +++++++++++---------------------
 drivers/media/usb/au0828/au0828.h       |  64 +-
 5 files changed, 414 insertions(+), 770 deletions(-)

-- 
2.1.0

