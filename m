Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:61329 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AYU0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 15:26:44 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so328211eaa.11
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 12:26:43 -0800 (PST)
Message-ID: <5102EA80.2080105@gmail.com>
Date: Fri, 25 Jan 2013 21:26:40 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.9] OV9650 image sensor driver, v4l2-ctrl/core extensions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This change set includes the Omnivision OV9650/52 sensor driver and a 
couple
related patches, adding v4l2 core helper functions and a header defining
standard image sizes. Please pull.

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

   Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 
18:49:18 -0200)

are available in the git repository at:

   git://linuxtv.org/snawrocki/media.git ov965x

Sylwester Nawrocki (6):
       V4L: Add header file defining standard image sizes
       v4l2-ctrl: Add helper function for the controls range update
       V4L: Add v4l2_event_subdev_unsubscribe() helper function
       V4L: Add v4l2_ctrl_subdev_subscribe_event() helper function
       V4L: Add v4l2_ctrl_subdev_log_status() helper function
       V4L: Add driver for OV9650/52 image sensors

  Documentation/DocBook/media/v4l/compat.xml         |    4 +
  Documentation/DocBook/media/v4l/v4l2.xml           |    4 +-
  Documentation/DocBook/media/v4l/vidioc-dqevent.xml |    6 +
  drivers/media/i2c/Kconfig                          |    7 +
  drivers/media/i2c/Makefile                         |    1 +
  drivers/media/i2c/ov9650.c                         | 1562 
++++++++++++++++++++
  drivers/media/v4l2-core/v4l2-ctrls.c               |  159 ++-
  drivers/media/v4l2-core/v4l2-event.c               |    7 +
  include/media/ov9650.h                             |   27 +
  include/media/v4l2-ctrls.h                         |   28 +
  include/media/v4l2-event.h                         |    4 +-
  include/media/v4l2-image-sizes.h                   |   34 +
  include/uapi/linux/videodev2.h                     |    1 +
  13 files changed, 1803 insertions(+), 41 deletions(-)
  create mode 100644 drivers/media/i2c/ov9650.c
  create mode 100644 include/media/ov9650.h
  create mode 100644 include/media/v4l2-image-sizes.h

The corresponding pwclient commands are:

pwclient -s accepted 16435
pwclient -s accepted 16436
pwclient -s accepted 16437
pwclient -s accepted 16438
pwclient -s accepted 16439
pwclient -s accepted 16440

--

Regards,
Sylwester
