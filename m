Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:44545 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbeJIO00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 10:26:26 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] v4l2-tpg kernel oops fix
Message-ID: <85176e7b-700d-db6c-c8a4-4bf01a9919fb@xs4all.nl>
Date: Tue, 9 Oct 2018 09:10:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 9e5b5081fa117ae34eca94b63b1cb6d43dc28f10:

  media: dw9807-vcm: Fix probe error handling (2018-10-08 11:51:31 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-for-v4.20g

for you to fetch changes up to 936f118946f8f8d35d96346641a5ec873ac8125d:

  v4l2-tpg: fix kernel oops when enabling HFLIP and OSD (2018-10-09 09:09:44 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-tpg: fix kernel oops when enabling HFLIP and OSD

 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
