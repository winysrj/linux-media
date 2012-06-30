Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65156 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2F3TY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 15:24:29 -0400
Received: by eeit10 with SMTP id t10so1687663eei.19
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 12:24:28 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: posciak@google.com, andrzej.p@samsung.com, hans.verkuil@cisco.com,
	hdegoede@redhat.com, javier.martin@vista-silicon.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, mchehab@infradead.org,
	m.szyprowski@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC 0/2] V4L: Add V4L2_CAP_VIDEO_M2M capability
Date: Sat, 30 Jun 2012 21:23:41 +0200
Message-Id: <1341084223-4616-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently mem-to-mem devices are identified through V4L2_CAP_VIDEO_CAPTURE
and V4L2_CAP_VIDEO_OUTPUT capabilities. This is not reliable and may
lead to false identification of mem-to-mem devices as video capture
or output devices, if an application doesn't check both flags.

As a follow up to an RFC from Kamil
http://www.mail-archive.com/linux-media@vger.kernel.org/msg22363.html
this changeset adds new capability flags for mem-to-mem devices:
V4L2_CAP_VIDEO_M2M and V4L2_CAP_VIDEO_M2M_MPLANE.

For backward compatibility with existing applications Capture and Output
capability flags are not removed at the drivers. These are intended
to be removed later after some transition period.

However, in practice I wouldn't expect problems, as all current
mem-to-mem drivers are now for embedded devices. So two kernel
releases transition period might be an overkill here.

Comments ?

Regards,
Sylwester

Sylwester Nawrocki (2):
  V4L: Add capability flags for memory-to-memory devices
  Feature removal: Using capture and output capabilities for m2m devices

 Documentation/DocBook/media/v4l/compat.xml         |    9 +++++++++
 .../DocBook/media/v4l/vidioc-querycap.xml          |   13 +++++++++++++
 Documentation/feature-removal-schedule.txt         |   14 ++++++++++++++
 drivers/media/video/mem2mem_testdev.c              |    4 +---
 drivers/media/video/mx2_emmaprp.c                  |   10 +++++++---
 drivers/media/video/s5p-fimc/fimc-m2m.c            |    7 ++++++-
 drivers/media/video/s5p-g2d/g2d.c                  |    9 +++++++--
 drivers/media/video/s5p-jpeg/jpeg-core.c           |   10 +++++++---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |   10 ++++++++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |   11 ++++++++---
 include/linux/videodev2.h                          |    4 ++++
 11 files changed, 84 insertions(+), 17 deletions(-)

--
1.7.4.1

