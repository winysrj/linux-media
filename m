Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44512 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbcDVJHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 05:07:05 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0B96818021C
	for <linux-media@vger.kernel.org>; Fri, 22 Apr 2016 11:07:00 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] Drop obsolete 'experimental' annotations
Date: Fri, 22 Apr 2016 11:06:57 +0200
Message-Id: <1461316019-2497-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Both in videodev2.h and in the documentation there are a lot of features
marked 'experimental' that have been around for years. Remove these
annotations since it was pure laziness that we didn't do that before.

Regards,

	Hans

Hans Verkuil (2):
  videodev2.h: remove 'experimental' annotations.
  DocBook media: drop 'experimental' annotations

 Documentation/DocBook/media/v4l/compat.xml         | 38 ----------------------
 Documentation/DocBook/media/v4l/controls.xml       | 31 ------------------
 Documentation/DocBook/media/v4l/dev-sdr.xml        |  6 ----
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  6 ----
 Documentation/DocBook/media/v4l/io.xml             |  6 ----
 Documentation/DocBook/media/v4l/selection-api.xml  |  9 +----
 Documentation/DocBook/media/v4l/subdev-formats.xml |  6 ----
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  6 ----
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  6 ----
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |  6 ----
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |  6 ----
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |  6 ----
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  6 ----
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |  6 ----
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |  6 ----
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |  6 ----
 .../media/v4l/vidioc-subdev-enum-frame-size.xml    |  6 ----
 .../media/v4l/vidioc-subdev-enum-mbus-code.xml     |  6 ----
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      |  6 ----
 .../media/v4l/vidioc-subdev-g-frame-interval.xml   |  6 ----
 .../media/v4l/vidioc-subdev-g-selection.xml        |  6 ----
 include/uapi/linux/videodev2.h                     | 38 ++++++----------------
 22 files changed, 11 insertions(+), 213 deletions(-)

-- 
2.8.0.rc3

