Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41290 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726340AbeJSPFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 11:05:55 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] request_api: Rename vb2_m2m_request_queue
Message-ID: <f1b281ca-e69d-af63-9478-f5be6f2c6fd6@xs4all.nl>
Date: Fri, 19 Oct 2018 09:01:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just one patch that renames vb2_m2m_request_queue to v4l2_m2m_request_queue.

Regards,

	Hans

The following changes since commit e4183d3256e3cd668e899d06af66da5aac3a51af:

  media: dt-bindings: Document the Rockchip VPU bindings (2018-10-05 07:00:43 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20j

for you to fetch changes up to f25cd39d7b98d953e6868ce969f3862f7c2e8425:

  media: Rename vb2_m2m_request_queue -> v4l2_m2m_request_queue (2018-10-19 08:55:20 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ezequiel Garcia (1):
      media: Rename vb2_m2m_request_queue -> v4l2_m2m_request_queue

 drivers/media/platform/vim2m.c              | 2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c      | 4 ++--
 drivers/staging/media/sunxi/cedrus/cedrus.c | 2 +-
 include/media/v4l2-mem2mem.h                | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
