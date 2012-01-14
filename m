Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54330 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab2ANTfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 14:35:22 -0500
Received: by eaal12 with SMTP id l12so562456eaa.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 11:35:21 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC v3 0/3] JPEG codecs control class
Date: Sat, 14 Jan 2012 20:35:02 +0100
Message-Id: <1326569705-20261-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <20120114192414.05ad2e83@tele>
References: <20120114192414.05ad2e83@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this patch set adds new control class - V4L2_CID_JPEG_CLASS initially
containing four controls. It also adds V4L2_CID_JPEG_COMPRESSION_QUALITY
control to zc3xx gspca sub-device. The gspca patch has been tested with
v4l2ucp and v4l2-ctl.

The initial RFC can be found at
http://www.mail-archive.com/linux-media@vger.kernel.org/msg39012.html

Changes since v2:
 - improved gspca/z3cxx patch according Jef's comments;
 - removed patch adding jpeg quality control to gspca/sonixj;
 - patches 1/3, 2/3 are unchanged;

Changes since v1:
 - removed trailing 'S' from V4L2_CID_JPEG_ACTIVE_MARKERS;
 - removed V4L2_JPEG_ACTIVE_MARKER_DAC and V4L2_JPEG_ACTIVE_MARKER_DNL
   definitions as these are normally controlled by higher level compression
   attributes and shouldn't be allowed to be discarded independently;


Thanks,
Sylwester

Sylwester Nawrocki (3):
  V4L: Add JPEG compression control class
  V4L: Add JPEG compression control class documentation
  gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support

 Documentation/DocBook/media/v4l/biblio.xml         |   20 +++
 Documentation/DocBook/media/v4l/compat.xml         |   10 ++
 Documentation/DocBook/media/v4l/controls.xml       |  161 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |   16 ++-
 drivers/media/video/gspca/zc3xx.c                  |   45 ++++--
 drivers/media/video/v4l2-ctrls.c                   |   24 +++
 include/linux/videodev2.h                          |   24 +++
 8 files changed, 292 insertions(+), 17 deletions(-)

--
1.7.4.1

