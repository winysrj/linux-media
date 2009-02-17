Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55794 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbZBQOmA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 09:42:00 -0500
Date: Tue, 17 Feb 2009 11:41:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.29] V4L/DVB fixes
Message-ID: <20090217114150.302fc656@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following fixes:

   - dvb core: Revert a broken commit (dda06a8e4610757de) - This fixes 
	       a regression since kernel 2.6.27;
   - zoran: Update MAINTAINERS entry;
   - tuner: fix TUV1236D analog/digital setup;
   - radio-si470x.c: Correction of Stereo detection/setting and signal 
		     strength indication and fix LED status output
   - gspca:: Destroy the URBs at disconnection time;
   - ivtv: fix decoder crash regression and a regression in get sliced 
	   vbi format.

Cheers,
Mauro.

---

 MAINTAINERS                                |    6 ++--
 drivers/media/common/tuners/tuner-simple.c |   10 ++---
 drivers/media/dvb/dvb-core/dmxdev.c        |   16 ++++-----
 drivers/media/dvb/dvb-core/dvb_demux.c     |   16 +++-----
 drivers/media/radio/radio-si470x.c         |   55 +++++++++++++++++++++++-----
 drivers/media/video/gspca/gspca.c          |    5 +++
 drivers/media/video/ivtv/ivtv-ioctl.c      |   26 +++++++-------
 7 files changed, 84 insertions(+), 50 deletions(-)

Adam Baker (1):
      V4L/DVB (10619): gspca - main: Destroy the URBs at disconnection time.

Hans Verkuil (2):
      V4L/DVB (10625): ivtv: fix decoder crash regression
      V4L/DVB (10626): ivtv: fix regression in get sliced vbi format

Mauro Carvalho Chehab (2):
      V4L/DVB (10527): tuner: fix TUV1236D analog/digital setup
      V4L/DVB (10572): Revert commit dda06a8e4610757def753ee3a541a0b1a1feb36b

Tobias Lorenz (2):
      V4L/DVB (10532): Correction of Stereo detection/setting and signal strength indication
      V4L/DVB (10533): fix LED status output

Trent Piepho (1):
      V4L/DVB (10516a): zoran: Update MAINTAINERS entry

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
