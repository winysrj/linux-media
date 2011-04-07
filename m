Return-path: <mchehab@pedra>
Received: from smtp208.alice.it ([82.57.200.104]:38618 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1DGPqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Apr 2011 11:46:08 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Steven Toth <stoth@kernellabs.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Drew Fisher <drew.m.fisher@gmail.com>,
	OpenKinect <openkinect@googlegroups.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add a GSPCA subdriver for the Microsoft Kinect sensor
Date: Thu,  7 Apr 2011 17:45:50 +0200
Message-Id: <1302191152-7218-1-git-send-email-ospite@studenti.unina.it>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This patchset adds support for using the Kinect[1] sensor device as a 
regular Webcam or as a IR camera.
[1] http://en.wikipedia.org/wiki/Kinect

The first patch adds a new Y10B pixelformat used to expose the raw IR 
data the sensor can provide, the second patch adds a gspca subdriver for 
the Kinect sensor.

There was some positive feedback about calling the new format Y10B from 
Hans Verkuil, Mauro Carvalho Chehab and Guennadi Liakhovetski.

Any comment is appreciated.

Thanks,
   Antonio

Antonio Ospite (2):
  Add Y10B, a 10 bpp bit-packed greyscale format.
  gspca: add a subdriver for the Microsoft Kinect sensor device

 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt-y10b.xml |   43 +++
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 Documentation/DocBook/v4l/videodev2.h.xml |    3 +
 drivers/media/video/gspca/Kconfig         |    9 +
 drivers/media/video/gspca/Makefile        |    2 +
 drivers/media/video/gspca/kinect.c        |  427 +++++++++++++++++++++++++++++
 include/linux/videodev2.h                 |    3 +
 8 files changed, 489 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10b.xml
 create mode 100644 drivers/media/video/gspca/kinect.c

-- 
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
