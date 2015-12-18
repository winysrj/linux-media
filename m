Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59428 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbbLRRdv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 12:33:51 -0500
Date: Fri, 18 Dec 2015 15:33:46 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.4-rc6] media fixes
Message-ID: <20151218153346.79127e7d@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.4-3

for you to fetch changes up to aa0850e1d56623845b46350ffd971afa9241886d:

  [media] airspy: increase USB control message buffer size (2015-12-18 15:25:29 -0200)

----------------------------------------------------------------
media fixes for v4.4-rc6

----------------------------------------------------------------
Antti Palosaari (3):
      [media] hackrf: fix possible null ptr on debug printing
      [media] hackrf: move RF gain ctrl enable behind module parameter
      [media] airspy: increase USB control message buffer size

Mauro Carvalho Chehab (1):
      [media] Revert "[media] ivtv: avoid going past input/audio array"

 drivers/media/pci/ivtv/ivtv-driver.c |  4 ++--
 drivers/media/usb/airspy/airspy.c    |  2 +-
 drivers/media/usb/hackrf/hackrf.c    | 13 ++++++++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

