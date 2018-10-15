Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58728 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbeJOSDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 14:03:35 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] cec: forgot to cancel delayed work
Message-ID: <1e9de472-d125-b6d6-f593-6abf29c8b291@xs4all.nl>
Date: Mon, 15 Oct 2018 12:18:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Urgent bug fix for kernel oops in CEC corner case.

Also Cc-ed for stable to 4.18 since it fixes a bug in commit 7ec2b3b941a6,
which was also slated for the stable release.

Regards,

	Hans

The following changes since commit 8caec72e8cbff65afa38928197bea5a393b67975:

  media: vivid: Support 480p for webcam capture (2018-10-09 10:37:54 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20i

for you to fetch changes up to 6ec72c987e0584cf72c7eda5a1fc7a8e1b409198:

  cec: forgot to cancel delayed work (2018-10-15 12:16:14 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (1):
      cec: forgot to cancel delayed work

 drivers/media/cec/cec-adap.c | 2 ++
 1 file changed, 2 insertions(+)
