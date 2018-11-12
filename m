Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43906 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbeKLTbX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 14:31:23 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] media-request fixes
Message-ID: <3742c407-8fdd-14e8-0635-89b216cc3241@xs4all.nl>
Date: Mon, 12 Nov 2018 10:38:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two trivial fixes:

Use proper wait_queue_head_t type. Add compat ioctl.

Regards,

	Hans

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20k

for you to fetch changes up to af4ea2b40dadadedf96c2f8c5424df748264caa0:

  media: media-request: Add compat ioctl (2018-11-12 10:34:32 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Jasmin Jessich (1):
      media: Use wait_queue_head_t for media_request

Jernej Skrabec (1):
      media: media-request: Add compat ioctl

 drivers/media/media-request.c | 3 +++
 include/media/media-request.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)
