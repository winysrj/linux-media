Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:49150 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761AbcEWLpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 07:45:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: David Binderman <linuxdev.baldrick@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for 4.7] v4l2-ioctl: fix stupid mistake in cropcap condition
Message-ID: <5742ED68.5020607@xs4all.nl>
Date: Mon, 23 May 2016 13:45:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix duplicate tests in condition. The second test for vidioc_cropcap
should have tested for vidioc_g_selection instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: David Binderman <linuxdev.baldrick@gmail.com>

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 28e5be2..528390f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2171,7 +2171,7 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	 * The determine_valid_ioctls() call already should ensure
 	 * that this can never happen, but just in case...
 	 */
-	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))
+	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_g_selection))
 		return -ENOTTY;

 	if (ops->vidioc_cropcap)
