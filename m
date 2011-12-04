Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35399 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1LDPQj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Dec 2011 10:16:39 -0500
Received: by wgbdr13 with SMTP id dr13so5379144wgb.1
        for <linux-media@vger.kernel.org>; Sun, 04 Dec 2011 07:16:38 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Sylwester Nawrocki <snjw23@gmail.com>
Subject: [RFC/PATCH 0/5] v4l: New camera controls
Date: Sun,  4 Dec 2011 16:16:11 +0100
Message-Id: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I put some effort in preparing a documentation for a couple of new controls
in the camera control class. It's a preeliminary work, it's mainly just
documentation. There is yet no patches for any driver using these controls.
I just wanted to get some possible feedback on them, if this sort of stuff
is welcome and what might need to be done differently.


Thanks,
Sylwester


Heungjun Kim (1):
  uvc: Adapt the driver to new type of V4L2_CID_FOCUS_AUTO control

Sylwester Nawrocki (4):
  v4l: Convert V4L2_CID_FOCUS_AUTO control to a menu control
  v4l: Add V4L2_CID_METERING_MODE camera control
  v4l: Add V4L2_CID_EXPOSURE_BIAS camera control
  v4l: Add V4L2_CID_ISO and V4L2_CID_ISO_AUTO controls

 Documentation/DocBook/media/v4l/biblio.xml   |   11 +++
 Documentation/DocBook/media/v4l/controls.xml |  122 ++++++++++++++++++++++++-
 drivers/media/video/uvc/uvc_ctrl.c           |    9 ++-
 drivers/media/video/v4l2-ctrls.c             |   19 ++++-
 include/linux/videodev2.h                    |   19 ++++
 5 files changed, 173 insertions(+), 7 deletions(-)

--
1.7.4.1

