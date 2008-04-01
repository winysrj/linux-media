Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31Mphqd027788
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:51:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31MpUbL023327
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:51:30 -0400
Date: Tue, 1 Apr 2008 19:50:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080401195050.470c8edb@gaivota>
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

For the following fixes and regressions:
	- bttv fixes for bugzilla regressions #10027 and #10364;
	- cx23885 fixes for some regressions;
	- add missing MODULE_LICENSE to v4l2-int-device;
	- radio-cadet compilation fixes for PNP probe code.

One of the changes of cx23885 is bigger, since it simplified the on-chip memory
usage.

All changes are trivial.

Cheers,
Mauro.

---

 drivers/media/radio/radio-cadet.c           |    6 +
 drivers/media/video/bt8xx/bttv-driver.c     |   31 +++++--
 drivers/media/video/cx23885/cx23885-cards.c |    6 +-
 drivers/media/video/cx23885/cx23885-core.c  |  134 +--------------------------
 drivers/media/video/v4l2-int-device.c       |    2 +
 5 files changed, 38 insertions(+), 141 deletions(-)

Adrian Bunk (1):
      V4L/DVB (7485): v4l2-int-device.c: add MODULE_LICENSE

Bjorn Helgaas (1):
      V4L/DVB (7486): radio-cadet: wrap PNP probe code in #ifdef CONFIG_PNP

Cyrill Gorcunov (1):
      V4L/DVB (7461): bttv: fix missed index check

Robert Fitzsimons (3):
      V4L/DVB (7277): bttv: Re-enabling radio support requires the use of struct bttv_fh
      V4L/DVB (7278): bttv: Re-enable radio tuner support for VIDIOCGFREQ/VIDIOCSFREQ ioctls
      V4L/DVB (7400): bttv: Add a radio compat_ioctl file operation

Steven Toth (3):
      V4L/DVB (7464): Convert driver to use a single SRAM memory map
      V4L/DVB (7465): Fix eeprom parsing and errors on the HVR1800 products
      V4L/DVB (7466): Avoid minor model number warning when an OEM HVR1250 board is detected

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
