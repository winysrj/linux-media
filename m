Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44148 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbbCXQJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 12:09:52 -0400
Received: from [172.22.20.229] (unknown [12.104.145.3])
	by tschai.lan (Postfix) with ESMTPSA id 5B3FF2A0092
	for <linux-media@vger.kernel.org>; Tue, 24 Mar 2015 17:09:33 +0100 (CET)
Message-ID: <55118C48.106@xs4all.nl>
Date: Tue, 24 Mar 2015 09:09:44 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] Various fixes & ov2659 sensor driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8a56b6b5fd6ff92b7e27d870b803b11b751660c2:

  [media] v4l2-subdev: remove enum_framesizes/intervals (2015-03-23 12:02:41 -0700)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1n

for you to fetch changes up to c4fc844c104c475f8d6f954dfd519023545b4bbd:

  media: i2c: add support for omnivision's ov2659 sensor (2015-03-24 09:01:52 -0700)

----------------------------------------------------------------
Benoit Parrot (1):
      media: i2c: add support for omnivision's ov2659 sensor

Hans Verkuil (4):
      DocBook media: improve event documentation
      DocBook media: fix BT.2020 description
      vivid-tpg.c: fix wrong Bt.2020 coefficients
      DocBook media: improve V4L2_DV_FL_HALF_LINE documentation

Michael Opdenacker (1):
      DocBook media: fix broken EIA hyperlink

 Documentation/DocBook/media/v4l/biblio.xml                  |   11 +-
 Documentation/DocBook/media/v4l/compat.xml                  |    2 +-
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml          |    2 +-
 Documentation/DocBook/media/v4l/pixfmt.xml                  |    8 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml          |  115 +++++++-
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml     |    9 +-
 Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml |    2 +-
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml  |  111 +-------
 Documentation/devicetree/bindings/media/i2c/ov2659.txt      |   38 +++
 MAINTAINERS                                                 |   10 +
 drivers/media/i2c/Kconfig                                   |   11 +
 drivers/media/i2c/Makefile                                  |    1 +
 drivers/media/i2c/ov2659.c                                  | 1509 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-tpg.c                    |    4 +-
 include/media/ov2659.h                                      |   34 +++
 15 files changed, 1736 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2659.txt
 create mode 100644 drivers/media/i2c/ov2659.c
 create mode 100644 include/media/ov2659.h
