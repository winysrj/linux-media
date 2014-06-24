Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:51039 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbaFXX5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 19:57:51 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, olebowle@gmx.com,
	ttmesterr@gmail.com, dheitmueller@kernellabs.com,
	cb.xiong@samsung.com, yongjun_wei@trendmicro.com.cn,
	hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	crope@iki.fi, wade_farnsworth@mentor.com, ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH 0/4] media: tuner large grain locking
Date: Tue, 24 Jun 2014 17:57:27 -0600
Message-Id: <cover.1403652043.git.shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a managed token resource that can be created at device level
which can be used as a large grain lock by diverse group of drivers
such as the media drivers that share a resource.

Token resource manages a unique named string resource which is
derived from common bus_name, and hardware address fields from
the struct device.

au0828 is changed to use token devres as a large locking
for exclusive access to tuner function. A new tuner_tkn
field is added to struct au0828_dev. Tuner token is created
from au0828 probe() and destroyed from disconnect().

Two new routines au0828_create_token_resources() and
au0828_destroy_token_resources() create and destroy the
tuner token.

au0828-dvb exports the tuner token to dvb-frontend when
it registers the digital frontend using the tuner_tkn
field in struct dvb_frontend.

au0828-video exports the tuner token to v4l2-core when
it registers the analog function using tuner_tkn field
in struct video_device.

Before this change:

- digital tv app disrupts an active analog app when it
  tries to use the tuner
  e.g:  tvtime analog video stream stops when kaffeine starts
- analog tv app disrupts another analog app when it tries to
  use the tuner
  e.g: tvtime audio glitches when xawtv starts and vice versa.
- analog tv app disrupts an active digital app when it tries
  to use the tuner
  e.g: kaffeine digital stream stops when tvtime starts
- digital tv app disrupts another digital tv app when it tries
  to use the tuner
  e.g: kaffeine digital stream stops when vlc starts and vice
  versa

After this change:
- digital tv app detects tuner is busy without disrupting
  the active app.
- analog tv app detects tuner is busy without disrupting
  the active analog app.
- analog tv app detects tuner is busy without disrupting
  the active digital app.
- digital tv app detects tuner is busy without disrupting
  the active digital app.

Requesting feedback on any use-cases I missed and overall
approach to solving the contention between media functions.

Shuah Khan (4):
  drivers/base: add managed token dev resource
  media: dvb-fe changes to use tuner token
  media: v4l2-core changes to use tuner token
  media: au0828 changes to use token devres for tuner access

 drivers/base/Makefile                   |    2 +-
 drivers/base/token_devres.c             |  134 +++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.c   |   21 +++++
 drivers/media/dvb-core/dvb_frontend.h   |    1 +
 drivers/media/usb/au0828/au0828-core.c  |   42 ++++++++++
 drivers/media/usb/au0828/au0828-dvb.c   |    1 +
 drivers/media/usb/au0828/au0828-video.c |    4 +
 drivers/media/usb/au0828/au0828.h       |    4 +
 drivers/media/v4l2-core/v4l2-dev.c      |   23 +++++-
 include/linux/token_devres.h            |   19 +++++
 include/media/v4l2-dev.h                |    1 +
 11 files changed, 250 insertions(+), 2 deletions(-)
 create mode 100644 drivers/base/token_devres.c
 create mode 100644 include/linux/token_devres.h

-- 
1.7.10.4

