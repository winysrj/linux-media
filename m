Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42288 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1L0Tnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 14:43:51 -0500
Received: by eekc4 with SMTP id c4so11868452eek.19
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 11:43:50 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [RFC/PATCHv1 0/4] JPEG codecs control class
Date: Tue, 27 Dec 2011 20:43:27 +0100
Message-Id: <1325015011-11904-1-git-send-email-snjw23@gmail.com>
In-Reply-To: <4EBECD11.8090709@gmail.com>
References: <4EBECD11.8090709@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset is a follow up of an RFC which can be found here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg39012.html

It creates a new JPEG control class with a tiny amount of four controls
in it. It also adds V4L2_CID_JPEG_COMPRESSION_QUALITY control to two gspca
sub-devices: sonixj and zc3xx, as these where drivers I had the hardware
handy for. The gspca patches have been tested with v4l2ucp and v4l2-ctl.

The compression quality control together with other controls on a panel
is quite convenient. It allows to improve image quality instantly, without
a need for using additional application that handles VIDIOC_S/G_JPEGCOMP.


Thanks,
Sylwester


Sylwester Nawrocki (4):
  V4L: Add JPEG compression control class
  V4L: Add the JPEG compression control class documentation
  gspca: sonixj: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
  gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support

 Documentation/DocBook/media/v4l/biblio.xml         |   20 +++
 Documentation/DocBook/media/v4l/controls.xml       |  161 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |   16 ++-
 drivers/media/video/gspca/sonixj.c                 |   23 +++
 drivers/media/video/gspca/zc3xx.c                  |   54 +++++--
 drivers/media/video/v4l2-ctrls.c                   |   24 +++
 include/linux/videodev2.h                          |   26 +++
 7 files changed, 305 insertions(+), 19 deletions(-)

--
1.7.4.1
