Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:2136 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab2IDNZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 09:25:04 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id q84DFHMe013161
	for <linux-media@vger.kernel.org>; Tue, 4 Sep 2012 13:15:17 GMT
From: Hans Verkuil <hansverk@cisco.com>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] VIDIOC_OVERLAY regression fix
Date: Tue, 4 Sep 2012 15:15:17 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209041515.17033.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

While working on something else I suddenly saw that the VIDIOC_OVERLAY support
was broken in 3.6. The vidioc_overlay op in v4l2-ioctls.h receives an unsigned int,
whereas the ioctl table in v4l2-ioctls.c assumed that it would be an unsigned int
pointer.

To fix this a small conversion function was made.

This patch applies to 3.7. By checking 'v4l2-core' to 'video' in the path of
the file this patch will also apply to 3.6.

All other ioctls that do this dereferencing are fine, it's just this one that's
failing.

Regards,

	Hans

The following changes since commit 79e8c7bebb467bbc3f2514d75bba669a3f354324:

  Merge tag 'v3.6-rc3' into staging/for_v3.7 (2012-08-24 11:25:10 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git overlay

for you to fetch changes up to 22ffede236c77ad0d4bff19a9cffe4f27bd05819:

  v4l2-ioctl.c: fix overlay support. (2012-09-04 15:08:01 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-ioctl.c: fix overlay support.

 drivers/media/v4l2-core/v4l2-ioctl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
