Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42594 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751544AbeA3SVu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 13:21:50 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16] v4l2-compat-ioctl32.c: make ctrl_is_pointer work
 for subdevs
Message-ID: <2f94b076-c3bf-f661-47da-d257daf439f1@xs4all.nl>
Date: Tue, 30 Jan 2018 19:21:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a1dfb4c48cc1e64eeb7800a27c66a6f7e88d075a:

  media: v4l2-compat-ioctl32.c: refactor compat ioctl32 logic (2018-01-30 07:40:41 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git compatcve

for you to fetch changes up to 3630d4b1da37817970f76f706bc44d30ba4fc081:

  v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs (2018-01-30 19:17:38 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs

 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
