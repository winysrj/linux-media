Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:26024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0L0LkJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 06:40:09 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBe8fN022997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:40:09 -0500
Received: from gaivota (vpn-11-156.rdu.redhat.com [10.11.11.156])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBd1iN001764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:40:07 -0500
Date: Mon, 27 Dec 2010 09:38:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/6] V4L1 cleanups and videodev.h removal
Message-ID: <20101227093848.324b6abd@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Now that all hard work to remove V4L1 happened, it doesn't make
sense on keeping videodev.h just because of two obsoleted drivers.

Let's just remove this thing and copy it to the two staging drivers
that still needs it.

While here, fix the remaining bits that were hit by:
	$ git grep videodev.h

After this series, the only places where videodev.h will show will be
at the V4L2 DocBook document that describes the migration (compat.xml)
and 3 drivers at staging: the two deprecated drivers and a very messy
driver for a few easycap boards that has its own internal copy of
videodev.h.

Mauro Carvalho Chehab (6):
  [media] Remove VIDEO_V4L1 Kconfig option
  [media] V4L1 removal: Remove linux/videodev.h
  Documentation/ioctl/ioctl-number.txt: Remove some now freed ioctl
    ranges
  [media] Fix videodev.h references at the V4L DocBook
  [media] Remove the old V4L1 v4lgrab.c file
  [media] omap_vout: Remove an obsolete comment

 Documentation/DocBook/v4l/func-ioctl.xml   |    5 +-
 Documentation/DocBook/v4l/pixfmt.xml       |    4 +-
 Documentation/feature-removal-schedule.txt |   17 --
 Documentation/ioctl/ioctl-number.txt       |    3 -
 Documentation/video4linux/v4lgrab.c        |  201 -----------------
 drivers/media/Kconfig                      |   14 --
 drivers/media/video/Kconfig                |    5 -
 drivers/media/video/omap/omap_vout.c       |    1 -
 drivers/media/video/v4l2-compat-ioctl32.c  |    1 -
 drivers/staging/se401/Kconfig              |    2 +-
 drivers/staging/se401/se401.h              |    2 +-
 drivers/staging/se401/videodev.h           |  318 +++++++++++++++++++++++++++
 drivers/staging/usbvideo/Kconfig           |    2 +-
 drivers/staging/usbvideo/usbvideo.h        |    2 +-
 drivers/staging/usbvideo/vicam.c           |    2 +-
 drivers/staging/usbvideo/videodev.h        |  318 +++++++++++++++++++++++++++
 fs/compat_ioctl.c                          |    2 +-
 include/linux/Kbuild                       |    1 -
 include/linux/videodev.h                   |  322 ----------------------------
 include/media/ovcamchip.h                  |   90 --------
 20 files changed, 646 insertions(+), 666 deletions(-)
 delete mode 100644 Documentation/video4linux/v4lgrab.c
 create mode 100644 drivers/staging/se401/videodev.h
 create mode 100644 drivers/staging/usbvideo/videodev.h
 delete mode 100644 include/linux/videodev.h
 delete mode 100644 include/media/ovcamchip.h

-- 
1.7.3.4

