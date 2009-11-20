Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58615 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbZKTDYw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 22:24:52 -0500
Received: by ywh40 with SMTP id 40so1937121ywh.33
        for <linux-media@vger.kernel.org>; Thu, 19 Nov 2009 19:24:58 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 00/11] add linux driver for chip TLG2300
Date: Fri, 20 Nov 2009 11:24:42 +0800
Message-Id: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TLG2300 is a chip of Telegent System.
It support analog tv,DVB-T and radio in a single chip.
The chip has been used in several dongles, such as aeromax DH-9000:
	http://www.b2bdvb.com/dh-9000.htm

You can get more info from:
	[1] http://www.telegent.com/
	[2] http://www.telegent.com/press/2009Sept14_CSI.html

Huang Shijie (10):
  add maitainers for tlg2300
  add readme file for tlg2300
  add Kconfig and Makefile for tlg2300
  add header files for tlg2300
  add the generic file
  add video file for tlg2300
  add vbi code for tlg2300
  add audio support for tlg2300
  add DVB-T support for tlg2300
  add FM support for tlg2300

root (1):
  modify video's Kconfig and Makefile for tlg2300

 Documentation/video4linux/README.tlg2300  |  229 ++++
 MAINTAINERS                               |    6 +
 drivers/media/video/Kconfig               |    2 +
 drivers/media/video/Makefile              |    1 +
 drivers/media/video/tlg2300/Kconfig       |   16 +
 drivers/media/video/tlg2300/Makefile      |    9 +
 drivers/media/video/tlg2300/pd-alsa.c     |  379 +++++++
 drivers/media/video/tlg2300/pd-bufqueue.c |  185 ++++
 drivers/media/video/tlg2300/pd-common.h   |  318 ++++++
 drivers/media/video/tlg2300/pd-dvb.c      |  649 ++++++++++++
 drivers/media/video/tlg2300/pd-main.c     |  546 ++++++++++
 drivers/media/video/tlg2300/pd-radio.c    |  383 +++++++
 drivers/media/video/tlg2300/pd-vbi.c      |  183 ++++
 drivers/media/video/tlg2300/pd-video.c    | 1636 +++++++++++++++++++++++++++++
 drivers/media/video/tlg2300/vendorcmds.h  |  243 +++++
 15 files changed, 4785 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/README.tlg2300
 create mode 100644 drivers/media/video/tlg2300/Kconfig
 create mode 100644 drivers/media/video/tlg2300/Makefile
 create mode 100644 drivers/media/video/tlg2300/pd-alsa.c
 create mode 100644 drivers/media/video/tlg2300/pd-bufqueue.c
 create mode 100644 drivers/media/video/tlg2300/pd-common.h
 create mode 100644 drivers/media/video/tlg2300/pd-dvb.c
 create mode 100644 drivers/media/video/tlg2300/pd-main.c
 create mode 100644 drivers/media/video/tlg2300/pd-radio.c
 create mode 100644 drivers/media/video/tlg2300/pd-vbi.c
 create mode 100644 drivers/media/video/tlg2300/pd-video.c
 create mode 100644 drivers/media/video/tlg2300/vendorcmds.h

