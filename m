Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27083 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523Ab2EKQvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 12:51:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3V0001XARZR690@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 May 2012 17:50:23 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3V00IDGAT3IU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 May 2012 17:51:03 +0100 (BST)
Date: Fri, 11 May 2012 18:51:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 3.5] New camera controls
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>
Message-id: <4FAD4378.6070305@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

this pull request includes an addition of new controls for camera,
to allow the users to configure parameters like exposure bias, white
balance presets, ISO sensitivity, exposure metering mode, scene mode,
wide dynamic range, image stabilization, auto focus and 3A locking.
All these controls are needed for the M-5MOLS sensor driver and also
for a similar Samsung S5C73M3 sensor that I'm working on a driver for,
which is planned for v3.6.

This change set depends on my previous pull request:
http://patchwork.linuxtv.org/patch/11140/

The following changes since commit 4f863c9082847c9836b8a1a07bc55c2625c902fe:

  V4L: Extend V4L2_CID_COLORFX with more image effects (2012-05-11 13:24:34 +0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l-camera-controls

for you to fetch changes up to ceca92a28073f46b0db4ad1cd93e0ae10800763f:

  m5mols: Add 3A lock control (2012-05-11 13:25:55 +0200)

----------------------------------------------------------------
Sylwester Nawrocki (21):
      V4L: Add helper function for standard integer menu controls
      V4L: Add camera exposure bias control
      V4L: Add an extended camera white balance control
      V4L: Add camera wide dynamic range control
      V4L: Add camera image stabilization control
      V4L: Add camera ISO sensitivity controls
      V4L: Add camera exposure metering control
      V4L: Add camera scene mode control
      V4L: Add camera 3A lock control
      V4L: Add camera auto focus controls
      m5mols: Convert macros to inline functions
      m5mols: Refactored controls handling
      m5mols: Use proper sensor mode for the controls
      m5mols: Add ISO sensitivity controls
      m5mols: Add auto and preset white balance control
      m5mols: Add exposure bias control
      m5mols: Add wide dynamic range control
      m5mols: Add image stabilization control
      m5mols: Add exposure metering control
      m5mols: Add JPEG compression quality control
      m5mols: Add 3A lock control

 Documentation/DocBook/media/v4l/biblio.xml   |   11 +++
 Documentation/DocBook/media/v4l/compat.xml   |   19 ++++
 Documentation/DocBook/media/v4l/controls.xml |  432
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 Documentation/DocBook/media/v4l/v4l2.xml     |    9 +-
 Documentation/video4linux/v4l2-controls.txt  |   21 +++++
 drivers/media/video/m5mols/m5mols.h          |   81 ++++++++++++-----
 drivers/media/video/m5mols/m5mols_capture.c  |   11 +--
 drivers/media/video/m5mols/m5mols_controls.c |  479
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------
 drivers/media/video/m5mols/m5mols_core.c     |   93 ++------------------
 drivers/media/video/m5mols/m5mols_reg.h      |    1 +
 drivers/media/video/v4l2-ctrls.c             |  110 ++++++++++++++++++++++-
 include/linux/videodev2.h                    |   72 +++++++++++++++
 include/media/v4l2-ctrls.h                   |   17 ++++
 13 files changed, 1162 insertions(+), 194 deletions(-)

--

Regards,
Sylwester
