Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3U3TH7L019947
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 23:29:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3U3T4vt016296
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 23:29:04 -0400
Date: Wed, 30 Apr 2008 00:27:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080430002746.393e68e9@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes for 2.6.26
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following trivial fixes:

   - Fix merge conflicts on Kconfig items;
   - two small fixes on ivtv;
   - a warning fix at cx88;
   - tuners/Kconfig: Change config name and help to reflect dynamic load for 
     tuners.

Cheers,
Mauro.

---

 drivers/media/common/tuners/Kconfig     |    9 +++++++--
 drivers/media/video/cx18/Kconfig        |    2 +-
 drivers/media/video/cx18/cx18-driver.c  |    2 +-
 drivers/media/video/cx88/cx88-i2c.c     |    1 -
 drivers/media/video/ivtv/ivtv-driver.c  |    6 +++---
 drivers/media/video/ivtv/ivtv-fileops.c |    4 +++-
 drivers/media/video/tuner-core.c        |    2 +-
 7 files changed, 16 insertions(+), 10 deletions(-)

Hans Verkuil (1):
      V4L/DVB (7791): ivtv: POLLHUP must be returned on eof

Mauro Carvalho Chehab (3):
      V4L/DVB (7789b): Fix merge conflicts
      V4L/DVB (7794): cx88: Fix a warning
      V4L/DVB (7798): tuners/Kconfig: Change config name and help to reflect dynamic load for tuners

Robert P. J. Day (1):
      V4L/DVB (7792): ivtv: correct misspelled "HIMEM4G" to "HIGHMEM4G" in error message

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
