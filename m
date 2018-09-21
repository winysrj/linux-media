Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39900 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389444AbeIUOpc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 10:45:32 -0400
Date: Fri, 21 Sep 2018 11:57:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [GIT FIXES for 4.19] Prevent freeing media subscriptions while
 they're being accessed
Message-ID: <20180921085738.mmupbnn7wjzhchxf@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There's just a single patch in this pull request: the one that prevents
releasing media event subscription memory while it is still being accessed.

Compared to what was last reviewed on the list, I added Cc to stable, for
this patch applies to 4.14 as well.

Older LTS kernels (3.16, 4.4 and 4.9) need changes to the patch. I'll send
them separately to stable@vger..., cc'ing you, Hans and Laurent as well as
the list once this is in.

Please pull.


The following changes since commit 324493fba77500592bbaa66421729421f139d4b5:

  media: platform: fix cros-ec-cec build error (2018-09-17 14:32:29 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/event-fix-6

for you to fetch changes up to 88372fdff68f864316fbd7d9e9941ae24dc110eb:

  v4l: event: Prevent freeing event subscriptions while accessed (2018-09-21 11:52:08 +0300)

----------------------------------------------------------------
v4l2 event memory corruption fix

----------------------------------------------------------------
Sakari Ailus (1):
      v4l: event: Prevent freeing event subscriptions while accessed

 drivers/media/v4l2-core/v4l2-event.c | 38 +++++++++++++++++++-----------------
 drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
 include/media/v4l2-fh.h              |  4 ++++
 3 files changed, 26 insertions(+), 18 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
