Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41537 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934059AbbHKLuM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 07:50:12 -0400
Received: from [10.54.92.107] (unknown [173.38.220.39])
	by tschai.lan (Postfix) with ESMTPSA id 125EC2A0089
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2015 13:49:41 +0200 (CEST)
Message-ID: <55C9E0E5.1020900@xs4all.nl>
Date: Tue, 11 Aug 2015 13:47:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A small vivid improvement and two patches that fix compiler/linker warnings.

Regards,

	Hans

The following changes since commit 267897a4708fd7a0592333f33a4a7c393c999ab7:

  [media] tda10071: implement DVBv5 statistics (2015-08-11 07:34:58 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3f

for you to fetch changes up to c947b28da693d6c05c87a3aefc7bd6a261bf07a5:

  mt9v032: fix uninitialized variable warning (2015-08-11 13:47:47 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      mt9v032: fix uninitialized variable warning

Philipp Zabel (1):
      v4l2: move tracepoint generation into separate file

Prashant Laddha (1):
      vivid: support cvt, gtf timings for video out

 drivers/media/i2c/mt9v032.c                  |  2 +-
 drivers/media/platform/vivid/vivid-vid-out.c | 15 +++++++++++++--
 drivers/media/v4l2-core/Makefile             |  3 +++
 drivers/media/v4l2-core/v4l2-ioctl.c         |  1 -
 drivers/media/v4l2-core/v4l2-trace.c         | 11 +++++++++++
 5 files changed, 28 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-trace.c
