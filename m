Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:34143 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0BBHII (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 02:08:08 -0500
Received: by pxi12 with SMTP id 12so5432630pxi.33
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 23:08:07 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH v2 00/10] add linux driver for chip TLG2300
Date: Tue,  2 Feb 2010 15:07:46 +0800
Message-Id: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TLG2300 is a chip of Telegent System.
It support analog tv,DVB-T and radio in a single chip.
The chip has been used in several dongles, such as aeromax DH-9000:
	http://www.b2bdvb.com/dh-9000.htm

You can get more info from:
	[1] http://www.telegent.com/
	[2] http://www.telegent.com/press/2009Sept14_CSI.html

The driver is based Mauro's subtree(2.6.33-rc4).	
	
about country code:
	The country code is needed for firmware, so I can not remove it.
	If I remove it, the audio will not work properly.

about hibernate:
	My test environment:
	PC: dell vostro 200, 2G RAM, dual core 2G
	OS: Fedora 12 (kernel is compiled with Mauro's subtree, 2.6.33-rc4)
	my test shell script:
		------- file begin -------------
		" echo shutdown > /sys/power/disk"
		" echo disk > /sys/power/state"
		------- file end -------------
	
	the test result:
	[1] ANALOG TV : video runs well after hibernate,but alsa system did not resume the
		snd_pcm_substream.
	[2] DVB-T : runs profectly.
	[3] FM:	Mplayer will be terminated for the long delay of hibernate makes it
		close the audio. This is not a problem, just re-open it.

v1 --> v2 :
	[1] use the videobuf-vmalloc,remove old queue code.
	[2] change the V4L2 implementation, use the videobuf-core's code.
	[3] optimize the power management code.
	[4] misc bugs.


Huang Shijie (10):
  add header files for tlg2300
  add the generic file
  add video/vbi file for tlg2300
  add DVB-T support for tlg2300
  add FM support for tlg2300
  add audio support for tlg2300
  add document file for tlg2300
  add Kconfig and Makefile for tlg2300
  modify the Kconfig and Makefile for tlg2300
  add maintainers for tlg2300

 Documentation/video4linux/README.tlg2300 |  231 +++++
 MAINTAINERS                              |    8 +
 drivers/media/video/Kconfig              |    2 +
 drivers/media/video/Makefile             |    1 +
 drivers/media/video/tlg2300/Kconfig      |   16 +
 drivers/media/video/tlg2300/Makefile     |    9 +
 drivers/media/video/tlg2300/pd-alsa.c    |  332 ++++++
 drivers/media/video/tlg2300/pd-common.h  |  280 +++++
 drivers/media/video/tlg2300/pd-dvb.c     |  593 +++++++++++
 drivers/media/video/tlg2300/pd-main.c    |  566 ++++++++++
 drivers/media/video/tlg2300/pd-radio.c   |  351 +++++++
 drivers/media/video/tlg2300/pd-video.c   | 1648 ++++++++++++++++++++++++++++++
 drivers/media/video/tlg2300/vendorcmds.h |  243 +++++
 13 files changed, 4280 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/README.tlg2300
 create mode 100644 drivers/media/video/tlg2300/Kconfig
 create mode 100644 drivers/media/video/tlg2300/Makefile
 create mode 100644 drivers/media/video/tlg2300/pd-alsa.c
 create mode 100644 drivers/media/video/tlg2300/pd-common.h
 create mode 100644 drivers/media/video/tlg2300/pd-dvb.c
 create mode 100644 drivers/media/video/tlg2300/pd-main.c
 create mode 100644 drivers/media/video/tlg2300/pd-radio.c
 create mode 100644 drivers/media/video/tlg2300/pd-video.c
 create mode 100644 drivers/media/video/tlg2300/vendorcmds.h

