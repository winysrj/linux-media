Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58792
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750920AbcKYKXO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 05:23:14 -0500
Date: Fri, 25 Nov 2016 08:22:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [GIT PULL for v4.9] media fix for xc2028 driver
Message-ID: <20161125082240.0e6f8826@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.9-4

For a fix at the firmware load logic at the tuner-xc2028 driver.

Regards,
Mauro

---

The following changes since commit 9c763584b7c8911106bb77af7e648bef09af9d80:

  Linux 4.9-rc6 (2016-11-20 13:52:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.9-4

for you to fetch changes up to 22a1e7783e173ab3d86018eb590107d68df46c11:

  xc2028: Fix use-after-free bug properly (2016-11-23 21:04:26 -0200)

----------------------------------------------------------------
media fixes for v4.9-rc7

----------------------------------------------------------------
Takashi Iwai (1):
      xc2028: Fix use-after-free bug properly

 drivers/media/tuners/tuner-xc2028.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

