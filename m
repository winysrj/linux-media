Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42704 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbeKSVrQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 16:47:16 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] vicodec fix, add action to cedrus TODO
Message-ID: <cd27f6e9-664a-51c7-3bf6-f67374ee7795@xs4all.nl>
Date: Mon, 19 Nov 2018 12:23:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new cedrus driver was missing an important action item in the TODO.

Fix a nasty buffer overrun in vicodec.

Regards,

	Hans

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20l

for you to fetch changes up to e90e965c32b299fe89d23f490146963fbbf490dd:

  vicodec: fix memchr() kernel oops (2018-11-19 12:21:26 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (2):
      cedrus: add action item to the TODO
      vicodec: fix memchr() kernel oops

 drivers/media/platform/vicodec/vicodec-core.c | 3 ++-
 drivers/staging/media/sunxi/cedrus/TODO       | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)
