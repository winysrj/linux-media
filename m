Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42613 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933028AbbFEO3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:29:04 -0400
Received: from test-media.cisco.com (test [192.168.1.27])
	by tschai.lan (Postfix) with ESMTPSA id 458282A0085
	for <linux-media@vger.kernel.org>; Fri,  5 Jun 2015 16:28:52 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] vim2m improvements
Date: Fri,  5 Jun 2015 16:28:49 +0200
Message-Id: <1433514532-23306-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for VIDIOC_PREPARE_BUF to v4l2-mem2mem and use it in vim2m.
Also fix a small bug in the debug logging that's done by v4l2-ioctl.c.

After adding support for CREATE_BUFS in vim2m a v4l2-compliance bug was
found and v4l2-compliance has now been fixed.

Hans Verkuil (3):
  v4l2-mem2mem: add support for prepare_buf
  v4l2-ioctl: log buffer type 0 correctly
  vim2m: add create_bufs and prepare_buf support

 drivers/media/platform/vim2m.c         |  8 ++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c   |  1 +
 drivers/media/v4l2-core/v4l2-mem2mem.c | 28 ++++++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |  4 ++++
 4 files changed, 41 insertions(+)

-- 
2.1.4

