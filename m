Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33215 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab1JWX7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Oct 2011 19:59:30 -0400
Subject: [GIT PULL] ivtv, cx18: FM radio fixes
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ian Armstrong <mail01@iarmst.co.uk>,
	Sven Verdoolaege <skimo@kotnet.org>
Date: Sun, 23 Oct 2011 20:01:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1319414487.17800.8.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull two changes that fix FM radio in ivtv and cx18.  Thanks go
to Ian Armstrong for finding and fixing the ivtv problem.

Regards,
Andy


The following changes since commit 35a912455ff5640dc410e91279b03e04045265b2:

  Merge branch 'v4l_for_linus' into staging/for_v3.2 (2011-10-19 12:41:18 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/awalls/media_tree.git fm_radio

Andy Walls (1):
      cx18: Fix FM radio

Ian Armstrong (1):
      ivtv: Fix radio support

 drivers/media/video/cx18/cx18-driver.c |    2 ++
 drivers/media/video/ivtv/ivtv-driver.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)


