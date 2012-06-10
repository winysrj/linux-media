Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:37885 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab2FJUXC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 16:23:02 -0400
Received: from [192.168.239.74] (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da01.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q5AKMsFZ019825
	for <linux-media@vger.kernel.org>; Sun, 10 Jun 2012 23:22:57 +0300
Message-ID: <4FD50223.4030501@iki.fi>
Date: Sun, 10 Jun 2012 23:22:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.6] V4L2 API cleanups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two V4L2 API cleanup patches; the first removes __user from
videodev2.h from a few places, making it possible to use the header file
as such in user space, while the second one changes the
v4l2_buffer.input field back to reserved.


The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
09:27:24 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6

Sakari Ailus (2):
      v4l: Remove __user from interface structure definitions
      v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT

 Documentation/DocBook/media/v4l/compat.xml      |   12 ++++++++++++
 Documentation/DocBook/media/v4l/io.xml          |   19 +++++--------------
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml |    9 +++------
 drivers/media/video/cpia2/cpia2_v4l.c           |    2 +-
 drivers/media/video/v4l2-compat-ioctl32.c       |   11 +++++------
 drivers/media/video/videobuf-core.c             |   16 ----------------
 drivers/media/video/videobuf2-core.c            |    5 ++---
 include/linux/videodev2.h                       |    9 ++++-----
 8 files changed, 32 insertions(+), 51 deletions(-)


Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

