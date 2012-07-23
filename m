Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1186 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2GWLIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 07:08:06 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id q6NB82SU089512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 13:08:04 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.195])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 7873246A0006
	for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 13:08:01 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] mem2mem_testdev: fix v4l2-compliance errors
Date: Mon, 23 Jul 2012 13:08:01 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231308.01648.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

These patches fix v4l2-compliance errors in mem2mem_testdev.

Two core fixes (v4l2-dev.c and v4l2-mem2mem.c) and the other fixes are all in
the driver itself.

Regards,

	Hans

The following changes since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:

  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git m2m

for you to fetch changes up to 3397e353a24c32221363ba1438ab03364c08b8a9:

  v4l2-dev: G_PARM was incorrectly enabled for all video nodes. (2012-07-19 13:49:25 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      mem2mem_testdev: convert to the control framework and v4l2_fh.
      mem2mem_testdev: set bus_info and device_caps.
      v4l2-mem2mem: support events in v4l2_m2m_poll.
      mem2mem_testdev: add control events support.
      mem2mem_testdev: set default size and fix colorspace.
      v4l2-dev: G_PARM was incorrectly enabled for all video nodes.

 drivers/media/video/mem2mem_testdev.c |  262 ++++++++++++++++++++++++++++-----------------------------------------
 drivers/media/video/v4l2-dev.c        |    3 +-
 drivers/media/video/v4l2-mem2mem.c    |   18 ++++-
 3 files changed, 126 insertions(+), 157 deletions(-)
