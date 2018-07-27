Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54356 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731160AbeG0RCP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 13:02:15 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] v4l2-mem2mem regression fix
Message-ID: <424504e1-fb26-e4cd-5a6b-ee4a04d778a4@xs4all.nl>
Date: Fri, 27 Jul 2018 17:39:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4070fc9ade52f7d0ad1397fe74f564ae95e68a4f:

  media: rcar-csi2: update stream start for V3M (2018-07-27 09:01:07 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19p

for you to fetch changes up to 4eb7567f59f6568819c111c73ed0f7b0fed5f1b6:

  v4l2-mem2mem: Fix missing v4l2_m2m_try_run call (2018-07-27 17:31:36 +0200)

----------------------------------------------------------------
Ezequiel Garcia (1):
      v4l2-mem2mem: Fix missing v4l2_m2m_try_run call

 drivers/media/v4l2-core/v4l2-mem2mem.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)
