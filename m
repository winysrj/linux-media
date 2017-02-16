Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51126
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932637AbdBPR7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 12:59:24 -0500
Date: Thu, 16 Feb 2017 15:59:17 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.10] media fixes
Message-ID: <20170216155917.01de41c8@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-5

>From a regression fix that makes the Siano driver to work again after the
CONFIG_VMAP_STACK change.

Regards,
Mauro

The following changes since commit 42980da2eb7eb9695d8efc0c0ef145cbbb993b2c:

  [media] cec: initiator should be the same as the destination for, poll (2017-02-13 14:34:11 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-5

for you to fetch changes up to f9c85ee67164b37f9296eab3b754e543e4e96a1c:

  [media] siano: make it work again with CONFIG_VMAP_STACK (2017-02-14 18:13:49 -0200)

----------------------------------------------------------------
media fixes for v4.10-rc9

----------------------------------------------------------------
Mauro Carvalho Chehab (1):
      [media] siano: make it work again with CONFIG_VMAP_STACK

 drivers/media/usb/siano/smsusb.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)
