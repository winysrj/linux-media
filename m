Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4669 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2HATwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 15:52:49 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id q71Jqkj7074521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 1 Aug 2012 21:52:48 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.186])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 2496846A011C
	for <linux-media@vger.kernel.org>; Wed,  1 Aug 2012 21:52:47 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.6] VIDIOC_ENUM_FREQ_BANDS fix
Date: Wed, 1 Aug 2012 21:52:46 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208012152.46310.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When VIDIOC_ENUM_FREQ_BANDS is called for a driver that doesn't supply an
enum_freq_bands op, then it will fall back to reporting a single freq band
based on information from g_tuner or g_modulator.

Due to a bug this is an infinite list since the index field wasn't tested.

This patch fixes this and returns -EINVAL if index != 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index c3b7b5f..54f4ac6 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1853,6 +1853,8 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 			.type = type,
 		};
 
+		if (p->index)
+			return -EINVAL;
 		err = ops->vidioc_g_tuner(file, fh, &t);
 		if (err)
 			return err;
@@ -1870,6 +1872,8 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 
 		if (type != V4L2_TUNER_RADIO)
 			return -EINVAL;
+		if (p->index)
+			return -EINVAL;
 		err = ops->vidioc_g_modulator(file, fh, &m);
 		if (err)
 			return err;
