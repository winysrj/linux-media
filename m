Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33189 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab2JDFYh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Oct 2012 01:24:37 -0400
Message-ID: <506D1D7C.10605@ti.com>
Date: Thu, 4 Oct 2012 10:54:12 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LMML <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR v3.7] v4l2-ctrl feature enhancement
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull the following patches which adds a new feature and
a new control to v4l2-ctrl framework. One of the patch includes usage of
the new control in the driver.

Thanks and Regards,
--Prabhakar Lad


The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx
(2012-10-02 17:15:22 -0300)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git v4l2-ctrls-pull

Lad, Prabhakar (3):
      media: v4l2-ctrls: add control for test pattern
      media: v4l2-ctrl: add a helper function to add standard control
with driver specific menu
      media: mt9p031/mt9t001/mt9v032: use V4L2_CID_TEST_PATTERN for test
pattern control

 Documentation/DocBook/media/v4l/controls.xml |   10 +++++
 Documentation/video4linux/v4l2-controls.txt  |   24 +++++++++++
 drivers/media/i2c/mt9p031.c                  |   19 ++-------
 drivers/media/i2c/mt9t001.c                  |   22 +++++++---
 drivers/media/i2c/mt9v032.c                  |   54
+++++++++++++++++---------
 drivers/media/v4l2-core/v4l2-ctrls.c         |   32 +++++++++++++++
 include/linux/v4l2-controls.h                |    1 +
 include/media/v4l2-ctrls.h                   |   23 +++++++++++
 8 files changed, 145 insertions(+), 40 deletions(-)
