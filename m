Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38855
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751453AbdBNIxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 03:53:03 -0500
Date: Tue, 14 Feb 2017 06:52:55 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.10] media fixes
Message-ID: <20170214065255.16dc8c87@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-4

For a regression fix on colorspace at V4L2 core and a CEC core bug that
makes it discard valid messages.

Thanks!
Mauro

The following changes since commit f9f96fc10c09ca16e336854c08bc1563eed97985:

  [media] cec: fix wrong last_la determination (2017-01-30 11:42:31 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-4

for you to fetch changes up to 42980da2eb7eb9695d8efc0c0ef145cbbb993b2c:

  [media] cec: initiator should be the same as the destination for, poll (2017-02-13 14:34:11 -0200)

----------------------------------------------------------------
media fixes for v4.10-rc8

----------------------------------------------------------------
Hans Verkuil (2):
      [media] videodev2.h: go back to limited range Y'CbCr for SRGB and, ADOBERGB
      [media] cec: initiator should be the same as the destination for, poll

 Documentation/media/uapi/v4l/pixfmt-007.rst | 23 +++++++++++++++++------
 drivers/media/cec/cec-adap.c                |  7 +++----
 include/uapi/linux/videodev2.h              |  7 +++----
 3 files changed, 23 insertions(+), 14 deletions(-)
