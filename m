Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53308 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbcCKTOM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 14:14:12 -0500
Date: Fri, 11 Mar 2016 16:13:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.4-rc8 or v4.5] media fixes
Message-ID: <20160311161350.02739e09@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-5

For one last time fix: It adds a code that prevents some media tools
like media-ctl to hide some entities that have their IDs out of the range
expected by those apps.

Thanks!
Mauro

---

The following changes since commit fbe093ac9f0201939279cdfe8b0fce20ce5ef7a9:

  [media] media: Sanitise the reserved fields of the G_TOPOLOGY IOCTL arguments (2016-03-03 18:10:53 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-5

for you to fetch changes up to b2cd27448b33de9069d580d8f229efef434b64e6:

  [media] media-device: map new functions into old types for legacy API (2016-03-10 15:10:59 -0300)

----------------------------------------------------------------
media fixes for v4.5-rc8

----------------------------------------------------------------
Mauro Carvalho Chehab (1):
      [media] media-device: map new functions into old types for legacy API

 drivers/media/media-device.c | 23 +++++++++++++++++++++++
 include/uapi/linux/media.h   |  6 +++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

