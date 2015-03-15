Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57904 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbbCOM2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 08:28:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B065B2A0083
	for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 13:28:29 +0100 (CET)
Message-ID: <55057AED.7010304@xs4all.nl>
Date: Sun, 15 Mar 2015 13:28:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes found while testing drivers with v4l2-compliance.

Regards,

	Hans

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1k

for you to fetch changes up to 77b233e79baa96aa11a424e404c599b1daf26c6c:

  v4l2-ioctl: allow all controls if ctrl_class == 0 (2015-03-15 13:27:10 +0100)

----------------------------------------------------------------
Hans Verkuil (3):
      au0828: fix broken streaming
      v4l2-dev: disable selection ioctls for non-video devices
      v4l2-ioctl: allow all controls if ctrl_class == 0

 drivers/media/usb/au0828/au0828-video.c | 14 +++++++-------
 drivers/media/v4l2-core/v4l2-dev.c      | 16 ++++++++--------
 drivers/media/v4l2-core/v4l2-ioctl.c    |  2 ++
 3 files changed, 17 insertions(+), 15 deletions(-)
