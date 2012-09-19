Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1109 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2ISOie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 10:38:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/6] v4l2-ioctl,c: handle PREPARE_BUF like QUERYBUF.
Date: Wed, 19 Sep 2012 16:37:39 +0200
Message-Id: <a11e758478fdb4940028fee8e7d26840143ce335.1348064901.git.hans.verkuil@cisco.com>
In-Reply-To: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
References: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The core code for PREPARE_BUF didn't take the multiplanar case into account,
which might cause page faults. Handle PREPARE_BUF just like QUERYBUF and
QBUF/DQBUF.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 932d9bf..bbbda4e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2173,6 +2173,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 	int ret = 0;
 
 	switch (cmd) {
+	case VIDIOC_PREPARE_BUF:
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
 	case VIDIOC_DQBUF: {
-- 
1.7.10.4

