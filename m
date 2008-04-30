Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3ULBETR005538
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 17:11:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3ULB1Ov004122
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 17:11:01 -0400
Date: Wed, 30 Apr 2008 18:10:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080430181046.1c50fd48@gaivota>
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

For the following fixes:

   - Several fixes on error handling:
	- don't do symbol_put() if symbol_request() failed;
	- saa7134 and cx88: detach frontend, if tuner or Diseqc attach fails;
	- tuner: Failures at tuner_attach were producing OOPS;
   - Kbuild fixes:
	- cx23885 and soc_camera: fix kbuild dependencies.
   - Other fixes:
	- tea5767: return -EINVAL, instead of EINVAL;

The tea5767, saa7134 and cx88 bugs are very old. The error scenario introduced
by the lack of the compilation of the tuners (a lack of a obj-y += tuners/)
arised those issues and ultimately caused their fixes.

Cheers,
Mauro.

---

 drivers/media/common/tuners/tea5767.c     |    6 +-
 drivers/media/video/Kconfig               |    4 +-
 drivers/media/video/cx23885/Kconfig       |    2 +
 drivers/media/video/cx88/cx88-dvb.c       |  251 +++++++++++++++-------------
 drivers/media/video/em28xx/em28xx-dvb.c   |    1 -
 drivers/media/video/saa7134/saa7134-dvb.c |  140 ++++++++++++-----
 drivers/media/video/tuner-core.c          |   34 ++--
 7 files changed, 257 insertions(+), 181 deletions(-)

Andrew Morton (1):
      V4L/DVB (7800): tuner_symbol_probe(): don't do symbol_put() if symbol_request() failed

Guennadi Liakhovetski (1):
      V4L/DVB (7810): soc_camera: mt9v022 and mt9m001 depend on I2C

Mauro Carvalho Chehab (6):
      V4L/DVB (7801): saa7134: detach frontend, if tuner or Diseqc attach fails
      V4L/DVB (7802): tuner: Failures at tuner_attach were producing OOPS
      V4L/DVB (7804): tea5767: Fix error logic
      V4L/DVB (7805): saa7134: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7806): saa7134: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7807): cx88: Fix error handling, when dvb_attach() fails

Michael Krufky (1):
      V4L/DVB (7808): cx23885: fix kbuild dependencies

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
