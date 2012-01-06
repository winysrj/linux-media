Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46880 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030385Ab2AFSO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:14:57 -0500
Received: by eekc4 with SMTP id c4so1234158eek.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:14:56 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH/RFC v2 0/4] JPEG codecs control class
Date: Fri,  6 Jan 2012 19:14:38 +0100
Message-Id: <1325873682-3754-1-git-send-email-snjw23@gmail.com>
In-Reply-To: <4EBECD11.8090709@gmail.com>
References: <4EBECD11.8090709@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds new control class - V4L2_CID_JPEG_CLASS with initially
four controls in it. It also adds V4L2_CID_JPEG_COMPRESSION_QUALITY control
to two gspca sub-devices: sonixj and zc3xx, as these where drivers I had
the hardware handy for. The gspca patches have been tested with v4l2ucp
and v4l2-ctl.

I could provide patches for some other drivers that currently use
VIDIOC_S/G_JPEGCOMP ioctls for image quality setting only.

The initial RFC can be found at
http://www.mail-archive.com/linux-media@vger.kernel.org/msg39012.html

Changes since v1 [1]:
 - renamed trailing 'S' from V4L2_CID_JPEG_ACTIVE_MARKERS;
 - removed V4L2_JPEG_ACTIVE_MARKER_DAC and V4L2_JPEG_ACTIVE_MARKER_DNL
   definitions as these are normally controlled by higher level compression
   attributes and shouldn't be allowed to be discarded independently;

These patches are intended for v3.4. Comments are welcome.


Sylwester Nawrocki (4):
  V4L: Add JPEG compression control class
  V4L: Add JPEG compression control class documentation
  gspca: sonixj: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
  gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support

 Documentation/DocBook/media/v4l/biblio.xml         |   20 +++
 Documentation/DocBook/media/v4l/compat.xml         |   10 ++
 Documentation/DocBook/media/v4l/controls.xml       |  161 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |   16 ++-
 drivers/media/video/gspca/sonixj.c                 |   23 +++
 drivers/media/video/gspca/zc3xx.c                  |   54 +++++--
 drivers/media/video/v4l2-ctrls.c                   |   24 +++
 include/linux/videodev2.h                          |   24 +++
 9 files changed, 322 insertions(+), 19 deletions(-)

--
Thanks,
Sylwester

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg41070.html
