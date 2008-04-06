Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m36K6cHI024609
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 16:06:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m36K6J4k025537
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 16:06:20 -0400
Date: Sun, 6 Apr 2008 17:06:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080406170601.7c8f9711@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes for 2.6.25-rc8
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

For the following:

   - bttv: Bt832 - fix possible NULL pointer deref
   - s5h1409: fix blown-away bit in function s5h1409_set_gpio
   - v4l/dvb Kconfig: Fix bugzilla #10067

Cheers,
Mauro.

---

 drivers/media/Makefile                |    3 +++
 drivers/media/dvb/frontends/s5h1409.c |    2 +-
 drivers/media/video/bt8xx/bt832.c     |   12 +++++++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

Cyrill Gorcunov (1):
      V4L/DVB (7460): bttv: Bt832 - fix possible NULL pointer deref

Mauro Carvalho Chehab (1):
      V4L/DVB (7499): v4l/dvb Kconfig: Fix bugzilla #10067

Michael Krufky (1):
      V4L/DVB (7495): s5h1409: fix blown-away bit in function s5h1409_set_gpio

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
