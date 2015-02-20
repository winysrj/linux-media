Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:55170 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbbBTJZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 04:25:31 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4B3A42A009F
	for <linux-media@vger.kernel.org>; Fri, 20 Feb 2015 10:25:06 +0100 (CET)
Message-ID: <54E6FD72.7080305@xs4all.nl>
Date: Fri, 20 Feb 2015 10:25:06 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.20] vb2: fix 'UNBALANCED' warnings when calling
 vb2_thread_stop()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 135f9be9194cf7778eb73594aa55791b229cf27c:

  [media] dvb_frontend: start media pipeline while thread is running (2015-02-13 21:10:17 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20g

for you to fetch changes up to 3f84327b694577d8e4b520d38a0353dfa54e83e8:

  vb2: fix 'UNBALANCED' warnings when calling vb2_thread_stop() (2015-02-20 10:22:56 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      vb2: fix 'UNBALANCED' warnings when calling vb2_thread_stop()

 drivers/media/v4l2-core/videobuf2-core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)
