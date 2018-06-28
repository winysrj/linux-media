Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33466 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbeF1T0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 15:26:18 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/2] v4l-helpers: Don't close the fd in {}_s_fd
Date: Thu, 28 Jun 2018 16:25:56 -0300
Message-Id: <20180628192557.22966-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When creating a second node via copy or assignment:

    node2 = node

The node being assigned to, i.e. node2, obtains the fd.
This causes a later call to node2.media_open to close()
the fd, thus unintendenly closing the original node fd,
via the call path (e.g. for media devices):

  node2.media_open
     v4l_media_open
        v4l_media_s_fd

Similar call paths apply for other device types.
Fix this by removing the close in xxx_s_fd.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 utils/common/v4l-helpers.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
index c37b72712126..83d8d7d9c073 100644
--- a/utils/common/v4l-helpers.h
+++ b/utils/common/v4l-helpers.h
@@ -444,9 +444,6 @@ static inline int v4l_s_fd(struct v4l_fd *f, int fd, const char *devname, bool d
 	struct v4l2_queryctrl qc;
 	struct v4l2_selection sel;
 
-	if (f->fd >= 0)
-		f->close(f);
-
 	f->fd = fd;
 	f->direct = direct;
 	if (fd < 0)
@@ -492,9 +489,6 @@ static inline int v4l_open(struct v4l_fd *f, const char *devname, bool non_block
 
 static inline int v4l_subdev_s_fd(struct v4l_fd *f, int fd, const char *devname)
 {
-	if (f->fd >= 0)
-		f->close(f);
-
 	f->fd = fd;
 	f->direct = false;
 	if (fd < 0)
@@ -525,9 +519,6 @@ static inline int v4l_subdev_open(struct v4l_fd *f, const char *devname, bool no
 
 static inline int v4l_media_s_fd(struct v4l_fd *f, int fd, const char *devname)
 {
-	if (f->fd >= 0)
-		f->close(f);
-
 	f->fd = fd;
 	f->direct = false;
 	if (fd < 0)
-- 
2.18.0.rc2
