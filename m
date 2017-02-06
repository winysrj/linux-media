Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33304
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752688AbdBFPJ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 10:09:59 -0500
Date: Mon, 6 Feb 2017 13:09:51 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.10] CEC fixes
Message-ID: <20170206130951.15e6026d@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-3

For a few documentation fixes at CEC (with got promoted from staging for 4.10),
and one fix on its core.

Thanks!
Mauro

-

The following changes since commit 0e0694ff1a7791274946b7f51bae692da0001a08:

  Merge branch 'patchwork' into v4l_for_linus (2016-12-26 14:09:28 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-3

for you to fetch changes up to f9f96fc10c09ca16e336854c08bc1563eed97985:

  [media] cec: fix wrong last_la determination (2017-01-30 11:42:31 -0200)

----------------------------------------------------------------
media fixes for v4.10

----------------------------------------------------------------
Hans Verkuil (3):
      [media] cec rst: remove "This API is not yet finalized" notice
      [media] cec-intro.rst: mention the v4l-utils package and CEC utilities
      [media] cec: fix wrong last_la determination

 Documentation/media/uapi/cec/cec-func-close.rst         |  5 -----
 Documentation/media/uapi/cec/cec-func-ioctl.rst         |  5 -----
 Documentation/media/uapi/cec/cec-func-open.rst          |  5 -----
 Documentation/media/uapi/cec/cec-func-poll.rst          |  5 -----
 Documentation/media/uapi/cec/cec-intro.rst              | 17 ++++++++++++-----
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst    |  5 -----
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst         |  5 -----
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst         |  5 -----
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst        |  5 -----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst         |  5 -----
 Documentation/media/uapi/cec/cec-ioc-receive.rst        |  5 -----
 drivers/media/cec/cec-adap.c                            |  2 +-
 12 files changed, 13 insertions(+), 56 deletions(-)

